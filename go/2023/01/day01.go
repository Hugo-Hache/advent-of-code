package main

import (
	"aoc/utils"
	_ "embed"
	"fmt"
	"strings"
	"time"
	"unicode"
)

//go:embed input.txt
var input_day string

func Part1(input string) int {
	lines := strings.Split(input, "\n")
	total := 0
	for _, line := range lines {
		first_digit := 'X'
		second_digit := 'X'
		for _, char := range line {
			if unicode.IsDigit(char) {
				if first_digit == 'X' {
					first_digit = char
				}
				second_digit = char
			}
		}
		calibration := utils.ToInt(string([]rune{first_digit, second_digit}))
		total += calibration
	}
	return total
}

func Part2(input string) int {
	lines := strings.Split(input, "\n")
	total := 0

	h := map[rune][]string{
		'1': {"1", "one"},
		'2': {"2", "two"},
		'3': {"3", "three"},
		'4': {"4", "four"},
		'5': {"5", "five"},
		'6': {"6", "six"},
		'7': {"7", "seven"},
		'8': {"8", "eight"},
		'9': {"9", "nine"},
	}

	for _, line := range lines {
		first_digit := 'X'
		second_digit := 'X'

		for i := 0; i < len(line); i++ {
			for digit, substrings := range h {
				for _, substring := range substrings {
					if i+len(substring) <= len(line) && line[i:i+len(substring)] == substring {
						if first_digit == 'X' {
							first_digit = digit
						}
						second_digit = digit

						// i += len(substring) - 1
					}
				}
			}
		}

		calibration := utils.ToInt(string([]rune{first_digit, second_digit}))
		total += calibration
	}
	return total
}

func main() {
	fmt.Println("--2023 day 01 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
