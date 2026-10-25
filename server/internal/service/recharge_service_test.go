package service

import "testing"

func TestParseAlipayAmountRequiresExactWholeUnits(t *testing.T) {
	tests := []struct {
		input string
		want  uint
		ok    bool
	}{
		{input: "12", want: 12, ok: true},
		{input: "12.00", want: 12, ok: true},
		{input: "12.0", want: 12, ok: true},
		{input: "12.01", ok: false},
		{input: "12.001", ok: false},
		{input: "12.00.0", ok: false},
		{input: "", ok: false},
		{input: "-1", ok: false},
	}
	for _, tc := range tests {
		got, err := parseAlipayAmount(tc.input)
		if (err == nil) != tc.ok || (err == nil && got != tc.want) {
			t.Errorf("parseAlipayAmount(%q) = (%d, %v), want (%d, ok=%v)", tc.input, got, err, tc.want, tc.ok)
		}
	}
}
