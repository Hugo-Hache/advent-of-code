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

func Last[T any](s []T) T {
	return s[len(s)-1]
}

func Reduce[T any, U any](s []T, val U, reducer func(val U, item T) U) U {
	result := val
	for _, item := range s {
		result = reducer(result, item)
	}
	return result
}
