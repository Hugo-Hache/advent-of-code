package utils

func Sum(x []int) int {
	total := 0
	for _, i := range x {
		total += i
	}
	return total
}

func Contains[T comparable](s []T, e T) bool {
	for _, v := range s {
		if v == e {
			return true
		}
	}
	return false
}
