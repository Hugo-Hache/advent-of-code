package main

import (
	"aoc/utils"
	_ "embed"
	"fmt"
	"sort"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

func Part1(input string) int {
	lines := strings.Split(input, "\n\n")
	max_calories := 0
	for _, elf_list := range lines {
		items := utils.LinesToNumbers(elf_list)
		calories := utils.Sum(items)
		max_calories = utils.Max(calories, max_calories)
	}
	return max_calories
}

func Part2(input string) int {
	lines := strings.Split(input, "\n\n")
	all_calories := make([]int, len(lines))
	for _, elf_list := range lines {
		items := utils.LinesToNumbers(elf_list)
		calories := utils.Sum(items)
		all_calories = append(all_calories, calories)
	}

	sort.Sort(sort.Reverse(sort.IntSlice(all_calories)))
	return utils.Sum(all_calories[:3])
}

func main() {
	fmt.Println("--2022 day 01 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
