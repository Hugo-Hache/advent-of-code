package main

import (
	"aoc/utils"
	_ "embed"
	"fmt"
	"regexp"
	"sort"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

var greet = func() {
	// code
}

type Monkey struct {
	items             []int
	operation         func(old int) int
	modulo            int
	monkey_modulo     int
	monkey_not_modulo int
	items_inspected   int
}

func ParseMonkey(monkey_input string) Monkey {
	lines := strings.Split(monkey_input, "\n")

	re := regexp.MustCompile("Starting items: (.*)")
	matches := re.FindStringSubmatch(lines[1])
	items := utils.StringsToNumbers(strings.Split(matches[1], ", "))

	re = regexp.MustCompile("new = (.*)")
	matches = re.FindStringSubmatch(lines[2])
	terms := strings.Split(matches[1], " ")
	operation := func(old int) int {
		first_arg := 0
		if terms[0] == "old" {
			first_arg = old
		} else {
			first_arg = utils.ToInt(terms[0])
		}

		second_arg := 0
		if terms[2] == "old" {
			second_arg = old
		} else {
			second_arg = utils.ToInt(terms[2])
		}

		if terms[1] == "+" {
			return first_arg + second_arg
		} else {
			return first_arg * second_arg
		}
	}

	modulo := utils.ToInt(utils.Last(strings.Split(lines[3], " ")))
	monkey_modulo := utils.ToInt(utils.Last(strings.Split(lines[4], " ")))
	monkey_not_modulo := utils.ToInt(utils.Last(strings.Split(lines[5], " ")))

	return Monkey{items, operation, modulo, monkey_modulo, monkey_not_modulo, 0}
}

func ParseMonkeys(monkey_inputs []string) []Monkey {
	monkeys := make([]Monkey, 0)

	for _, monkey_input := range monkey_inputs {
		monkeys = append(monkeys, ParseMonkey(monkey_input))
	}

	return monkeys
}

func RunMonkey(monkeys []Monkey, m int, decrease_worry bool, global_modulo int) {
	monkey := &monkeys[m]
	for _, item := range monkey.items {
		new_item := monkey.operation(item)
		if decrease_worry {
			new_item = new_item / 3
		}
		new_item = new_item % global_modulo

		destination_m := -1
		if new_item%monkey.modulo == 0 {
			destination_m = monkey.monkey_modulo
		} else {
			destination_m = monkey.monkey_not_modulo
		}
		destination_monkey := &monkeys[destination_m]
		destination_monkey.items = append(destination_monkey.items, new_item)

		monkey.items_inspected += 1
	}
	monkey.items = make([]int, 0)
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	monkeys := ParseMonkeys(strings.Split(input, "\n\n"))

	for i := 0; i < 20; i++ {
		for m := 0; m < len(monkeys); m++ {
			RunMonkey(monkeys, m, true, 1)
		}
	}

	items_inspected := make([]int, 0)
	for _, monkey := range monkeys {
		items_inspected = append(items_inspected, monkey.items_inspected)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(items_inspected)))

	return items_inspected[0] * items_inspected[1]
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	monkeys := ParseMonkeys(strings.Split(input, "\n\n"))
	global_modulo := 1
	for _, monkey := range monkeys {
		global_modulo *= monkey.modulo
	}

	for i := 0; i < 10000; i++ {
		for m := 0; m < len(monkeys); m++ {
			RunMonkey(monkeys, m, false, global_modulo)
		}
	}

	items_inspected := make([]int, 0)
	for _, monkey := range monkeys {
		items_inspected = append(items_inspected, monkey.items_inspected)
	}
	sort.Sort(sort.Reverse(sort.IntSlice(items_inspected)))

	return items_inspected[0] * items_inspected[1]
}

func main() {
	fmt.Println("--2022 day 11 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
