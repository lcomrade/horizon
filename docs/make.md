`NOTE:` If you need **build and installation example**, see the 'Example' section.

# Environment variables
It is not necessary to specify those environment variables for which a default value is specified.

## Configuration
`VERSION` - specifies the version (default: `nil`)

`SysConfigDir` - sets the system directory with configuration files (default: `/etc/horizon/`)

`UserHomeEnvVar` - sets an environment variable containing the path to the user's home directory (default: `HOME`)

`UserConfigDir` - sets the path to the configuration files relative to the user's home directory (default: `.config/horizon/`)

`LangEnvVar` - sets the environment variable containing the locale (default: `LANG`)

## Go compiler parameters
To get a complete list of architectures and OS run `go tool dist list`.

`GOOS` - specifies the OS (default: current OS)

`GOARCH` - specifies the arch (default: current arch)

To get the full list of ldfalgs run `go tool link -ldfalgs`.

`LDFLAGS` - go compiler flags (default: `-w -s`)

## Installation paths
`DESTDIR` - part 1 of the installation path (default: ` `)

`PREFIX` - part 2 of the installation path (default: `/usr/local`)

## Creating packages
`DEBARCH` - architecture for which the deb package is created

`RPMARCH` - architecture for which the rpm package is created

`MAINTAINER` - name of the package maintainer in the format `Name <mail@example.org>` (default: `nil <nil>`)


# Make targets
After the build, the program and documentation will appear in the `./dist` directory.

## make configure
Configures the project and prepares it for build.

**Environment variables**: `VERSION`, `SysConfigDir`, `UserHomeEnvVar`, `UserConfigDir`, `LangEnvVar`

## make
Build project and man pages.

**Environment variables**: `GOOS`, `GOARCH`, `LDFLAGS`

**Dependencies**: `make configure`

## make man
Build only man pages.

## make test
Tests the project with automated tests.

**Dependencies**: `make configure`

## make release
Builds a project for all supported arch and OS, creates packages and creates an archive with man pages.

**Environment variables**: `LDFLAGS`, `VERSION`, `MAINTAINER`

**Dependencies**: `make configure`

## make install
Installs program.

**Environment variables**: `DESTDIR`, `PREFIX`, `GOOS`, `GOARCH`

**Dependencies**: `make`

## make uninstall
Uninstalls program.

**Environment variables**: `DESTDIR`, `PREFIX`

## make deb
Creates the deb package.

**Environment variables**: `GOOS`, `GOARCH`, `VERSION`, `DEBARCH`, `MAINTAINER`

## make rpm
Creates the rpm package.

**Environment variables**: `GOOS`, `GOARCH`, `VERSION`, `RPMARCH`, `MAINTAINER`

## make clean
Deletes all files created during configuration and build.

# Example
1. **Configure build:** `make configure`
2. **Create binary file:** `make`
3. **Pack man pages:** `make man`
4. **Install:** `make install`
