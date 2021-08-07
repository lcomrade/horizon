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
### Debian/Ubuntu
1. Download the DEB package for your architecture from the [release](https://github.com/lcomrade/horizon/releases/latest) page
2. Install the downloaded DEB package

### Another GNU/Linux or FreeBSD/OpenBSD/NetBSD
1. Download a binary file for your OS and architecture from the [release](https://github.com/lcomrade/horizon/releases/latest) page
2. Make the program executable
3. Place program in `/usr/local/bin/` or in another directory provided for installing binary files

`NOTE:` If you need man pages you can find it [here](https://github.com/lcomrade/horizon/releases/latest/man.tar)

### Compiling from source code
1. Install `Go`, `GNU Make` and `gzip`
2. Download the source code from the [release](https://github.com/lcomrade/horizon/releases/latest) page
3. Unpack the source code
4. Run: `make`
5. Run as root: `make install`

`NOTE:` If you want to uninstall Horizon run as root: `make uninstall`

## Documentation
All documentation is supplied as man pages. If you installed Horizon from a DEB package or using `make install` the documentation is already installed.
Otherwise, you can download the latest documentation from [here](https://github.com/lcomrade/horizon/releases/latest/man.tar).

## Bugs and Suggestion
If you find a bug or have a suggestion, create an Issue [here](https://github.com/lcomrade/horizon/issues)
