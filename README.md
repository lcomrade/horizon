[![Go report](https://goreportcard.com/badge/github.com/lcomrade/horizon?style=flat-square)](https://goreportcard.com/report/github.com/lcomrade/horizon)
[![Release](https://img.shields.io/github/downloads/lcomrade/horizon/total?style=flat-square)](https://github.com/lcomrade/horizon/releases/latest)
[![License](https://img.shields.io/github/license/lcomrade/horizon?style=flat-square)](https://github.com/lcomrade/horizon/blob/main/LICENSE)

**Horizon** is a simple program that performs the single function of transferring data using the HTTP protocol.
Despite its simplicity, it supports TLS encryption and a custom HTTP page template.
The program comes as a single binary file and can easily be ported to a UNIX-like system that has a GO compiler.

## Features
- Easy to install
- Easy to configure
- Simple and understandable command line interface
- Man pages
- Supports arm and arm64
- The program is compiled in native code
- Free license: GNU GPL 3+

## Installation
### GNU/Linux
Under Linux there are several options available. All of them can be found on the [release page](https://github.com/lcomrade/horizon/releases/latest):
- DEB
- RPM
- Lonely binary

### Windows
Under Windows there are several options available. All of them can be found on the [release page](https://github.com/lcomrade/horizon/releases/latest):
- Installer
- Install from chocolatey: `choco install -y horizon`
- Install from scoop:
```
scoop bucket add lcomrade https://github.com/lcomrade/ScoopBucket
scoop install horizon
```
- Or download zip archive from [release page](https://github.com/lcomrade/horizon/releases/latest)

### Another GNU/Linux or FreeBSD/OpenBSD/NetBSD
1. Download a binary file for your OS and architecture from the [release page](https://github.com/lcomrade/horizon/releases/latest)
2. Make the program executable
3. Place program in `/usr/local/bin/` or in another directory provided for installing binary files

`NOTE:` If you need man pages you can find it [here](https://github.com/lcomrade/horizon/releases/latest/download/man.tar)

## Documentation
### Build
- [Building on UNIX-like systems](https://github.com/lcomrade/horizon/blob/main/docs/make.md)
- [Build on Windows](https://github.com/lcomrade/horizon/blob/main/docs/make_bat.md)

### Configuration
Configuration documentation is supplied as man pages. If you installed Horizon from a DEB package or using `make install` the documentation is already installed.
Otherwise, you can download the latest documentation from [here](https://github.com/lcomrade/horizon/releases/latest/download/man.tar).

If you want to know more about configuration files read [configure.md](https://github.com/lcomrade/horizon/blob/main/docs/configure.md)

## Bugs and Suggestion
If you find a bug or have a suggestion, create an Issue [here](https://github.com/lcomrade/horizon/issues)
