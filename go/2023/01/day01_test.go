package main

import (
	_ "embed"
	"testing"
)

//go:embed input_test.txt
var input_test string

func TestPart1(t *testing.T) {
	result := Part1(string(input_test))
	expected := 142
	if result != expected {
		t.Errorf("Result is incorrect, got: %d, want: %d.", result, expected)
	}
}

func TestPart2(t *testing.T) {
	result := Part2(string(`two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`))
	expected := 281
	if result != expected {
		t.Errorf("Result is incorrect, got: %d, want: %d.", result, expected)
	}
}

func TestPart1Input(t *testing.T) {
	result := Part1(string(input_day))
	expected := 54081
	if result != expected {
		t.Errorf("Result is incorrect, got: %d, want: %d.", result, expected)
	}
}

func TestPart2Input(t *testing.T) {
	result := Part2(string(input_day))
	expected := 54649
	if result != expected {
		t.Errorf("Result is incorrect, got: %d, want: %d.", result, expected)
	}
}

func BenchmarkPart1(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Part1(input_day)
	}
}
func BenchmarkPart2(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Part2(input_day)
	}
}
