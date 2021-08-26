NAME = horizon
VERSION ?= nil
SysConfigDir ?= /etc/horizon/
UserHomeEnvVar ?= HOME
UserConfigDir ?= .config/horizon/
LangEnvVar ?= LANG

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
LDFLAGS ?= -w -s
MAIN_GO = ./cmd/horizon.go

PREFIX ?= /usr/local

MAINTAINER ?= nil <nil>
DEB_BUILD_DIR := /tmp/$(shell head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c 10)

.PHONY: all man configure test release install uninstall deb clean

all:
	@if [ ! -f "internal/build/build.go" ]; then make configure; fi
	mkdir -p dist/
	
	go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).$(GOOS).$(GOARCH) $(MAIN_GO)
	chmod 755 dist/$(NAME).$(GOOS).$(GOARCH)

	make man

man:
	mkdir -p dist/man/man1/
	gzip -9 --no-name --force -c docs/man/man1/horizon.1 > dist/man/man1/horizon.1.gz
	mkdir -p dist/man/man5/
	gzip -9 --no-name --force -c docs/man/man5/horizon-configs.5 > dist/man/man5/horizon-configs.5.gz

configure:
	mkdir -p internal/build/
	echo 'package build' > internal/build/build.go
	echo '' >> internal/build/build.go
	echo 'var Name = "$(NAME)"' >> internal/build/build.go
	echo 'var Version = "$(VERSION)"' >> internal/build/build.go
	echo 'var SysConfigDir = "$(SysConfigDir)"' >> internal/build/build.go
	echo 'var UserHomeEnvVar = "$(UserHomeEnvVar)"' >> internal/build/build.go
	echo 'var UserConfigDir = "$(UserConfigDir)"' >> internal/build/build.go
	echo 'var LangEnvVar = "$(LangEnvVar)"' >> internal/build/build.go

test:
	@if [ ! -f "internal/build/build.go" ]; then make configure; fi
	go test -v ./...

