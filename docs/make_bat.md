# Environment variables
It is not necessary to specify those environment variables for which a default value is specified.

## Configuration
`VERSION` - specifies the version (default: `nil`)

## Go compiler parameters
`GO` - path to Go compiler (default: `go`)

To get a complete list of architectures and OS run `go tool dist list`.

`GOOS` - specifies the OS (default: current OS)

`GOARCH` - specifies the arch (default: current arch)

To get the full list of ldfalgs run `go tool link -ldfalgs`.

`LDFLAGS` - go compiler flags (default: `-w -s`)

## Installation paths
`DESTDIR` - installation path (default: `%WINDIR%`)

# Make targets
After the build, the program and documentation will appear in the `./dist` directory.

## make configure
Configures the project and prepares it for build.

**Environment variables**: `VERSION`

## make
Build project and man pages.

**Environment variables**: `GO`, `GOOS`, `GOARCH`, `LDFLAGS`

## make release
Builds a project for all supported arch and OS, creates packages and creates an archive with man pages.

**Environment variables**: `GO`, `LDFLAGS`

## make install
Installs program.

**Environment variables**: `DESTDIR`, `GOOS`, `GOARCH`

## make uninstall
Uninstalls program.

**Environment variables**: `DESTDIR`

## make clean
Deletes all files created during configuration and build.
