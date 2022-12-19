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

type Position struct {
	x int
	y int
}

type Rope struct {
	head  Position
	tails []Position
}

var directions = map[string]Position{"U": {0, 1}, "R": {1, 0}, "D": {0, -1}, "L": {-1, 0}}

func Sign(x int) int {
	if x == 0 {
		return 0
	}
	if x < 0 {
		return -1
	}
	return 1
}

func Abs(x int) int {
	if x < 0 {
		return -x
	} else {
		return x
	}
}

func NextTailPosition(new_head_position Position, tail_position Position) Position {
	delta_x := new_head_position.x - tail_position.x
	delta_y := new_head_position.y - tail_position.y

	if Abs(delta_x) <= 1 && Abs(delta_y) <= 1 {
		return tail_position
	}

	return Position{tail_position.x + Sign(delta_x), tail_position.y + Sign(delta_y)}
}

func Move(direction string, rope Rope, visited_tail_positions map[Position]bool) Rope {
	delta := directions[direction]
	new_head_position := Position{rope.head.x + delta.x, rope.head.y + delta.y}

	heading_position := new_head_position
	new_tails := make([]Position, 0)
	for i := 0; i < len(rope.tails); i++ {
		new_tail_position := NextTailPosition(heading_position, rope.tails[i])
		new_tails = append(new_tails, new_tail_position)
		heading_position = new_tail_position
	}
	visited_tail_positions[new_tails[len(new_tails)-1]] = true
	return Rope{new_head_position, new_tails}
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	origin := Position{0, 0}
	rope := Rope{origin, []Position{origin}}
	visited_tail_positions := make(map[Position]bool)
	visited_tail_positions[origin] = true
	for _, line := range lines {
		words := strings.Split(line, " ")
		direction := words[0]
		magnitude := utils.ToInt(words[1])
		for i := 0; i < magnitude; i++ {
			rope = Move(direction, rope, visited_tail_positions)
		}
	}

	return len(visited_tail_positions)
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")

	origin := Position{0, 0}
	tails := make([]Position, 0)
	for i := 0; i < 9; i++ {
		tails = append(tails, origin)
	}
	rope := Rope{origin, tails}
	visited_tail_positions := make(map[Position]bool)
	visited_tail_positions[origin] = true
	for _, line := range lines {
		words := strings.Split(line, " ")
		direction := words[0]
		magnitude := utils.ToInt(words[1])
		for i := 0; i < magnitude; i++ {
			rope = Move(direction, rope, visited_tail_positions)
		}
	}

	return len(visited_tail_positions)
}

func main() {
	fmt.Println("--2022 day 09 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
