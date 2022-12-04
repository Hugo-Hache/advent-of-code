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

func ParseInterval(input string) utils.Interval {
	boundaries := strings.Split(input, "-")
	return utils.Interval{Min: utils.ToInt(boundaries[0]), Max: utils.ToInt(boundaries[1])}
}

func ParseLineIntervals(line string) []utils.Interval {
	interval_inputs := strings.Split(line, ",")
	line_intervals := make([]utils.Interval, len(interval_inputs))
	for i, interval_input := range interval_inputs {
		line_intervals[i] = ParseInterval(interval_input)
	}
	return line_intervals
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	fully_contained_count := 0
	for _, line := range lines {
		line_intervals := ParseLineIntervals(line)

		union := line_intervals[0]
		for i := 1; i < len(line_intervals); i++ {
			union = union.Union(line_intervals[i])
		}

		if utils.Contains(line_intervals, union) {
			fmt.Println(line_intervals)
			fully_contained_count += 1
		}
	}
	return fully_contained_count
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	overlapping_count := 0
	for _, line := range lines {
		line_intervals := ParseLineIntervals(line)

		if line_intervals[0].Inter(line_intervals[1]) != utils.EMPTY_INTERVAL {
			overlapping_count += 1
		}
	}
	return overlapping_count
}

func main() {
	fmt.Println("--2022 day 04 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
