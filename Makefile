PACKAGE = 'yunoconfig'
VERSION = '0.1'

PREFIX := /usr/local
BINDIR := $(PREFIX)/bin
LIBDIR := $(PREFIX)/lib
SHAREDIR := $(PREFIX)/share
INCLUDEDIR := $(PREFIX)/include
MANDIR := $(SHAREDIR)/man
LUA_VERSION := 5.1

CC := cc
AR := ar
RANLIB := ranlib
CFLAGS := 
LDFLAGS := 

Q := @

all: yunoconfig.moon yunoconfig/configuration/domain.moon yunoconfig/configuration/host.moon yunoconfig/configuration.moon yunoconfig/configuration/object.moon yunoconfig/configuration/root.moon yunoconfig/configuration/service.moon yunoconfig/context.moon yunoconfig/definition/consumes.moon yunoconfig/definition/provides.moon yunoconfig/definition/service.moon data/certificates.moon data/ip-php.moon data/nginx.moon data/openrc.moon data/slapd.moon data/test-app.moon data/www.moon data/templates/nginx.ept data/templates/openrc.ept doc/yunoconfig.1
	@:

yunoconfig.moon: yunoconfig.moon.in
	@echo '[01;32m  SED >   [01;37myunoconfig.moon[00m'
	$(Q)sed -e 's&@LIBDIR@&$(LIBDIR)&;s&@BINDIR@&$(BINDIR)&;s&@SHAREDIR@&$(SHAREDIR)&;' yunoconfig.moon.in > 'yunoconfig.moon'
	$(Q)chmod +x 'yunoconfig.moon'


yunoconfig.moon.install: yunoconfig.moon
	@echo '[01;31m  IN >    [01;37m$(BINDIR)/yunoconfig[00m'
	$(Q)mkdir -p '$(DESTDIR)$(BINDIR)'
	$(Q)install -m0755 yunoconfig.moon $(DESTDIR)$(BINDIR)/yunoconfig

yunoconfig.moon.clean:
	@echo '[01;37m  RM >    [01;37myunoconfig.moon[00m'
	$(Q)rm -f yunoconfig.moon

