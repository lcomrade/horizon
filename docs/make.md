# Environment variables
It is not necessary to specify those environment variables for which a default value is specified.

## Configuration
`VERSION` - specifies the version (default: `nil`)

`SysConfigDir` - sets the system directory with configuration files (default: `/etc/horizon/`)

`UserHomeEnvVar` - sets an environment variable containing the path to the user's home directory (default: `HOME`)

`UserConfigDir` - sets the path to the configuration files relative to the user's home directory (default: `.config/horizon/`)

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

`MAINTAINER` - name of the package maintainer in the format `Name <mail@example.org>` (default: `nil <nil>`)


# Make targets
After the build, the program and documentation will appear in the `./dist` directory.

## make configure
Configures the project and prepares it for build.

**Environment variables**: `VERSION`, `SysConfigDir`, `UserHomeEnvVar`, `UserConfigDir`

## make
Build project and man pages.

**Environment variables**: `GOOS`, `GOARCH`, `LDFLAGS`

## make man
Build only man pages.

## make test
Tests the project with automated tests.

## make release
Builds a project for all supported arch and OS, creates packages and creates an archive with man pages.

**Environment variables**: `LDFLAGS`, `VERSION`, `MAINTAINER`

## make install
Installs program.

**Environment variables**: `DESTDIR`, `PREFIX`, `GOOS`, `GOARCH`

## make uninstall
Uninstalls program.

**Environment variables**: `DESTDIR`, `PREFIX`

## make deb
Creates the deb package.

**Environment variables**: `GOOS`, `GOARCH`, `VERSION`, `DEBARCH`, `MAINTAINER`

## make clean
Deletes all files created during configuration and build.
