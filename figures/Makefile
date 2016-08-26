# +----------------------------------------------------------------------------+
# | Electrontubes v0.4.1 * Electrontube bias calculator                        |
# | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for other files                                                   |
# +----------------------------------------------------------------------------+

include ../Makefile.global

files= `ls *.png`

all:

clean:

install:
	@echo -n "- Installing other files..."
	@$(install) -d $(datarootdir)/$(name)/figures/
	@for x in $(files); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(datarootdir)/$(name)/figures; fi; \
	done
	@echo "done."

uninstall:
	@echo -n "- Removing other files..."
	@for x in $(files); do \
	  if [ -e $$x ]; then $(rm) $(datarootdir)/$(name)/figures/$$x; fi; \
	done
	@rmdir $(datarootdir)/$(name)/figures
	@echo "done."

