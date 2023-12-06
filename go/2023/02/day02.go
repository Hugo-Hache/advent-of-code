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

var max = map[string]int{"red": 12, "green": 13, "blue": 14}

func PossibleGameId(line string) int {
	re := regexp.MustCompile("Game ([0-9]+): (.*)")
	matches := re.FindStringSubmatch(line)

	reveals := strings.Split(matches[2], "; ")
	for _, reveal := range reveals {
		draws := strings.Split(reveal, ", ")
		for _, draw := range draws {
			a := strings.Split(draw, " ")
			if utils.ToInt(a[0]) > max[a[1]] {
				return 0
			}
		}
	}

	return utils.ToInt(matches[1])
}

func PowerGame(line string) int {
	re := regexp.MustCompile("Game ([0-9]+): (.*)")
	matches := re.FindStringSubmatch(line)

	min := map[string]int{"red": 0, "green": 0, "blue": 0}
	reveals := strings.Split(matches[2], "; ")
	for _, reveal := range reveals {

		draws := strings.Split(reveal, ", ")
		for _, draw := range draws {
			a := strings.Split(draw, " ")
			number := utils.ToInt(a[0])
			if number > min[a[1]] {
				min[a[1]] = number
			}
		}
	}

	return min["red"] * min["green"] * min["blue"]
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	total := 0

	for _, line := range lines {
		total += PossibleGameId(line)
	}

	return total
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	total := 0

	for _, line := range lines {
		total += PowerGame(line)
	}

	return total
}

func main() {
	fmt.Println("--2023 day 02 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
