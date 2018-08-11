PREFIX=/usr
MANDIR=$(PREFIX)/share/man
BINDIR=$(PREFIX)/bin

all:
	@echo "Run 'make install' for installation."
	@echo "Run 'make uninstall' for uninstallation."

install:
	install -Dm755 berate_ap $(DESTDIR)$(BINDIR)/berate_ap
	install -Dm644 berate_ap.conf $(DESTDIR)/etc/berate_ap.conf
	[ ! -d /lib/systemd/system ] || install -Dm644 berate_ap.service $(DESTDIR)$(PREFIX)/lib/systemd/system/berate_ap.service
	install -Dm644 bash_completion $(DESTDIR)$(PREFIX)/share/bash-completion/completions/berate_ap
	install -Dm644 README.md $(DESTDIR)$(PREFIX)/share/doc/berate_ap/README.md

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/berate_ap
	rm -f $(DESTDIR)/etc/berate_ap.conf
	[ ! -f /lib/systemd/system/berate_ap.service ] || rm -f $(DESTDIR)$(PREFIX)/lib/systemd/system/berate_ap.service
	rm -f $(DESTDIR)$(PREFIX)/share/bash-completion/completions/berate_ap
	rm -f $(DESTDIR)$(PREFIX)/share/doc/berate_ap/README.md
