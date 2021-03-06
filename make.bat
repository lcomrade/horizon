@set BUILD_ROOT=%CD%

@set NAME=horizon
@if "%VERSION%"=="" (set VERSION=nil)
@if "%MAINTAINER%"=="" (set MAINTAINER=nil)
@set SysConfigDir=%PROGRAMDATA%\horizon\
@set UserHomeEnvVar=APPDATA
@set UserConfigDir=horizon\
@set LangEnvVar=LANG

@if %GO%=="" (set GO=go)
@if %ISCC%=="" (set ISCC=ISCC)
@if %ZIP%=="" (set ZIP=7z)

@if "%GOOS%"=="" (
	@for /F "tokens=*" %%i in ('%GO% env GOOS') do @set GOOS=%%i
)
@if "%GOARCH%"=="" (
	@for /F "tokens=*" %%i in ('%GO% env GOARCH') do @set GOARCH=%%i
)
@if "%LDFLAGS%"=="" (set LDFLAGS=-w -s)
@set MAIN_GO=.\cmd\horizon.go
@set MAIN_ISS="%CD%\build\windows\setup.iss"

@if "%DESTDIR%"=="" (set DESTDIR=%WINDIR%)

@if "%~1"=="" (Call :all & exit /B)
@if "%~1"=="configure" (Call :configure & exit /B)
@if "%~1"=="release" (Call :release & exit /B)
@if "%~1"=="install" (Call :install & exit /B)
@if "%~1"=="uninstall" (Call :uninstall & exit /B)
@if "%~1"=="installer" (Call :installer & exit /B)
@if "%~1"=="choco" (Call :choco & exit /B)
@if "%~1"=="scoop" (Call :scoop & exit /B)
@if "%~1"=="clean" (Call :clean & exit /B)

@echo Usage: %~0 [configure^|release^|install^|uninstall^|installer^|choco^|scoop^|clean]...
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
	
	md build\windows\
	echo #define AppName "%NAME%" > build\windows\build.iss
	echo #define AppVersion "%VERSION%" >> build\windows\build.iss
	echo #define GOARCH "%GOARCH%" >> build\windows\build.iss
	echo #define MAINTAINER "%MAINTAINER%" >> build\windows\build.iss
	echo #define AppComment "Horizon - minimalist WEB-server for data transfer via HTTP" >> build\windows\build.iss
	echo #define AppURL "https://github.com/lcomrade/horizon" >> build\windows\build.iss
	
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
	
	
	cd dist\
	
	md %NAME%.windows.386\
	copy %BUILD_ROOT%\dist\%NAME%.windows.386.exe %NAME%.windows.386\%NAME%.exe
	copy %BUILD_ROOT%\LICENSE %NAME%.windows.386\LICENSE.txt
	copy %BUILD_ROOT%\README.md %NAME%.windows.386\README.md
	md %NAME%.windows.386\docs\
	copy %BUILD_ROOT%\docs\configure.md %NAME%.windows.386\docs\%NAME%-configure.md
	copy %BUILD_ROOT%\docs\windows\%NAME%.txt %NAME%.windows.386\docs\%NAME%.txt
	copy %BUILD_ROOT%\docs\windows\%NAME%.ru.txt %NAME%.windows.386\docs\%NAME%.ru.txt
	cd %NAME%.windows.386\
	%ZIP% a -tzip -mx9 %BUILD_ROOT%\dist\%NAME%.windows.386.zip %NAME%.exe LICENSE.txt README.md docs\
	cd ..
	rd /S /Q %NAME%.windows.386\
	
	md %NAME%.windows.amd64\
	copy %BUILD_ROOT%\dist\%NAME%.windows.amd64.exe %NAME%.windows.amd64\%NAME%.exe
	copy %BUILD_ROOT%\LICENSE %NAME%.windows.amd64\LICENSE.txt
	copy %BUILD_ROOT%\README.md %NAME%.windows.amd64\README.md
	md %NAME%.windows.amd64\docs\
	copy %BUILD_ROOT%\docs\configure.md %NAME%.windows.amd64\docs\%NAME%-configure.md
	copy %BUILD_ROOT%\docs\windows\%NAME%.txt %NAME%.windows.amd64\docs\%NAME%.txt
	copy %BUILD_ROOT%\docs\windows\%NAME%.ru.txt %NAME%.windows.amd64\docs\%NAME%.ru.txt
	cd %NAME%.windows.amd64\
	%ZIP% a -tzip -mx9 %BUILD_ROOT%\dist\%NAME%.windows.amd64.zip %NAME%.exe LICENSE.txt README.md docs\
	cd ..
	rd /S /Q %NAME%.windows.amd64\
	
	md %NAME%.windows.arm\
	copy %BUILD_ROOT%\dist\%NAME%.windows.arm.exe %NAME%.windows.arm\%NAME%.exe
	copy %BUILD_ROOT%\LICENSE %NAME%.windows.arm\LICENSE.txt
	copy %BUILD_ROOT%\README.md %NAME%.windows.arm\README.md
	md %NAME%.windows.arm\docs\
	copy %BUILD_ROOT%\docs\configure.md %NAME%.windows.arm\docs\%NAME%-configure.md
	copy %BUILD_ROOT%\docs\windows\%NAME%.txt %NAME%.windows.arm\docs\%NAME%.txt
	copy %BUILD_ROOT%\docs\windows\%NAME%.ru.txt %NAME%.windows.arm\docs\%NAME%.ru.txt
	cd %NAME%.windows.arm\
	%ZIP% a -tzip -mx9 %BUILD_ROOT%\dist\%NAME%.windows.arm.zip %NAME%.exe LICENSE.txt README.md docs\
	cd ..
	rd /S /Q %NAME%.windows.arm\
	
	cd %BUILD_ROOT%


	echo #define AppName "%NAME%" > build\windows\build.iss
	echo #define AppVersion "%VERSION%" >> build\windows\build.iss
	echo #define MAINTAINER "%MAINTAINER%" >> build\windows\build.iss
	echo #define AppComment "Horizon - minimalist WEB-server for data transfer via HTTP" >> build\windows\build.iss
	echo #define AppURL "https://github.com/lcomrade/horizon" >> build\windows\build.iss

	%ISCC% /DGOARCH=386 /O"%CD%\dist" /F"%NAME%.windows.386.setup" %MAIN_ISS%
	%ISCC% /DGOARCH=amd64 /O"%CD%\dist" /F"%NAME%.windows.amd64.setup" %MAIN_ISS%
	
	
	del /S /Q dist\%NAME%.windows.386.exe
	del /S /Q dist\%NAME%.windows.amd64.exe
	del /S /Q dist\%NAME%.windows.arm.exe
	
	
	call make choco
	
	@exit /B