release:
	#UNIX-like
	@if [ ! -f "internal/build/build.go" ]; then make configure; fi
	mkdir -p dist/
	
	make man
	tar --numeric-owner --owner=0 --group=0 --directory=dist/ -cf dist/man.tar man

	GOOS=linux GOARCH=386   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.386 $(MAIN_GO)
	GOOS=linux GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.amd64 $(MAIN_GO)
	GOOS=linux GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm64 $(MAIN_GO)

	GOOS=linux GOARCH=386   DEBARCH=i386  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=amd64 DEBARCH=amd64 VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=arm64 DEBARCH=arm64 VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb

	GOOS=linux GOARCH=arm GOARM=5 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v5 $(MAIN_GO)
	GOOS=linux GOARCH=arm GOARM=6 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v6 $(MAIN_GO)
	GOOS=linux GOARCH=arm GOARM=7 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v7 $(MAIN_GO)

	GOOS=linux GOARCH=arm_v5 GOARM=5 DEBARCH=armel  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=arm_v7 GOARM=7 DEBARCH=armhf  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb

	GOOS=freebsd GOARCH=386   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).freebsd.386 $(MAIN_GO)
	GOOS=freebsd GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).freebsd.amd64 $(MAIN_GO)
	GOOS=freebsd GOARCH=arm   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).freebsd.arm $(MAIN_GO)
	GOOS=freebsd GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).freebsd.arm64 $(MAIN_GO)

	GOOS=openbsd GOARCH=386   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).openbsd.386 $(MAIN_GO)
	GOOS=openbsd GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).openbsd.amd64 $(MAIN_GO)
	GOOS=openbsd GOARCH=arm   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).openbsd.arm $(MAIN_GO)
	GOOS=openbsd GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).openbsd.arm64 $(MAIN_GO)

	GOOS=netbsd GOARCH=386    go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).netbsd.386 $(MAIN_GO)
	GOOS=netbsd GOARCH=amd64  go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).netbsd.amd64 $(MAIN_GO)
	GOOS=netbsd GOARCH=arm    go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).netbsd.arm $(MAIN_GO)
	GOOS=netbsd GOARCH=arm64  go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).netbsd.arm64 $(MAIN_GO)

	rm -rf dist/man/

	#Windows
	#echo 'package build' > internal/build/build.go
	#echo '' >> internal/build/build.go
	#echo 'var Name = "$(NAME)"' >> internal/build/build.go
	#echo 'var Version = "$(VERSION)"' >> internal/build/build.go
	#echo 'var SysConfigDir = `C:\ProgramData\horizon\`' >> internal/build/build.go
	#echo 'var UserHomeEnvVar = "APPDATA"' >> internal/build/build.go
	#echo 'var UserConfigDir = `horizon\`' >> internal/build/build.go
	#echo 'var LangEnvVar = "LANG"' >> internal/build/build.go

	#GOOS=windows GOARCH=386    go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).windows.386.exe $(MAIN_GO)
	#GOOS=windows GOARCH=amd64  go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).windows.amd64.exe $(MAIN_GO)
	#GOOS=windows GOARCH=arm    go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).windows.arm.exe $(MAIN_GO)

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	cp dist/$(NAME).$(GOOS).$(GOARCH) $(DESTDIR)$(PREFIX)/bin/$(NAME)

	cp -r build/unix-like/* $(DESTDIR)$(PREFIX)/

	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1/
	cp dist/man/man1/horizon.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/horizon.1.gz
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man5/
	cp dist/man/man5/horizon-configs.5.gz $(DESTDIR)$(PREFIX)/share/man/man5/horizon-configs.5.gz

uninstall:
	rm $(DESTDIR)$(PREFIX)/bin/$(NAME)

	rm $(DESTDIR)$(PREFIX)/share/bash-completion/completions/horizon
	
	rm $(DESTDIR)$(PREFIX)/share/man/man1/horizon.1.gz
	rm $(DESTDIR)$(PREFIX)/share/man/man5/horizon-configs.5.gz

deb:
	mkdir -p $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/
	cp -r build/deb/* $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/
	
	mkdir -p $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	cp README.md $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	cp docs/configure.md $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	
	chmod 755 $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/postinst
	chmod 755 $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/postrm
	chmod 755 $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/etc/init.d/horizon
	
	echo 'Package: $(NAME)' > $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Provides: $(NAME)' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Version: $(VERSION)' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Architecture: $(DEBARCH)' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	bash -c 'if [ "$(DEBARCH)" == "amd64" ]; then echo "Depends: libc6" >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control; fi'
	echo 'Recommends: logrotate, man-db, bash-completion' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Priority: optional' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Section: net' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Maintainer: $(MAINTAINER)' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Origin: https://github.com/lcomrade/horizon' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Description: Minimalist WEB-server for data transfer via HTTP' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' Horizon is a simple program that performs the' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' single function of transferring data using the HTTP protocol.' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' Despite its simplicity, it supports TLS' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' encryption and a custom HTTP page template.' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control

	echo '$(NAME) ($(VERSION)) stable; urgency=medium' > $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  ' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  * https://github.com/lcomrade/horizon/releases' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  ' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo ' -- $(MAINTAINER)  $(shell date -R)' >> $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog

	gzip -9 --no-name --force $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog

	

	DESTDIR=$(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH) PREFIX=/usr make install

	bash -c "cd $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l usr/ > DEBIAN/md5sums"
	bash -c "cd $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l lib/ >> DEBIAN/md5sums"
	bash -c "cd $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l etc/ >> DEBIAN/md5sums"

	fakeroot dpkg-deb --build $(DEB_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)

	mv $(DEB_BUILD_DIR)/*.deb dist/$(NAME)_$(VERSION)_$(DEBARCH).deb
	
	rm -rf $(DEB_BUILD_DIR)/

clean:
	rm -rf dist/
	rm -rf internal/build/
	rm -f build/windows/build.iss
