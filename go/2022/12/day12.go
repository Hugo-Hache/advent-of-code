package main

import (
	_ "embed"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/dominikbraun/graph"
)

//go:embed input.txt
var input_day string

type Cell struct {
	row    int
	column int
}

func DirectNeighbors(cell Cell) []Cell {
	return []Cell{{cell.row - 1, cell.column}, {cell.row, cell.column + 1}, {cell.row + 1, cell.column}, {cell.row, cell.column - 1}}
}

func ShortestPath(lines []string, startValue byte) int {
	cellHash := func(c Cell) string {
		return fmt.Sprint(c.row) + "," + fmt.Sprint(c.column)
	}

	grid := make(map[Cell]int)
	g := graph.New(cellHash, graph.Directed(), graph.Weighted())
	starts := make([]Cell, 0)
	target := Cell{-1, -1}
	for row := 0; row < len(lines); row++ {
		for column := 0; column < len(lines[0]); column++ {
			cell := Cell{row, column}
			grid[cell] = int(lines[row][column])
			if lines[row][column] == 'S' {
				grid[cell] = int('a') - 1
			}
			if lines[row][column] == 'E' {
				target = cell
				grid[cell] = int('z') + 1
			}
			if lines[row][column] == startValue {
				starts = append(starts, cell)
			}
			g.AddVertex(cell)
		}
	}

	for cell, letter := range grid {
		for _, neighbor := range DirectNeighbors(cell) {
			val, ok := grid[neighbor]
			if ok && val <= letter+1 {
				g.AddEdge(cellHash(cell), cellHash(neighbor), graph.EdgeWeight(1))
			}
		}
	}

	minShortestPath := math.MaxInt32
	for _, start := range starts {
		path, _ := graph.ShortestPath(g, cellHash(start), cellHash(target))
		steps := len(path) - 1
		if steps != -1 && steps < minShortestPath {
			minShortestPath = steps
		}
	}

	return minShortestPath
}

func Part1(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	return ShortestPath(lines, 'S')
}

func Part2(input string) int {
	input = strings.TrimSuffix(input, "\n")
	lines := strings.Split(input, "\n")
	return ShortestPath(lines, 'a')
}

func main() {
	fmt.Println("--2022 day 12 solution--")
	start := time.Now()
	fmt.Println("part1: ", Part1(input_day))
	fmt.Println(time.Since(start))

	start = time.Now()
	fmt.Println("part2: ", Part2(input_day))
	fmt.Println(time.Since(start))
}
