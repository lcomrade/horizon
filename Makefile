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
SITE_URL = https://github.com/lcomrade/horizon
SITE_RELEASE_URL = https://github.com/lcomrade/horizon/releases/tag/v$(VERSION)


TMP_BUILD_DIR := /tmp/$(NAME)_build_$(shell head -c 100 /dev/urandom | base64 | sed 's/[+=/A-Z]//g' | tail -c 10)

.PHONY: all man docs configure test release install uninstall deb clean

all:
	@if [ ! -f "internal/build/build.go" ]; then make configure; fi
	mkdir -p dist/
	
	go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).$(GOOS).$(GOARCH) $(MAIN_GO)
	chmod 755 dist/$(NAME).$(GOOS).$(GOARCH)

	make man
	make docs

man:
	# EN MAN
	mkdir -p dist/man/man1/
	gzip -9 --no-name --force -c docs/man/man1/horizon.1 > dist/man/man1/horizon.1.gz
	mkdir -p dist/man/man5/
	gzip -9 --no-name --force -c docs/man/man5/horizon-configs.5 > dist/man/man5/horizon-configs.5.gz

	# RU MAN
	mkdir -p dist/man/ru/man1/
	gzip -9 --no-name --force -c docs/man/ru/man1/horizon.1 > dist/man/ru/man1/horizon.1.gz
	mkdir -p dist/man/ru/man5/
	gzip -9 --no-name --force -c docs/man/ru/man5/horizon-configs.5 > dist/man/ru/man5/horizon-configs.5.gz

