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

func ParseStacks(input_stacks string) [][]string {
	lines := strings.Split(input_stacks, "\n")
	stack_count := len(strings.Split(lines[len(lines)-1], "   "))

	stacks := make([][]string, stack_count)
	for i := 0; i < stack_count; i++ {
		stacks[i] = make([]string, 0)
	}

	for i := len(lines) - 2; i >= 0; i-- {
		line := lines[i]
		for j := 0; j < stack_count; j++ {
			crate := string(line[1+j*4])
			if crate != " " {
				stacks[j] = append(stacks[j], crate)
			}
		}
	}

	return stacks
}

func Part1(input string) string {
	input = strings.TrimSuffix(input, "\n")
	input_blocks := strings.Split(input, "\n\n")
	input_stacks := input_blocks[0]
	input_commands := input_blocks[1]

	stacks := ParseStacks(input_stacks)

	for _, input_command := range strings.Split(input_commands, "\n") {
		words := strings.Split(input_command, " ")
		quantity := utils.ToInt(words[1])
		source := utils.ToInt(words[3]) - 1
		destination := utils.ToInt(words[5]) - 1

		for i := 0; i < quantity; i++ {
			stacks[destination] = append(stacks[destination], stacks[source][len(stacks[source])-1])
			stacks[source] = stacks[source][:len(stacks[source])-1]
		}
	}

	result := ""
	for _, stack := range stacks {
		result += stack[len(stack)-1]
	}
	return result
}

func Part2(input string) string {
	input = strings.TrimSuffix(input, "\n")
	input_blocks := strings.Split(input, "\n\n")
	input_stacks := input_blocks[0]
	input_commands := input_blocks[1]

	stacks := ParseStacks(input_stacks)

	for _, input_command := range strings.Split(input_commands, "\n") {
		words := strings.Split(input_command, " ")
		quantity := utils.ToInt(words[1])
		source := utils.ToInt(words[3]) - 1
		destination := utils.ToInt(words[5]) - 1

		stacks[destination] = append(stacks[destination], stacks[source][len(stacks[source])-quantity:]...)
		stacks[source] = stacks[source][:len(stacks[source])-quantity]
	}

	result := ""
	for _, stack := range stacks {
		result += stack[len(stack)-1]
	}
	return result
}

func main() {
	fmt.Println("--2022 day 05 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
