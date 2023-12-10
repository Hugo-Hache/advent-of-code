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
	lines := strings.Split(input, "\n")

	re := regexp.MustCompile(`\d+`)
	times := utils.StringsToNumbers(re.FindAllString(lines[0], -1))
	distances := utils.StringsToNumbers(re.FindAllString(lines[1], -1))

	ways_product := 1
	for i, distance := range distances {
		time := times[i]

		ways := 0
		for i := 0; i < time; i++ {
			if (i * (time - i)) > distance {
				ways += 1
			}
		}
		fmt.Println(ways)

		ways_product *= ways
	}

	return ways_product
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	re := regexp.MustCompile(`\d+`)
	time := utils.ToInt(strings.Join(re.FindAllString(lines[0], -1), ""))
	distance := utils.ToInt(strings.Join(re.FindAllString(lines[1], -1), ""))

	ways := 0
	for i := 0; i < time; i++ {
		if (i * (time - i)) > distance {
			ways += 1
		}
	}
	fmt.Println(ways)

	return ways
}

func main() {
	fmt.Println("--2023 day 06 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
