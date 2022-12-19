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

var specific_cycles = []int{20, 60, 100, 140, 180, 220}

func MeasureSpecificCycle(cycle int, register int) int {
	if utils.Contains(specific_cycles, cycle) {
		return cycle * register
	}
	return 0
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	cycle := 1
	register := 1
	signal_strength := 0
	for _, line := range lines {
		signal_strength += MeasureSpecificCycle(cycle, register)
		words := strings.Split(line, " ")
		if words[0] == "addx" {
			cycle += 1
			signal_strength += MeasureSpecificCycle(cycle, register)
			register += utils.ToInt(words[1])
		}

		cycle += 1
	}
	return signal_strength
}

func DrawCrt(crt []bool) {
	for row := 0; row < 6; row++ {
		for col := 0; col < 40; col++ {
			if crt[row*40+col] {
				fmt.Print("#")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Print("\n")
	}
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	cycle := 1
	register := 1
	crt := make([]bool, 0)
	for _, line := range lines {
		crt = append(crt, cycle-1 >= register-1 && cycle-1 <= register+1)
		words := strings.Split(line, " ")
		if words[0] == "addx" {
			cycle = (cycle + 1) % 40
			crt = append(crt, cycle-1 >= register-1 && cycle-1 <= register+1)
			register += utils.ToInt(words[1])
		}

		cycle = (cycle + 1) % 40
	}

	DrawCrt(crt)
	return 0
}

func main() {
	fmt.Println("--2022 day 10 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
