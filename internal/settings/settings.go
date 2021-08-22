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
package settings

import (
	"../build"
	"../locale"
	"../logger"
	"encoding/json"
	"flag"
	"fmt"
	"html/template"
	"os"
	"path/filepath"
)

// ## CONFIG CONTENT ##
//Used to read a configuration file
type ConfigType struct {
	HttpServer      HttpServerType
	ShowHiddenFiles bool
	HumanFileSize   bool
	ModTimeFormat   string
}

type HttpServerType struct {
	Listen    string
	EnableTLS bool
	CertFile  string
	KeyFile   string
}

//Default configuration
var ConfigDefault = ConfigType{
	HttpServer: HttpServerType{
		Listen:    ":8080",
		EnableTLS: false,
		CertFile:  "",
		KeyFile:   "",
	},
	ShowHiddenFiles: false,
	HumanFileSize:   true,
	ModTimeFormat:   "2006 Jan 2 15:04",
}

//Get the path to the file. Can return an empty string.
func GetFilePath(fileName string) string {
	if *ArgConfigDir != "" {
		path := filepath.Join(*ArgConfigDir, fileName)

		_, err := os.Stat(path)
		if err == nil {
			logger.Info.Println(locale.Load_file + ": " + path)
			return path
		}
		//logger.Info.Println(err)
		return ""
	}

	//Checking the USER path for the location of the config file
	for true {
		//Getting HOME environment variable
		variableHOME := os.Getenv(build.UserHomeEnvVar)
		if variableHOME == "" {
			logger.Warning.Println(build.UserHomeEnvVar + " " + locale.Env_var_is_empty)
			break
		}

		//Full path to file
		userFullPath := filepath.Join(variableHOME, build.UserConfigDir, fileName)

		//Checking the existence of a file
		_, err := os.Stat(userFullPath)
		if err == nil {
			return userFullPath
		}
		break
	}

	//Checking the SYSTEM path of the config file
	sysFullPath := filepath.Join(build.SysConfigDir, fileName)
	_, err := os.Stat(sysFullPath)
	if err == nil {
		return sysFullPath
	}

	//If both paths are wrong it returns an empty string
	return ""
}

//Read a configuration file
func ReadConfig(configFilePath string) ConfigType {
	//Getting the default configuration
	config := ConfigDefault

	//If an empty string is received, return the default value
	if configFilePath == "" {
		return config
	}

	//Reading a configuration file
	configFile, err := os.Open(configFilePath)
	if err != nil {
		logger.Warning.Println(err)
		return config
	}

	//Decoding a configuration file
	jsonParser := json.NewDecoder(configFile)
	err = jsonParser.Decode(&config)
	if err != nil {
		logger.Warning.Println(err)
		return config
	}

	return config
}

//Loads an HTML page template into RAM
func GetHtmlPageTemplate(indexHtmlFilePath string) *template.Template {
	//Custom template found
	if indexHtmlFilePath != "" {

		//Reading the html page template
		htmlPageTemplate, err := template.ParseFiles(indexHtmlFilePath)
		if err != nil {
			logger.Error.Fatal(err)
		} else {
			return htmlPageTemplate
		}
	}

	//The custom template is missing
	htmlPageTemplate := template.New("")

	//Default template
	templateDefault :=
		`<!doctype html>
	<html>
		<head>
			<meta charset="utf-8">
			<title>{{.Path}} - Horizon</title>
		</head>
		<body>
			<h2>{{.Path}}</h2>
			<p><a href={{.UpPath}}>` + locale.Go_top_tmpl + `</a></p>
			<table align='left' border=1 cellpadding=5>
				<th align='left'>` + locale.Name_tmpl + `</th>
				<th align='left'>` + locale.Size_tmpl + `</th>
				<th align='left'>` + locale.Mode_tmpl + `</th>
				<th align='left'>` + locale.ModTime_tmpl + `</th>
				<th align='left'>` + locale.Owner_tmpl + `</th>
				<th align='left'>` + locale.Group_tmpl + `</th>

				{{range .Files}}
				<tr>
					<td><a href={{.Path}}>{{.Name}}</a></td>
					<td>{{.Size}}</td>
					<td>{{.Mode}}</td>
					<td>{{.ModTime}}</td>
					<td>{{.Owner}} ({{.Uid}})</td>
					<td>{{.Group}} ({{.Gid}})</td>
				</tr>
				{{end}}
					
			</table>
		</body>
	</html>`

	htmlPageTemplate.Parse(templateDefault)

	return htmlPageTemplate
}

//Global vars
var ArgDir *string
var ArgConfigDir *string
var Config ConfigType
var HtmlTemplate *template.Template
var ResourcesDir string

func Main() {
	//Flags
	ArgDir = flag.String("dir", ".", locale.Dir_flag)
	ArgConfigDir = flag.String("config-dir", "", locale.Config_dir_flag)
	argVersion := flag.Bool("version", false, locale.Version_flag)
	flag.Parse()

	//Displaying the version
	if *argVersion == true {
		fmt.Println("Horizon", build.Version)
		os.Exit(0)
	}

	//Reading a configuration file
	Config = ReadConfig(GetFilePath("config.json"))

	//HTML template content
	HtmlTemplate = GetHtmlPageTemplate(GetFilePath("index.tmpl"))

	//Path to the folder with resources
	ResourcesDir = GetFilePath("resources")
}
