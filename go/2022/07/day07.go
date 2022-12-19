package main

import (
	"aoc/utils"
	_ "embed"
	"fmt"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

func Join(arr []string, joiner string) string {
	result := arr[0]
	for i := 1; i < len(arr); i++ {
		result += joiner + arr[i]
	}
	return result
}

func ParseDirectorySize(input string) map[string]int {
	input = strings.TrimSuffix(input, "\n")
	blocks := strings.Split(input, "$ ")
	parent_directories := make([]string, 0)
	directory_size := make(map[string]int)
	for _, block := range blocks {
		fmt.Println("par dir: ", parent_directories)
		fmt.Println("dir size: ", directory_size)
		fmt.Println("block: ", strings.TrimSuffix(block, "\n"))
		lines := strings.Split(strings.TrimSuffix(block, "\n"), "\n")
		instruction := strings.Split(lines[0], " ")
		output := lines[1:]

		command := instruction[0]
		fmt.Println("command: ", command)
		fmt.Println("output: ", output)
		if command == "cd" {
			if instruction[1] == ".." {
				parent_directories = parent_directories[:len(parent_directories)-1]
			} else {
				parent_directories = append(parent_directories, instruction[1])
			}
		} else if command == "ls" {
			for _, output_line := range output {
				fmt.Println("output line: ", output_line)
				output_words := strings.Split(output_line, " ")
				if output_words[0] != "dir" {
					size := utils.ToInt(output_words[0])
					for i := 0; i < len(parent_directories); i++ {
						directory := Join(parent_directories[:i+1], "/")
						fmt.Println("Adding ", size, " to ", directory)
						directory_size[directory] += size
					}
				}
			}
		} else {
			fmt.Println("Unknown command ", command)
		}
	}
	return directory_size
}

func Part1(input string) int {
	directory_size := ParseDirectorySize(input)

	sum := 0
	for _, size := range directory_size {
		if size <= 100000 {
			sum += size
		}
	}
	return sum
}

func Part2(input string) int {
	total_disk_space := 70000000
	needed_space := 30000000

	directory_size := ParseDirectorySize(input)
	available_space := total_disk_space - directory_size["/"]
	to_reclaim_space := needed_space - available_space

	smallest_directory_size := total_disk_space
	for _, size := range directory_size {
		if size >= to_reclaim_space && size < smallest_directory_size {
			smallest_directory_size = size
		}
	}
	return smallest_directory_size
}

func main() {
	fmt.Println("--2022 day 07 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
