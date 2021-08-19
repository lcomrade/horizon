/*
   Copyright 2021 Leonid Maslakov

   License: GPL-3.0-or-later

   This file is part of Horizon.

   Horizon is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Horizon is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Horizon.  If not, see <https://www.gnu.org/licenses/>.

*/

package fileinfo

import (
	"os"
)

func GetOwnerAndGroup(file os.FileInfo) (string, string, string, string) {
	return "", "", "", ""
}
