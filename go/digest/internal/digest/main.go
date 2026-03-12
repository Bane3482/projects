package digest

import (
	"math/cmplx"
	"math/rand/v2"
	"strings"
	"unsafe"
)

// GetCharByIndex returns the i-th character from the given string.
func GetCharByIndex(str string, idx int) rune {
	for _, symb := range str {
		if idx == 0 {
			return symb
		}
		idx--
	}
	panic("not implemented")
}

// GetStringBySliceOfIndexes returns a string formed by concatenating specific characters from the input string based
// on the provided indexes.
func GetStringBySliceOfIndexes(str string, indexes []int) string {
	result := &strings.Builder{}
	result.Grow(len(indexes))
	for _, i := range indexes {
		result.WriteRune(GetCharByIndex(str, i))
	}
	return result.String()
}

// ShiftPointer shifts the given pointer by the specified number of bytes using unsafe.Add.
func ShiftPointer(pointer **int, shift int) {
	*pointer = (*int)(unsafe.Add(unsafe.Pointer(*pointer), shift))
}

// IsComplexEqual compares two complex numbers and determines if they are equal.
func IsComplexEqual(a, b complex128) bool {
	return a == b || cmplx.Abs(a-b) < 1e-5
}

// GetRootsOfQuadraticEquation returns two roots of a quadratic equation ax^2 + bx + c = 0.
func GetRootsOfQuadraticEquation(a, b, c float64) (complex128, complex128) {
	d := cmplx.Sqrt(cmplx.Pow(complex(b, 0), complex(2, 0)) - complex(4*a*c, 0))
	return (-complex(b, 0) + d) / 2, (complex(-b, 0) - d) / 2
}

func QSort(s []int, left int, right int) {
	if left < right {
		pivot := s[rand.IntN(right-left)+left]
		i := left
		j := right
		for i <= j {
			for s[i] < pivot {
				i++
			}
			for s[j] > pivot {
				j--
			}
			if i <= j {
				s[i], s[j] = s[j], s[i]
				i++
				j--
			}
		}
		if left < j {
			QSort(s, left, j)
		}
		if i < right {
			QSort(s, i, right)
		}
	}
}

// Sort sorts in-place the given slice of integers in ascending order.
func Sort(source []int) {
	QSort(source, 0, len(source)-1)
}

// ReverseSliceOne in-place reverses the order of elements in the given slice.
func ReverseSliceOne(s []int) {
	n := len(s)
	for i := 0; i < n/2; i++ {
		s[i], s[n-i-1] = s[n-i-1], s[i]
	}
}

// ReverseSliceTwo returns a new slice of integers with elements in reverse order compared to the input slice.
// The original slice remains unmodified.
func ReverseSliceTwo(s []int) []int {
	dst := make([]int, len(s))
	copy(dst, s)
	ReverseSliceOne(dst)
	return dst
}

// SwapPointers swaps the values of two pointers.
func SwapPointers(a, b *int) {
	*a, *b = *b, *a
}

// IsSliceEqual compares two slices of integers and returns true if they contain the same elements in the same order.
func IsSliceEqual(a, b []int) bool {
	switch len(a) == len(b) {
	case false:
		return false
	default:
		{
			for i := 0; i < len(a); i++ {
				if a[i] != b[i] {
					return false
				}
			}
			return true
		}
	}
}

// DeleteByIndex deletes the element at the specified index from the slice and returns a new slice.
// The original slice remains unmodified.
func DeleteByIndex(s []int, idx int) []int {
	result := make([]int, len(s)-1)
	copy(result, s[:idx])
	copy(result[idx:], s[idx+1:])
	return result
}
