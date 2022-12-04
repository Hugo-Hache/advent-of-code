package main

import (
	_ "embed"
	"fmt"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

func Code(char byte) int {
	code := int(char)
	if code >= 97 { // 'a' is 97
		return code - 96
	} else { // 'A' is 65
		return code - 64 + 26
	}
}

func CommonChar(lines []string) byte {
	char_count := make(map[byte]int)

	for _, line := range lines {
		line_chars := make(map[byte]int)
		for i := 0; i < len(line); i++ {
			line_chars[line[i]] = 1
		}

		for char := range line_chars {
			char_count[char] += 1
		}
	}

	for char, count := range char_count {
		if count == len(lines) {
			return char
		}
	}

	return '$'
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	total_priority := 0
	for _, line := range lines {
		first_half := line[0 : len(line)/2]
		second_half := line[len(line)/2:]
		total_priority += Code(CommonChar([]string{first_half, second_half}))
	}
	return total_priority
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	total_priority := 0
	for i := 0; i < len(lines); i += 3 {
		total_priority += Code(CommonChar(lines[i : i+3]))
	}
	return total_priority
}

func main() {
	fmt.Println("--2022 day 03 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