yunoconfig.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(BINDIR)/yunoconfig[00m'
	$(Q)rm -f '$(DESTDIR)$(BINDIR)/yunoconfig'

yunoconfig/configuration/domain.moon:

yunoconfig/configuration/domain.moon.install: yunoconfig/configuration/domain.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/domain.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration'
	$(Q)install -m0755 yunoconfig/configuration/domain.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/domain.moon

yunoconfig/configuration/domain.moon.clean:

yunoconfig/configuration/domain.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/domain.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/domain.moon'

yunoconfig/configuration/host.moon:

yunoconfig/configuration/host.moon.install: yunoconfig/configuration/host.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/host.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration'
	$(Q)install -m0755 yunoconfig/configuration/host.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/host.moon

yunoconfig/configuration/host.moon.clean:

yunoconfig/configuration/host.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/host.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/host.moon'

yunoconfig/configuration.moon:

yunoconfig/configuration.moon.install: yunoconfig/configuration.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig'
	$(Q)install -m0755 yunoconfig/configuration.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration.moon

yunoconfig/configuration.moon.clean:

yunoconfig/configuration.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration.moon'

yunoconfig/configuration/object.moon:

yunoconfig/configuration/object.moon.install: yunoconfig/configuration/object.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/object.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration'
	$(Q)install -m0755 yunoconfig/configuration/object.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/object.moon

yunoconfig/configuration/object.moon.clean:

yunoconfig/configuration/object.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/object.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/object.moon'

yunoconfig/configuration/root.moon:

yunoconfig/configuration/root.moon.install: yunoconfig/configuration/root.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/root.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration'
	$(Q)install -m0755 yunoconfig/configuration/root.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/root.moon

yunoconfig/configuration/root.moon.clean:

yunoconfig/configuration/root.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/root.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/root.moon'

yunoconfig/configuration/service.moon:

yunoconfig/configuration/service.moon.install: yunoconfig/configuration/service.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/service.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration'
	$(Q)install -m0755 yunoconfig/configuration/service.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/service.moon

yunoconfig/configuration/service.moon.clean:

yunoconfig/configuration/service.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/service.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/configuration/service.moon'

yunoconfig/context.moon:

yunoconfig/context.moon.install: yunoconfig/context.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/context.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig'
	$(Q)install -m0755 yunoconfig/context.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/context.moon

yunoconfig/context.moon.clean:

yunoconfig/context.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/context.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/context.moon'

yunoconfig/definition/consumes.moon:

yunoconfig/definition/consumes.moon.install: yunoconfig/definition/consumes.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/consumes.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition'
	$(Q)install -m0755 yunoconfig/definition/consumes.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/consumes.moon

yunoconfig/definition/consumes.moon.clean:

yunoconfig/definition/consumes.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/consumes.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/consumes.moon'

yunoconfig/definition/provides.moon:

yunoconfig/definition/provides.moon.install: yunoconfig/definition/provides.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/provides.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition'
	$(Q)install -m0755 yunoconfig/definition/provides.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/provides.moon

yunoconfig/definition/provides.moon.clean:

yunoconfig/definition/provides.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/provides.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/provides.moon'

yunoconfig/definition/service.moon:

yunoconfig/definition/service.moon.install: yunoconfig/definition/service.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/service.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition'
	$(Q)install -m0755 yunoconfig/definition/service.moon $(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/service.moon

yunoconfig/definition/service.moon.clean:

yunoconfig/definition/service.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/service.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/lua/$(LUA_VERSION)/yunoconfig/definition/service.moon'

data/certificates.moon:

data/certificates.moon.install: data/certificates.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/certificates.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/certificates.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/certificates.moon

data/certificates.moon.clean:

data/certificates.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/certificates.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/certificates.moon'

data/ip-php.moon:

data/ip-php.moon.install: data/ip-php.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/ip-php.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/ip-php.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/ip-php.moon

data/ip-php.moon.clean:

data/ip-php.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/ip-php.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/ip-php.moon'

data/nginx.moon:

data/nginx.moon.install: data/nginx.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/nginx.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/nginx.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/nginx.moon

data/nginx.moon.clean:

data/nginx.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/nginx.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/nginx.moon'

data/openrc.moon:

data/openrc.moon.install: data/openrc.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/openrc.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/openrc.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/openrc.moon

data/openrc.moon.clean:

data/openrc.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/openrc.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/openrc.moon'

data/slapd.moon:

data/slapd.moon.install: data/slapd.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/slapd.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/slapd.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/slapd.moon

data/slapd.moon.clean:

data/slapd.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/slapd.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/slapd.moon'

data/test-app.moon:

data/test-app.moon.install: data/test-app.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/test-app.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/test-app.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/test-app.moon

data/test-app.moon.clean:

data/test-app.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/test-app.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/test-app.moon'

data/www.moon:

data/www.moon.install: data/www.moon
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/www.moon[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig'
	$(Q)install -m0755 data/www.moon $(DESTDIR)$(SHAREDIR)/yunoconfig/www.moon

data/www.moon.clean:

data/www.moon.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/www.moon[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/www.moon'

data/templates/nginx.ept:

data/templates/nginx.ept.install: data/templates/nginx.ept
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/templates/nginx.ept[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig/templates'
	$(Q)install -m0755 data/templates/nginx.ept $(DESTDIR)$(SHAREDIR)/yunoconfig/templates/nginx.ept

data/templates/nginx.ept.clean:

data/templates/nginx.ept.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/templates/nginx.ept[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/templates/nginx.ept'

data/templates/openrc.ept:

data/templates/openrc.ept.install: data/templates/openrc.ept
	@echo '[01;31m  IN >    [01;37m$(SHAREDIR)/yunoconfig/templates/openrc.ept[00m'
	$(Q)mkdir -p '$(DESTDIR)$(SHAREDIR)/yunoconfig/templates'
	$(Q)install -m0755 data/templates/openrc.ept $(DESTDIR)$(SHAREDIR)/yunoconfig/templates/openrc.ept

data/templates/openrc.ept.clean:

data/templates/openrc.ept.uninstall:
	@echo '[01;37m  RM >    [01;37m$(SHAREDIR)/yunoconfig/templates/openrc.ept[00m'
	$(Q)rm -f '$(DESTDIR)$(SHAREDIR)/yunoconfig/templates/openrc.ept'

doc/yunoconfig.1: doc/yunoconfig.1.md
	@echo '[01;32m  MAN >   [01;37mdoc/yunoconfig.1[00m'
	$(Q)pandoc -s --from markdown --to man 'doc/yunoconfig.1.md' -o 'doc/yunoconfig.1'


doc/yunoconfig.1.install: doc/yunoconfig.1
	@echo '[01;31m  IN >    [01;37m$(MANDIR)/man1/yunoconfig.1[00m'
	$(Q)mkdir -p '$(DESTDIR)$(MANDIR)/man1'
	$(Q)install -m0644 doc/yunoconfig.1 $(DESTDIR)$(MANDIR)/man1/yunoconfig.1

doc/yunoconfig.1.clean:
	@echo '[01;37m  RM >    [01;37mdoc/yunoconfig.1[00m'
	$(Q)rm -f doc/yunoconfig.1

doc/yunoconfig.1.uninstall:
	@echo '[01;37m  RM >    [01;37m$(MANDIR)/man1/yunoconfig.1[00m'
	$(Q)rm -f '$(DESTDIR)$(MANDIR)/man1/yunoconfig.1'

$(DESTDIR)$(PREFIX):
	@echo '[01;35m  DIR >   [01;37m$(PREFIX)[00m'
	$(Q)mkdir -p $(DESTDIR)$(PREFIX)
$(DESTDIR)$(BINDIR):
	@echo '[01;35m  DIR >   [01;37m$(BINDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(BINDIR)
$(DESTDIR)$(LIBDIR):
	@echo '[01;35m  DIR >   [01;37m$(LIBDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(LIBDIR)
$(DESTDIR)$(SHAREDIR):
	@echo '[01;35m  DIR >   [01;37m$(SHAREDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(SHAREDIR)
$(DESTDIR)$(INCLUDEDIR):
	@echo '[01;35m  DIR >   [01;37m$(INCLUDEDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(INCLUDEDIR)
$(DESTDIR)$(MANDIR):
	@echo '[01;35m  DIR >   [01;37m$(MANDIR)[00m'
	$(Q)mkdir -p $(DESTDIR)$(MANDIR)
install: subdirs.install yunoconfig.moon.install yunoconfig/configuration/domain.moon.install yunoconfig/configuration/host.moon.install yunoconfig/configuration.moon.install yunoconfig/configuration/object.moon.install yunoconfig/configuration/root.moon.install yunoconfig/configuration/service.moon.install yunoconfig/context.moon.install yunoconfig/definition/consumes.moon.install yunoconfig/definition/provides.moon.install yunoconfig/definition/service.moon.install data/certificates.moon.install data/ip-php.moon.install data/nginx.moon.install data/openrc.moon.install data/slapd.moon.install data/test-app.moon.install data/www.moon.install data/templates/nginx.ept.install data/templates/openrc.ept.install doc/yunoconfig.1.install
	@:

subdirs.install:

uninstall: subdirs.uninstall yunoconfig.moon.uninstall yunoconfig/configuration/domain.moon.uninstall yunoconfig/configuration/host.moon.uninstall yunoconfig/configuration.moon.uninstall yunoconfig/configuration/object.moon.uninstall yunoconfig/configuration/root.moon.uninstall yunoconfig/configuration/service.moon.uninstall yunoconfig/context.moon.uninstall yunoconfig/definition/consumes.moon.uninstall yunoconfig/definition/provides.moon.uninstall yunoconfig/definition/service.moon.uninstall data/certificates.moon.uninstall data/ip-php.moon.uninstall data/nginx.moon.uninstall data/openrc.moon.uninstall data/slapd.moon.uninstall data/test-app.moon.uninstall data/www.moon.uninstall data/templates/nginx.ept.uninstall data/templates/openrc.ept.uninstall doc/yunoconfig.1.uninstall
	@:

subdirs.uninstall:

test: all subdirs subdirs.test
	@:

subdirs.test:

clean: yunoconfig.moon.clean yunoconfig/configuration/domain.moon.clean yunoconfig/configuration/host.moon.clean yunoconfig/configuration.moon.clean yunoconfig/configuration/object.moon.clean yunoconfig/configuration/root.moon.clean yunoconfig/configuration/service.moon.clean yunoconfig/context.moon.clean yunoconfig/definition/consumes.moon.clean yunoconfig/definition/provides.moon.clean yunoconfig/definition/service.moon.clean data/certificates.moon.clean data/ip-php.moon.clean data/nginx.moon.clean data/openrc.moon.clean data/slapd.moon.clean data/test-app.moon.clean data/www.moon.clean data/templates/nginx.ept.clean data/templates/openrc.ept.clean doc/yunoconfig.1.clean

distclean: clean

dist: dist-gz dist-xz dist-bz2
	$(Q)rm -- $(PACKAGE)-$(VERSION)

distdir:
	$(Q)rm -rf -- $(PACKAGE)-$(VERSION)
	$(Q)ln -s -- . $(PACKAGE)-$(VERSION)

dist-gz: $(PACKAGE)-$(VERSION).tar.gz
$(PACKAGE)-$(VERSION).tar.gz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.gz[00m'
	$(Q)tar czf $(PACKAGE)-$(VERSION).tar.gz \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/domain.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/host.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/object.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/root.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/service.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/context.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/consumes.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/provides.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/service.moon \
		$(PACKAGE)-$(VERSION)/data/certificates.moon \
		$(PACKAGE)-$(VERSION)/data/ip-php.moon \
		$(PACKAGE)-$(VERSION)/data/nginx.moon \
		$(PACKAGE)-$(VERSION)/data/openrc.moon \
		$(PACKAGE)-$(VERSION)/data/slapd.moon \
		$(PACKAGE)-$(VERSION)/data/test-app.moon \
		$(PACKAGE)-$(VERSION)/data/www.moon \
		$(PACKAGE)-$(VERSION)/data/templates/nginx.ept \
		$(PACKAGE)-$(VERSION)/data/templates/openrc.ept \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/doc/yunoconfig.1.md \
		$(PACKAGE)-$(VERSION)/yunoconfig.moon.in

dist-xz: $(PACKAGE)-$(VERSION).tar.xz
$(PACKAGE)-$(VERSION).tar.xz: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.xz[00m'
	$(Q)tar cJf $(PACKAGE)-$(VERSION).tar.xz \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/domain.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/host.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/object.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/root.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/service.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/context.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/consumes.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/provides.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/service.moon \
		$(PACKAGE)-$(VERSION)/data/certificates.moon \
		$(PACKAGE)-$(VERSION)/data/ip-php.moon \
		$(PACKAGE)-$(VERSION)/data/nginx.moon \
		$(PACKAGE)-$(VERSION)/data/openrc.moon \
		$(PACKAGE)-$(VERSION)/data/slapd.moon \
		$(PACKAGE)-$(VERSION)/data/test-app.moon \
		$(PACKAGE)-$(VERSION)/data/www.moon \
		$(PACKAGE)-$(VERSION)/data/templates/nginx.ept \
		$(PACKAGE)-$(VERSION)/data/templates/openrc.ept \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/doc/yunoconfig.1.md \
		$(PACKAGE)-$(VERSION)/yunoconfig.moon.in

dist-bz2: $(PACKAGE)-$(VERSION).tar.bz2
$(PACKAGE)-$(VERSION).tar.bz2: distdir
	@echo '[01;33m  TAR >   [01;37m$(PACKAGE)-$(VERSION).tar.bz2[00m'
	$(Q)tar cjf $(PACKAGE)-$(VERSION).tar.bz2 \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/domain.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/host.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/object.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/root.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/configuration/service.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/context.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/consumes.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/provides.moon \
		$(PACKAGE)-$(VERSION)/yunoconfig/definition/service.moon \
		$(PACKAGE)-$(VERSION)/data/certificates.moon \
		$(PACKAGE)-$(VERSION)/data/ip-php.moon \
		$(PACKAGE)-$(VERSION)/data/nginx.moon \
		$(PACKAGE)-$(VERSION)/data/openrc.moon \
		$(PACKAGE)-$(VERSION)/data/slapd.moon \
		$(PACKAGE)-$(VERSION)/data/test-app.moon \
		$(PACKAGE)-$(VERSION)/data/www.moon \
		$(PACKAGE)-$(VERSION)/data/templates/nginx.ept \
		$(PACKAGE)-$(VERSION)/data/templates/openrc.ept \
		$(PACKAGE)-$(VERSION)/project.zsh \
		$(PACKAGE)-$(VERSION)/Makefile \
		$(PACKAGE)-$(VERSION)/README.md \
		$(PACKAGE)-$(VERSION)/doc/yunoconfig.1.md \
		$(PACKAGE)-$(VERSION)/yunoconfig.moon.in

help:
	@echo '[01;37m :: yunoconfig-0.1[00m'
	@echo ''
	@echo '[01;37mGeneric targets:[00m'
	@echo '[00m    - [01;32mhelp          [37m Prints this help message.[00m'
	@echo '[00m    - [01;32mall           [37m Builds all targets.[00m'
	@echo '[00m    - [01;32mdist          [37m Creates tarballs of the files of the project.[00m'
	@echo '[00m    - [01;32minstall       [37m Installs the project.[00m'
	@echo '[00m    - [01;32mclean         [37m Removes compiled files.[00m'
	@echo '[00m    - [01;32muninstall     [37m Deinstalls the project.[00m'
	@echo ''
	@echo '[01;37mCLI-modifiable variables:[00m'
	@echo '    - [01;34mCC            [37m ${CC}[00m'
	@echo '    - [01;34mCFLAGS        [37m ${CFLAGS}[00m'
	@echo '    - [01;34mLDFLAGS       [37m ${LDFLAGS}[00m'
	@echo '    - [01;34mDESTDIR       [37m ${DESTDIR}[00m'
	@echo '    - [01;34mPREFIX        [37m ${PREFIX}[00m'
	@echo '    - [01;34mBINDIR        [37m ${BINDIR}[00m'
	@echo '    - [01;34mLIBDIR        [37m ${LIBDIR}[00m'
	@echo '    - [01;34mSHAREDIR      [37m ${SHAREDIR}[00m'
	@echo '    - [01;34mINCLUDEDIR    [37m ${INCLUDEDIR}[00m'
	@echo '    - [01;34mMANDIR        [37m ${MANDIR}[00m'
	@echo '    - [01;34mLUA_VERSION   [37m ${LUA_VERSION}[00m'
	@echo ''
	@echo '[01;37mProject targets: [00m'
	@echo '    - [01;33myunoconfig.moon[37m script[00m'
	@echo '    - [01;33mdoc/yunoconfig.1[37m man[00m'
	@echo ''
	@echo '[01;37mMakefile options:[00m'
	@echo '    - gnu:           false'
	@echo '    - colors:        true'
	@echo ''
	@echo '[01;37mRebuild the Makefile with:[00m'
	@echo '    zsh ./build.zsh -c'
.PHONY: all subdirs clean distclean dist install uninstall help

