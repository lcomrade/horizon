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
	Logging         LoggingType
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

type LoggingType struct {
	Level         string // Info | Warning | Error
	LogRequest    bool
	Log404Request bool
}

//Default configuration
var ConfigDefault = ConfigType{
	HttpServer: HttpServerType{
		Listen:    ":8080",
		EnableTLS: false,
		CertFile:  "",
		KeyFile:   "",
	},
	Logging: LoggingType{
		Level:         "Info",
		LogRequest:    true,
		Log404Request: true,
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
	//Logging
	logger.SetLevel(Config.Logging.Level)

	//Flags
	ArgDir = flag.String("dir", ".", locale.Dir_flag)
	ArgConfigDir = flag.String("config-dir", "", locale.Config_dir_flag)
	argInfo := flag.Bool("info", false, locale.Info_flag)
	argVersion := flag.Bool("version", false, locale.Version_flag)
	flag.Parse()

	//Displaying the build information
	if *argInfo == true {
		fmt.Println("Name:", build.Name)
		fmt.Println("Version:", build.Version)
		fmt.Println("SysConfigDir:", build.SysConfigDir)
		fmt.Println("UserHomeEnvVar:", build.UserHomeEnvVar)
		fmt.Println("UserConfigDir:", build.UserConfigDir)
		fmt.Println("LangEnvVar:", build.LangEnvVar)
		os.Exit(0)
	}

	//Displaying the version
	if *argVersion == true {
		fmt.Println(build.Name, build.Version)
		os.Exit(0)
	}

	//Reading a configuration file
	Config = ReadConfig(GetFilePath("config.json"))

	//HTML template content
	HtmlTemplate = GetHtmlPageTemplate(GetFilePath("index.tmpl"))

	//Path to the folder with resources
	ResourcesDir = GetFilePath("resources")
}
