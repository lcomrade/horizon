#define RootDir "C:\horizon"

#include AddBackslash(SourcePath) + "build.iss"

[Setup]
AllowCancelDuringInstall=no
AlwaysShowDirOnReadyPage=no
AppComments={#AppComment}
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{F3EBDEBF-03A6-4422-8EBD-A54261E80B1D}
AppReadmeFile={#AppURL}#readme
AppName={#AppName}
AppPublisher={#MAINTAINER}
AppVersion={#AppVersion}
AppVerName={cm:NameAndVersion,{#AppName},{#AppVersion}}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}/issues
AppUpdatesURL={#AppURL}/releases/latest
;; ArchitecturesAllowed=x86 x64
DefaultDirName={commonpf}\Uninstall Information\{#AppName}
DisableDirPage=yes
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableReadyMemo=yes
DisableStartupPrompt=yes
DisableWelcomePage=yes
DisableReadyPage=yes
LicenseFile={#RootDir}\LICENSE
;; MinVersion=6.0sp1
OutputDir={#RootDir}\dist
OutputBaseFilename=horizon.windows.{#GOARCH}.setup
DirExistsWarning=no
EnableDirDoesntExistWarning=no
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=commandline
TouchDate=none
TouchTime=none
ShowLanguageDialog=no
UsePreviousAppDir=no
UsePreviousGroup=no
UsePreviousLanguage=no
UsePreviousPrivileges=no
UsePreviousSetupType=no
UsePreviousTasks=no
UsePreviousUserInfo=no
UseSetupLdr=yes
Compression=lzma
SolidCompression=yes
SetupIconFile=compiler:SetupClassicIcon.ico
WizardStyle=classic

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "{#RootDir}\dist\horizon.windows.{#GOARCH}.exe"; DestDir: "{win}"; DestName: "{#AppName}.exe"; Flags: ignoreversion

[Icons]
Name: "{group}\{#AppName}"; Filename: "{win}\{#AppName}.exe"; WorkingDir: "{sd}"; Comment: "{#AppComment}"
Name: "{group}\{#AppName} URL"; Filename: "{#AppURL}"

[UninstallDelete]
Type: files; Name: "{win}\{#AppName}.exe"
Type: filesandordirs; Name: "{group}"
Type: filesandordirs; Name: "{commonpf}\Uninstall Information\{#AppName}"
