@set NAME=horizon
@if "%VERSION%"=="" (set VERSION=nil)
@set SysConfigDir=%PROGRAMDATA%\horizon\
@set UserHomeEnvVar=APPDATA
@set UserConfigDir=horizon\
@set LangEnvVar=LANG

@if "%GO%"=="" (set GO=go)
@if "%GOOS%"=="" (
	@for /F "tokens=*" %%i in ('%GO% env GOOS') do set GOOS=%%i
)
@if "%GOARCH%"=="" (
	@for /F "tokens=*" %%i in ('%GO% env GOARCH') do set GOARCH=%%i
)
@if "%LDFLAGS%"=="" (set LDFLAGS=-w -s)
@set MAIN_GO=.\cmd\horizon.go

@if "%DESTDIR%"=="" (set DESTDIR=%WINDIR%)

@if "%~1"=="" (Call :all & exit /B)
@if "%~1"=="configure" (Call :configure & exit /B)
@if "%~1"=="release" (Call :release & exit /B)
@if "%~1"=="install" (Call :install & exit /B)
@if "%~1"=="uninstall" (Call :uninstall & exit /B)
@if "%~1"=="clean" (Call :clean & exit /B)

@echo Usage: %~0 [configure^|release^|install^|uninstall^|clean]...
@exit /B 2

:all
	md dist\
	
	%GO% build -ldflags="%LDFLAGS%" -o dist\%NAME%.%GOOS%.%GOARCH%.exe %MAIN_GO%
	
	@exit /B

:configure
	md internal\build\
	echo package build > internal\build\build.go
	echo var Name = "%NAME%" >> internal\build\build.go
	echo var Version = "%VERSION%" >> internal\build\build.go
	echo var SysConfigDir = `%SysConfigDir%` >> internal\build\build.go
	echo var UserHomeEnvVar = "%UserHomeEnvVar%" >> internal\build\build.go
	echo var UserConfigDir = `%UserConfigDir%` >> internal\build\build.go
	echo var LangEnvVar = "%LangEnvVar%" >> internal\build\build.go
	
	@exit /B

:release
	md dist\
	
	set GOOS=windows
	set GOARCH=386
	%GO% build -ldflags="%LDFLAGS%" -o dist\%NAME%.windows.386.exe %MAIN_GO%
	set GOARCH=amd64
	%GO% build -ldflags="%LDFLAGS%" -o dist\%NAME%.windows.amd64.exe %MAIN_GO%
	set GOARCH=arm
	%GO% build -ldflags="%LDFLAGS%" -o dist\%NAME%.windows.arm.exe %MAIN_GO%
	
	@exit /B

:install
	copy dist\%NAME%.%GOOS%.%GOARCH%.exe %DESTDIR%\%NAME%.exe
	
	@exit /B

:uninstall
	del /S /Q %DESTDIR%\%NAME%.exe
	
	@exit /B

:clean
	rd /S /Q dist\
	rd /S /Q internal\build\
	
	@exit /B
