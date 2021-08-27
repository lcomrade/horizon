/*
   Copyright 2021 Leonid Maslakov

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
package logger

import (
	"io/ioutil"
	"log"
	"os"
)

var Info = log.New(os.Stdout, "INFO\t", log.Ldate|log.Ltime)
var Warning = log.New(os.Stdout, "WARNING\t", log.Ldate|log.Ltime|log.Lshortfile)
var Error = log.New(os.Stderr, "ERROR\t", log.Ldate|log.Ltime|log.Lshortfile)

func SetLevel(level string) {
	if level == "Info" {
		return
	}

	if level == "Warning" {
		Info.SetOutput(ioutil.Discard)
		return
	}

	if level == "Error" {
		Info.SetOutput(ioutil.Discard)
		Warning.SetOutput(ioutil.Discard)
		return
	}

	return
}
