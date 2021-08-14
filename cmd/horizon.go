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
package main

import (
	"../internal/locale"
	"../internal/logger"
	"../internal/settings"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"os/user"
	"path/filepath"
	"syscall"
)

// ## WEB TEMPLATE ##
//Used when displaying the list of files in the directory
type TemplateType struct {
	Path   string
	UpPath string
	Files  []FilesType
}

type FilesType struct {
	Name    string
	Path    string
	Size    int64
	Mode    os.FileMode
	ModTime string
	Uid     string
	Owner   string
	Gid     string
	Group   string
}

func GetPathToResource(fileName string) string {
	path := settings.GetFilePath("resources" + fileName)
	if path != "" && fileName != "/" {
		return path
	}

	return filepath.Join(*settings.ArgDir, fileName)
}

func IsHide(fileName string) bool {
	if fileName[0:1] == "." {
		return true
	} else {
		return false
	}
}

func GetFileInfo(file os.FileInfo, path string) FilesType {
	//Getting information about one file
	var uid = fmt.Sprint(file.Sys().(*syscall.Stat_t).Uid)
	var owner, _ = user.LookupId(uid)
	var gid = fmt.Sprint(file.Sys().(*syscall.Stat_t).Gid)
	var group, _ = user.LookupId(gid)

	var fileInfo = FilesType{
		Name:    file.Name(),
		Path:    filepath.Join(path, file.Name()),
		Size:    file.Size(),
		Mode:    file.Mode(),
		ModTime: file.ModTime().Format(settings.Config.ModTimeFormat),
		Uid:     uid,
		Owner:   owner.Username,
		Gid:     gid,
		Group:   group.Username,
	}

	return fileInfo
}

//## HANDLER ##
func MainHandler(rw http.ResponseWriter, r *http.Request) {
	path := GetPathToResource(r.URL.Path)

	//Checking the existence of a path
	pathStat, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			logger.Info.Println(err)
			http.Error(rw, err.Error(), 404)
			return
		} else {
			logger.Warning.Println(err)
			http.Error(rw, err.Error(), 400)
			return
		}
	}

	//Directory or file?
	if pathStat.IsDir() == true {

		//If the directory

		//Getting a list of files in the directory
		files, err := ioutil.ReadDir(path)
		if err != nil {
			logger.Warning.Println(err)
			http.Error(rw, err.Error(), 400)
			return
		}

		//Different arrays for directories and files
		var answerDirs []FilesType
		var answerFiles []FilesType

		for _, file := range files {
			if settings.Config.ShowHiddenFiles == false && IsHide(file.Name()) == true {

			} else {

				fileInfo := GetFileInfo(file, r.URL.Path)

				//Saving file information to an array
				if file.IsDir() == true {
					answerDirs = append(answerDirs, fileInfo)
				} else {
					answerFiles = append(answerFiles, fileInfo)
				}
			}
		}

		//In the answer, first the directories, then the files
		answer := TemplateType{
			Path:   r.URL.Path,
			UpPath: filepath.Join(r.URL.Path, ".."),
			Files:  append(answerDirs, answerFiles...),
		}

		//Filling the html page template
		tmpl := settings.HtmlTemplate

		err = tmpl.Execute(rw, answer)
		if err != nil {
			logger.Warning.Println(err)
			http.Error(rw, err.Error(), 400)
			return
		}
	} else {

		//If the file

		//Reading a file from the storage
		file, err := ioutil.ReadFile(path)
		if err != nil {
			logger.Warning.Println(err)
			http.Error(rw, err.Error(), 400)
			return
		}
		//Sending file
		rw.Write(file)
	}
}

func main() {
	settings.Main()

	//## WEB SERVER ##
	//Handlers assignment
	http.HandleFunc("/", MainHandler)

	//Print information about the WEB server
	logger.Info.Println(locale.Server_listen+":", settings.Config.HttpServer.Listen)
	logger.Info.Println(locale.Server_use_TLS+":", settings.Config.HttpServer.EnableTLS)

	//Enable TLS?
	//No TLS
	if settings.Config.HttpServer.EnableTLS == false {
		//Running a WEB server
		err := http.ListenAndServe(settings.Config.HttpServer.Listen, nil)
		if err != nil {
			logger.Error.Fatal(err)
		}

		//Use TLS
	} else {
		//Check availability of CERT file
		_, err := os.Stat(settings.Config.HttpServer.CertFile)
		if err != nil {
			if os.IsNotExist(err) {
				logger.Error.Fatal(locale.CERT_file_does_not_exist + ": " + settings.Config.HttpServer.CertFile)
			}
		}

		//Check availability of KEY file
		_, err = os.Stat(settings.Config.HttpServer.KeyFile)
		if err != nil {
			if os.IsNotExist(err) {
				logger.Error.Fatal(locale.KEY_file_does_not_exist + ": " + settings.Config.HttpServer.KeyFile)
			}
		}

		//Running a WEB server with TLS
		err = http.ListenAndServeTLS(settings.Config.HttpServer.Listen, settings.Config.HttpServer.CertFile, settings.Config.HttpServer.KeyFile, nil)
		if err != nil {
			logger.Error.Fatal(err)
		}
	}
}
