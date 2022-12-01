package utils

func Sum(x []int) int {
	total := 0
	for _, i := range x {
		total += i
	}
	return total
}
