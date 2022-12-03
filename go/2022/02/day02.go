package main

import (
	_ "embed"
	"fmt"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

var points = map[string]int{"A X": 4, "B X": 1, "C X": 7, "A Y": 8, "B Y": 5, "C Y": 2, "A Z": 3, "B Z": 9, "C Z": 6}

func Part1(input string) int {
	lines := strings.Split(input, "\n")
	total_points := 0
	for _, line := range lines {
		total_points += points[line]
	}
	return total_points
}

var points2 = map[string]int{"A X": 3, "B X": 1, "C X": 2, "A Y": 4, "B Y": 5, "C Y": 6, "A Z": 8, "B Z": 9, "C Z": 7}

func Part2(input string) int {
	lines := strings.Split(input, "\n")
	total_points := 0
	for _, line := range lines {
		total_points += points2[line]
	}
	return total_points
}

func main() {
	fmt.Println("--2022 day 02 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