docs:
	mkdir -p dist/docs/
	cp LICENSE dist/docs/LICENSE
	cp README.md dist/docs/README.md
	cp docs/configure.md dist/docs/configure.md

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
	#GNU/Linux
	@if [ ! -f "internal/build/build.go" ]; then make configure; fi
	mkdir -p dist/
	
	make man
	make docs
	tar --numeric-owner --owner=0 --group=0 --directory=dist/ -cf dist/nix_docs.tar man docs
	rm -rf dist/docs

	GOOS=linux GOARCH=386   go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.386 $(MAIN_GO)
	GOOS=linux GOARCH=amd64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.amd64 $(MAIN_GO)
	GOOS=linux GOARCH=arm64 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm64 $(MAIN_GO)

	GOOS=linux GOARCH=386   DEBARCH=i386  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=amd64 DEBARCH=amd64 VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=arm64 DEBARCH=arm64 VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb

	GOOS=linux GOARCH=386   RPMARCH=i386    VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make rpm
	GOOS=linux GOARCH=amd64 RPMARCH=x86_64  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make rpm
	GOOS=linux GOARCH=arm64 RPMARCH=aarch64 VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make rpm

	GOOS=linux GOARCH=arm GOARM=5 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v5 $(MAIN_GO)
	GOOS=linux GOARCH=arm GOARM=6 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v6 $(MAIN_GO)
	GOOS=linux GOARCH=arm GOARM=7 go build -ldflags="$(LDFLAGS)" -o dist/$(NAME).linux.arm_v7 $(MAIN_GO)

	GOOS=linux GOARCH=arm_v5 GOARM=5 DEBARCH=armel  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb
	GOOS=linux GOARCH=arm_v7 GOARM=7 DEBARCH=armhf  VERSION=$(VERSION) MAINTAINER="$(MAINTAINER)" make deb

	#BSD
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

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin/
	cp dist/$(NAME).$(GOOS).$(GOARCH) $(DESTDIR)$(PREFIX)/bin/$(NAME)

	cp -r build/unix-like/* $(DESTDIR)$(PREFIX)/

	mkdir -p $(DESTDIR)$(PREFIX)/share/man/
	cp -r dist/man/* $(DESTDIR)$(PREFIX)/share/man/

uninstall:
	rm $(DESTDIR)$(PREFIX)/bin/$(NAME)

	rm $(DESTDIR)$(PREFIX)/share/bash-completion/completions/horizon
	
	rm $(DESTDIR)$(PREFIX)/share/man/man1/horizon.1.gz
	rm $(DESTDIR)$(PREFIX)/share/man/man5/horizon-configs.5.gz
	rm $(DESTDIR)$(PREFIX)/share/man/ru/man1/horizon.1.gz
	rm $(DESTDIR)$(PREFIX)/share/man/ru/man5/horizon-configs.5.gz

deb:
	mkdir -p $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/
	cp -r build/DEBIAN/ $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/
	cp -r build/linux-pkg/* $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/
	
	mkdir -p $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	cp README.md $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	cp docs/configure.md $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/horizon/
	
	chmod 755 $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/postinst
	chmod 755 $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/postrm
	chmod 755 $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/etc/init.d/horizon
	
	echo 'Package: $(NAME)' > $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Provides: $(NAME)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Version: $(VERSION)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Architecture: $(DEBARCH)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	bash -c 'if [ "$(DEBARCH)" == "amd64" ]; then echo "Depends: libc6" >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control; fi'
	echo 'Recommends: logrotate, man-db, bash-completion' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Priority: optional' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Section: net' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Maintainer: $(MAINTAINER)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Origin: $(SITE_URL)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo 'Description: Minimalist WEB-server for data transfer via HTTP' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' Horizon is a simple program that performs the' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' single function of transferring data using the HTTP protocol.' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' Despite its simplicity, it supports TLS' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control
	echo ' encryption and a custom HTTP page template.' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/DEBIAN/control

	echo '$(NAME) ($(VERSION)) stable; urgency=medium' > $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  ' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  * $(SITE_RELEASE_URL)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo '  ' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog
	echo ' -- $(MAINTAINER)  $(shell date -R)' >> $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog

	gzip -9 --no-name --force $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/usr/share/doc/$(NAME)/changelog

	

	DESTDIR=$(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH) PREFIX=/usr make install

	bash -c "cd $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l usr/ > DEBIAN/md5sums"
	bash -c "cd $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l lib/ >> DEBIAN/md5sums"
	bash -c "cd $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)/ && md5deep -r -l etc/ >> DEBIAN/md5sums"

	fakeroot dpkg-deb --build $(TMP_BUILD_DIR)/$(NAME).$(GOOS).$(GOARCH)

	mv $(TMP_BUILD_DIR)/*.deb dist/$(NAME)_$(VERSION)_$(DEBARCH).deb
	
	rm -rf $(TMP_BUILD_DIR)/

rpm:
	mkdir -p $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/
	mkdir -p $(TMP_BUILD_DIR)/SPECS/

	cp -r build/linux-pkg/* $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/

	mkdir -p $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/usr/share/doc/horizon/
	cp README.md $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/usr/share/doc/horizon/
	cp docs/configure.md $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/usr/share/doc/horizon/

	chmod 755 $(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH)/etc/init.d/horizon

	echo 'Name: $(NAME)' > $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Version: $(VERSION)' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Release: 1' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Summary: Minimalist WEB-server for data transfer via HTTP' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Packager: $(MAINTAINER)' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'License: GPLv3+' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'URL: $(SITE_URL)' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%description' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Horizon is a simple program that performs the' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'single function of transferring data using the HTTP protocol.' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'Despite its simplicity, it supports TLS' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'encryption and a custom HTTP page template.' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%post' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'if [ -f "/sbin/update-rc.d" ]; then /sbin/update-rc.d horizon defaults; fi' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'if [ -f "/bin/systemctl" ]; then /bin/systemctl daemon-reload; fi' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%postun' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'if [ -f "/sbin/update-rc.d" ]; then /sbin/update-rc.d horizon defaults; fi' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo 'if [ -f "/bin/systemctl" ]; then /bin/systemctl daemon-reload; fi' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%files' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%defattr(-,root,root)' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '/usr/bin/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '/usr/share/bash-completion/completions/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '/lib/systemd/system/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '/etc/init.d/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '/etc/logrotate.d/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%doc /usr/share/doc/$(NAME)/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%doc /usr/share/man/man?/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%doc /usr/share/man/ru/man?/*' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '%changelog' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '* $(shell date "+%a %b %d %Y") $(MAINTAINER) - $(VERSION)-1' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec
	echo '- $(SITE_RELEASE_URL)' >> $(TMP_BUILD_DIR)/SPECS/$(NAME).spec

	DESTDIR=$(TMP_BUILD_DIR)/BUILDROOT/$(NAME)-$(VERSION)-1.$(RPMARCH) PREFIX=/usr make install
	
	
	BUILDROOT=$(TMP_BUILD_DIR)/BUILDROOT rpmbuild --target $(RPMARCH) --define '_topdir $(TMP_BUILD_DIR)' -bb $(TMP_BUILD_DIR)/SPECS/$(NAME).spec

	mv $(TMP_BUILD_DIR)/RPMS/$(RPMARCH)/*.rpm dist/

	rm -rf $(TMP_BUILD_DIR)/
	

clean:
	rm -rf dist/
	rm -rf internal/build/
	rm -f build/windows/build.iss
	rm -rf /tmp/$(NAME)_build_*