:install
	copy dist\%NAME%.%GOOS%.%GOARCH%.exe %DESTDIR%\%NAME%.exe
	
	@exit /B

:uninstall
	del /S /Q %DESTDIR%\%NAME%.exe
	
	@exit /B

:installer
	%ISCC% /O"%CD%\dist" /F"%NAME%.windows.%GOARCH%.setup" %MAIN_ISS%

	@exit /B
	
:choco
	@if exist "dist\horizon.windows.386.setup.exe" (
		@for /F "tokens=*" %%i in ('checksum -t=sha256 -f=dist\horizon.windows.386.setup.exe') do @set setup_386_sha256=%%i
	) else (
		@echo Error: dist\horizon.windows.386.setup.exe does not exist
		@exit /B 1
	)
	
	@if exist "dist\horizon.windows.amd64.setup.exe" (
		@for /F "tokens=*" %%i in ('checksum -t=sha256 -f=dist\horizon.windows.amd64.setup.exe') do @set setup_amd64_sha256=%%i
	) else (
		@echo Error: dist\horizon.windows.amd64.setup.exe does not exist
		@exit /B 1
	)

	md build\windows\choco\
	echo ^<^?xml version="1.0" encoding="utf-8"^?^>> build\windows\choco\%NAME%.nuspec
	echo ^<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd"^>>> build\windows\choco\%NAME%.nuspec
	echo   ^<metadata^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<id^>%NAME%^</id^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<version^>%VERSION%^</version^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<title^>%NAME% (Install)^</title^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<authors^>lcomrade^</authors^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<projectUrl^>https://github.com/lcomrade/horizon^</projectUrl^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<licenseUrl^>https://github.com/lcomrade/horizon/blob/main/LICENSE^</licenseUrl^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<projectSourceUrl^>https://github.com/lcomrade/horizon/archive/refs/heads/main.zip^</projectSourceUrl^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<docsUrl^>https://github.com/lcomrade/horizon/tree/v%VERSION%/docs^</docsUrl^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<bugTrackerUrl^>https://github.com/lcomrade/horizon/issues^</bugTrackerUrl^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<tags^>horizon cli web server command-line gplv3 file-sharing^</tags^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<summary^>Minimalist WEB-server for data transfer via HTTP^</summary^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<description^>Horizon - minimalist WEB-server for data transfer via HTTP^</description^>>> build\windows\choco\%NAME%.nuspec
	echo     ^<releaseNotes^>https://github.com/lcomrade/horizon/releases/tag/v%VERSION%^</releaseNotes^>>> build\windows\choco\%NAME%.nuspec
	
	echo   ^</metadata^>>> build\windows\choco\%NAME%.nuspec
	echo   ^<files^> >> build\windows\choco\%NAME%.nuspec
	echo     ^<file src="tools\**" target="tools" /^> >> build\windows\choco\%NAME%.nuspec
	echo   ^</files^> >> build\windows\choco\%NAME%.nuspec
	echo ^</package^> >> build\windows\choco\%NAME%.nuspec
	
	md build\windows\choco\tools\
	echo $ErrorActionPreference = 'Stop';> build\windows\choco\tools\chocolateyinstall.ps1
	echo $toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)">> build\windows\choco\tools\chocolateyinstall.ps1
	echo $packageArgs = @{>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   packageName   = $env:ChocolateyPackageName>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   unzipLocation = $toolsDir>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   fileType      = 'exe'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   url           = 'https://github.com/lcomrade/horizon/releases/download/v%VERSION%/horizon.windows.386.setup.exe'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   url64bit      = 'https://github.com/lcomrade/horizon/releases/download/v%VERSION%/horizon.windows.amd64.setup.exe'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   softwareName  = '%NAME%^*'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   checksum      = '%setup_386_sha256%'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   checksumType  = 'sha256'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   checksum64    = '%setup_amd64_sha256%'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   checksumType64= 'sha256'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'>> build\windows\choco\tools\chocolateyinstall.ps1
	echo   validExitCodes= @(0)>> build\windows\choco\tools\chocolateyinstall.ps1
	echo }>> build\windows\choco\tools\chocolateyinstall.ps1
	echo Install-ChocolateyPackage @packageArgs>> build\windows\choco\tools\chocolateyinstall.ps1
	
	md dist\
	cd build\windows\choco\
	choco pack --outdir %BUILD_ROOT%\dist\
	cd %BUILD_ROOT%
	
	@exit /B
	
