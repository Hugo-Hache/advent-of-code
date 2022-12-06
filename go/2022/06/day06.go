package main

import (
	_ "embed"
	"fmt"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

func Unduplicated(input string) bool {
	for i := 0; i < len(input); i++ {
		for j := i + 1; j < len(input); j++ {
			if input[i] == input[j] {
				return false
			}
		}
	}
	return true
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	for i := 0; i < len(input); i++ {
		if Unduplicated(input[i : i+4]) {
			return i + 4
		}
	}
	return 0
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	for i := 0; i < len(input); i++ {
		if Unduplicated(input[i : i+14]) {
			return i + 14
		}
	}
	return 0
}

func main() {
	fmt.Println("--2022 day 06 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
