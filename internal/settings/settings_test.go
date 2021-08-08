package settings

import (
	"../build"
	"fmt"
	"os"
	"testing"
)

var testDirRoot = "/tmp/horizon_test"

//Runs the Main() function only once
//This is all for compatibility with Go >= 1.13
//See 1: https://github.com/golang/go/issues/31859
//See 2: https://github.com/golang/go/issues/33774
var mainRun = false

func MakeMain() {
	if mainRun == false {
		Main()
		mainRun = true
	}
}

//Delete the files used for testing
func MakeClean() {
	err := os.RemoveAll(testDirRoot)
	if err != nil {
		panic(err)
	}
}

//TEST: Search for configuration files
func TestGetFilePath(t *testing.T) {
	MakeClean()
	MakeMain()

	//Setting up paths
	err := os.Setenv("HOME_HORIZON_TEST", testDirRoot)
	if err != nil {
		panic(err)
	}

	build.UserHomeEnvVar = "HOME_HORIZON_TEST"
	build.UserConfigDir = ".config/app"
	build.SysConfigDir = testDirRoot + "/etc/app/"

	// ## SYSTEM configs location
	err = os.MkdirAll(testDirRoot+"/etc/app/", 0777)
	if err != nil {
		panic(err)
	}

	_, err = os.Create(testDirRoot + "/etc/app/config.json")
	if err != nil {
		panic(err)
	}

	filePathOut := GetFilePath("config.json")
	if filePathOut != testDirRoot+"/etc/app/config.json" {
		fmt.Println(`--- INFO: GetFilePath("config.json") = ` + filePathOut)
		t.Error(`SYSTEM configs location: GetFilePath("config.json") != ` + testDirRoot + `/etc/app/config.json`)
	}

	// ## USER configs location
	err = os.MkdirAll(testDirRoot+"/.config/app/", 0777)
	if err != nil {
		panic(err)
	}

	_, err = os.Create(testDirRoot + "/.config/app/config.json")
	if err != nil {
		panic(err)
	}

	filePathOut = GetFilePath("config.json")
	if filePathOut != testDirRoot+"/.config/app/config.json" {
		fmt.Println(`--- INFO: GetFilePath("config.json") = ` + filePathOut)
		t.Error(`USER configs location: GetFilePath("config.json") != ` + testDirRoot + `/.config/app/config.json`)
	}

	// ## NON-EXISTENT file
	filePathOut = GetFilePath("noexist.file")
	if filePathOut != "" {
		fmt.Println(`--- INFO: GetFilePath("noexist.file") = ` + filePathOut)
		t.Error(`NON-EXISTENT file: GetFilePath("noexist.file") != ""`)

		MakeClean()
	}
}

//TEST: Reading a configuration file
func TestReadConfig(t *testing.T) {
	MakeClean()
	MakeMain()

	// ## Blank line instead of the config file path
	configOut := ReadConfig("")
	if configOut.HttpServer.Listen != ":8080" {
		fmt.Println(`--- INFO: config.HttpServer.Listen = ` + configOut.HttpServer.Listen)
		t.Error(`NO CONFIG FILE: config.HttpServer.Listen != :8080`)
	}

	// ## Empty file
	err := os.MkdirAll(testDirRoot, 0777)
	if err != nil {
		panic(err)
	}

	_, err = os.Create(testDirRoot + "/blank.json")
	if err != nil {
		panic(err)
	}

	configOut = ReadConfig(testDirRoot + "/blank.json")
	if configOut.HttpServer.EnableTLS != false {
		fmt.Printf(`--- INFO: config.HttpServer.EnableTLS = `)
		fmt.Println(configOut.HttpServer.EnableTLS)
		t.Error(`EMPTY CONFIG FILE: config.HttpServer.EnableTLS != false`)
	}

	// ## Custom config file
	file, err := os.Create(testDirRoot + "/config.json")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	_, err = file.WriteString(`
	{
		"HttpServer": {
			"Listen": ":5555",
			"EnableTLS": true
		}
	}
	`)
	if err != nil {
		panic(err)
	}

	configOut = ReadConfig(testDirRoot + "/config.json")
	if configOut.HttpServer.Listen != ":5555" {
		fmt.Println(`--- INFO: config.HttpServer.Listen = ` + configOut.HttpServer.Listen)
		t.Error(`CUSTOM CONFIG FILE: config.HttpServer.Listen != :5555`)
	}

	if configOut.HttpServer.EnableTLS != true {
		fmt.Printf(`--- INFO: config.HttpServer.EnableTLS = `)
		fmt.Println(configOut.HttpServer.EnableTLS)
		t.Error(`CUSTOM CONFIG FILE: config.HttpServer.EnableTLS != true`)
	}

	MakeClean()
}
