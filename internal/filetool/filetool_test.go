package filetool

import (
	"fmt"
	"testing"
)

func TestIsHide(t *testing.T) {
	hiddenFile := IsHide(".hide")
	if hiddenFile != true {
		fmt.Printf(`--- INFO: IsHide(".hidden") = `)
		fmt.Println(hiddenFile)
		t.Error(`IsHide(".hide") != true`)
	}

	nonHiddenFile := IsHide("show")
	if nonHiddenFile != false {
		fmt.Printf(`--- INFO: IsHide("show") = `)
		fmt.Println(nonHiddenFile)
		t.Error(`IsHide("show") != false`)
	}
}
