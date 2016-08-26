# +----------------------------------------------------------------------------+
# | Electrontubes v0.4.1 * Electrontube bias calculator                        |
# | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for other files                                                   |
# +----------------------------------------------------------------------------+

include ../Makefile.global

desktopfiles= `ls *.desktop`
iconfiles = `ls *.xpm`

all:

clean:

install:
	@echo -n "- Installing desktop files..."
	@$(install) -d $(datarootdir)/applications
	@for x in $(desktopfiles); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(datarootdir)/applications/; fi; \
	done
	@echo "done."
	@echo -n "- Installing icon files..."
	@$(install) -d $(datarootdir)/pixmaps
	@for x in $(iconfiles); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(datarootdir)/pixmaps/; fi; \
	done
	@echo "done."

uninstall:
	@echo -n "- Removing desktop files..."
	@for x in $(desktopfiles); do \
	  if [ -e $$x ]; then $(rm) $(datarootdir)/applications/$$x; fi; \
	done
	@echo "done."
	@echo -n "- Removing icon files..."
	@for x in $(iconfiles); do \
	  if [ -e $$x ]; then $(rm) $(datarootdir)/pixmaps/$$x; fi; \
	done
	@echo "Done."

