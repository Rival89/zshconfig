.PHONY: bootstrap test install uninstall

PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man
BINDIR ?= $(PREFIX)/bin

INSTALL_DIR = $(DESTDIR)$(BINDIR)
MAN_DIR = $(DESTDIR)$(MANPREFIX)/man1

SCRIPTS = $(wildcard scripts/*)
MANPAGES = $(wildcard man/*.1)

install: bootstrap
	@echo "Installing scripts to $(INSTALL_DIR)..."
	@mkdir -p "$(INSTALL_DIR)"
	@install -m 755 $(SCRIPTS) "$(INSTALL_DIR)"
	@echo "Installing man pages to $(MAN_DIR)..."
	@mkdir -p "$(MAN_DIR)"
	@install -m 644 $(MANPAGES) "$(MAN_DIR)"
	@echo "Installation complete."

uninstall:
	@echo "Uninstalling scripts from $(INSTALL_DIR)..."
	@for script in $(SCRIPTS); do \
		rm -f "$(INSTALL_DIR)/$$(basename $$script)"; \
	done
	@echo "Uninstalling man pages from $(MAN_DIR)..."
	@for manpage in $(MANPAGES); do \
		rm -f "$(MAN_DIR)/$$(basename $$manpage)"; \
	done
	@echo "Uninstallation complete."

bootstrap:
	./scripts/bootstrap.sh

test:
	./run_tests.zsh
