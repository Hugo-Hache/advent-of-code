package main

import (
	_ "embed"
	"fmt"
	"strings"
	"time"
)

//go:embed input.txt
var input_day string

// type index struct {
// 	row    int
// 	column int
// }

// func NewVisibleIndexes(grid [][]int, visibleIndexes)

// func VisibleIndexes(grid [][]int) map[index]bool {
// 	indexes := make(map[index]bool)
// 	for i := 0; i < len(grid); i++ {
// 		indexes[index{0, i}] = true             // first row
// 		indexes[index{len(grid) - 1, i}] = true // last row
// 		indexes[index{i, 0}] = true             // first column
// 		indexes[index{i, len(grid) - 1}] = true // last column
// 	}

// }

func ParseGrid(input string) [][]int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	grid := make([][]int, 0)
	for i, line := range lines {
		grid = append(grid, make([]int, 0))
		for _, rune := range line {
			grid[i] = append(grid[i], int(rune))
		}
	}
	return grid
}

func IsVisible(grid [][]int, val int, i int, j int) bool {
	grid_size := len(grid)

	visible := true
	for y := j - 1; y >= 0; y-- { // top visibility
		if grid[i][y] >= val {
			visible = false
			break
		}
	}
	if visible {
		return true
	}

	visible = true
	for x := i + 1; x < grid_size; x++ { // right visibility
		if grid[x][j] >= val {
			visible = false
			break
		}
	}
	if visible {
		return true
	}

	visible = true
	for y := j + 1; y < grid_size; y++ { // bottom visibility
		if grid[i][y] >= val {
			visible = false
			break
		}
	}
	if visible {
		return true
	}

	visible = true
	for x := i - 1; x >= 0; x-- { // left visibility
		if grid[x][j] >= val {
			visible = false
			break
		}
	}
	if visible {
		return true
	}

	return false
}

func ScenicScore(grid [][]int, val int, i int, j int) int {
	grid_size := len(grid)

	top_score := 0
	for y := j - 1; y >= 0; y-- {
		top_score += 1
		if grid[i][y] >= val {
			break
		}
	}

	right_score := 0
	for x := i + 1; x < grid_size; x++ {
		right_score += 1
		if grid[x][j] >= val {
			break
		}
	}

	bottom_score := 0
	for y := j + 1; y < grid_size; y++ {
		bottom_score += 1
		if grid[i][y] >= val {
			break
		}
	}

	left_score := 0
	for x := i - 1; x >= 0; x-- {
		left_score += 1
		if grid[x][j] >= val {
			break
		}
	}

	return top_score * right_score * left_score * bottom_score
}
func Part1(input string) int {
	grid := ParseGrid(input)
	visible_count := 0
	for i, row := range grid {
		for j, val := range row {
			if IsVisible(grid, val, i, j) {
				visible_count += 1
			}
		}
	}
	return visible_count
}

func Part2(input string) int {
	grid := ParseGrid(input)
	max_scenic_score := 0
	for i := 1; i < len(grid)-1; i++ {
		for j := 1; j < len(grid)-1; j++ {
			scenic_score := ScenicScore(grid, grid[i][j], i, j)
			if scenic_score > max_scenic_score {
				max_scenic_score = scenic_score
			}
		}
	}
	return max_scenic_score
}

func main() {
	fmt.Println("--2022 day 08 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