:scoop
	@if exist "dist\%NAME%.windows.386.zip" (
		@for /F "tokens=*" %%i in ('checksum -t=sha256 -f=dist\%NAME%.windows.386.zip') do @set zip_386_sha256=%%i
	) else (
		@echo Error: dist\%NAME%.windows.386.zip does not exist
		@exit /B 1
	)
	
	@if exist "dist\%NAME%.windows.amd64.zip" (
		@for /F "tokens=*" %%i in ('checksum -t=sha256 -f=dist\%NAME%.windows.amd64.zip') do @set zip_amd64_sha256=%%i
	) else (
		@echo Error: dist\%NAME%.windows.amd64.zip does not exist
		@exit /B 1
	)
	
	md dist\
	echo {> dist\%NAME%.json
	echo   "version": "%VERSION%",>> dist\%NAME%.json
	echo   "license": "GPLv3+",>> dist\%NAME%.json
	echo   "description": "Minimalist WEB-server for data transfer via HTTP",>> dist\%NAME%.json
	echo   "homepage": "https://github.com/lcomrade/horizon/",>> dist\%NAME%.json
	echo   "architecture": {>> dist\%NAME%.json
	echo 	  "64bit": {>> dist\%NAME%.json
	echo 		  "url": "https://github.com/%GITHUB_USER%/%NAME%/releases/download/v%VERSION%/%NAME%.windows.amd64.zip",>> dist\%NAME%.json
	echo 		  "hash": "%zip_amd64_sha256%">> dist\%NAME%.json
	echo      },>> dist\%NAME%.json
	echo      "32bit": {>> dist\%NAME%.json
	echo 		  "url": "https://github.com/%GITHUB_USER%/%NAME%/releases/download/v%VERSION%/%NAME%.windows.386.zip",>> dist\%NAME%.json
	echo 		  "hash": "%zip_386_sha256%">> dist\%NAME%.json
	echo      }>> dist\%NAME%.json
	echo   },>> dist\%NAME%.json
	echo   "bin": "%NAME%.exe",>> dist\%NAME%.json
	
	echo   "autoupdate": {>> dist\%NAME%.json
	echo     "architecture": {>> dist\%NAME%.json
	echo       "64bit": {>> dist\%NAME%.json
	echo         "url": "https://github.com/lcomrade/horizon/releases/download/v$version/horizon.windows.amd64.zip">> dist\%NAME%.json
	echo       },>> dist\%NAME%.json
	echo       "32bit": {>> dist\%NAME%.json
	echo         "url": "https://github.com/lcomrade/horizon/releases/download/v$version/horizon.windows.386.zip">> dist\%NAME%.json
	echo       }>> dist\%NAME%.json
	echo     }>> dist\%NAME%.json
	echo   }>> dist\%NAME%.json
	echo }>> dist\%NAME%.json
	
	@exit /B

:clean
	rd /S /Q dist\
	rd /S /Q internal\build\
	del /S /Q build\windows\build.iss
	del /S /Q build\windows\choco\
	
	@exit /B
