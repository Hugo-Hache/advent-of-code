package main

import (
	"aoc/utils"
	_ "embed"
	"fmt"
	"regexp"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

func Winning(line string) int {
	re := regexp.MustCompile("Card[ 0-9]+: ([0-9 ]+) \\| ([0-9 ]+)")
	matches := re.FindStringSubmatch(line)

	re2 := regexp.MustCompile(" +")
	winning_numbers := re2.Split(matches[1], -1)
	numbers := re2.Split(matches[2], -1)

	count := 0
	for _, number := range winning_numbers {
		if len(number) > 0 && utils.Contains(numbers, number) {
			count += 1
		}
	}

	return count
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	total_points := 0
	for _, line := range lines {
		count := Winning(line)
		if count > 0 {
			total_points += (1 << (count - 1))
		}
	}

	return total_points
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	instances := map[int]int{}
	for i, _ := range lines {
		instances[i] = 1
	}

	for i, line := range lines {
		count := Winning(line)
		for j := i + 1; j <= i+count; j++ {
			instances[j] += instances[i]
		}
	}

	total_instances := 0
	for _, instance := range instances {
		total_instances += instance
	}
	return total_instances
}

func main() {
	fmt.Println("--2023 day 04 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
