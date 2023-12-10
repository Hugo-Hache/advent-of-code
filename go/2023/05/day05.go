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

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	paragraphs := strings.Split(input, "\n\n")

	re := regexp.MustCompile("([0-9]+)")
	seeds := utils.StringsToNumbers(re.FindAllString(paragraphs[0], -1))

	for _, paragraph := range paragraphs[1:] {
		new_seeds := make([]int, len(seeds))
		copy(new_seeds, seeds)

		lines := strings.Split(paragraph, "\n")
		for _, line := range lines[1:] {
			mapping := utils.StringsToNumbers(strings.Split(line, " "))
			for s, seed := range seeds {
				if seed >= mapping[1] && seed < mapping[1]+mapping[2] {
					new_seeds[s] = mapping[0] + (seed - mapping[1])
				}
			}
		}

		seeds = new_seeds
	}

	min := seeds[0]
	for _, seed := range seeds[1:] {
		min = utils.Min(min, seed)
	}

	return min
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	paragraphs := strings.Split(input, "\n\n")

	re := regexp.MustCompile("([0-9]+)")
	seeds := utils.StringsToNumbers(re.FindAllString(paragraphs[0], -1))
	var intervals []utils.Interval
	for i := 0; i < len(seeds); i += 2 {
		intervals = append(intervals, utils.Interval{Min: seeds[i], Max: seeds[i+1]})
	}

	for _, paragraph := range paragraphs[1:] {
		var new_intervals []utils.Interval

		lines := strings.Split(paragraph, "\n")
		for _, interval := range intervals {
			for _, line := range lines[1:] {
				mapping := utils.StringsToNumbers(strings.Split(line, " "))
				mapped_interval := utils.Interval{Min: mapping[1], Max: mapping[1] + mapping[2] - 1}
				intersection := interval.Inter(mapped_interval)
				if intersection != utils.EMPTY_INTERVAL {
					new_intervals = append(new_intervals, utils.Interval{Min: interval.Min, Max: intersection.Min - 1})
					new_intervals = append(new_intervals, utils.Interval{Min: mapping[0], Max: mapping[0] + intersection.Max - intersection.Min})
					new_intervals = append(new_intervals, utils.Interval{Min: intersection.Max + 1, Max: interval.Max})
				}
				// WIP
			}
		}

		intervals = new_intervals
	}

	return 0
}

func main() {
	fmt.Println("--2023 day 05 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
