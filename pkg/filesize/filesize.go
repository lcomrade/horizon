package filesize

import (
	"fmt"
)

const (
	rounding = "%.2f"

	tb_size = 1099511627776
	gb_size = 1073741824
	mb_size = 1048576
	kb_size = 1024
)

func HumanReadable(size int64) (string, string) {
	sizeFloat := float64(size)

	//TB
	if size >= tb_size {
		sizeTmp := fmt.Sprintf(rounding, sizeFloat/tb_size)
		return sizeTmp, "TB"
	}

	//GB
	if size >= gb_size {
		sizeTmp := fmt.Sprintf(rounding, sizeFloat/gb_size)
		return sizeTmp, "GB"
	}

	//MB
	if size >= mb_size {
		sizeTmp := fmt.Sprintf(rounding, sizeFloat/mb_size)
		return sizeTmp, "MB"
	}

	//KB
	if size >= kb_size {
		sizeTmp := fmt.Sprintf(rounding, sizeFloat/kb_size)
		return sizeTmp, "KB"
	}

	return fmt.Sprint(size), ""
}
