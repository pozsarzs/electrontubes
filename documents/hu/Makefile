# +----------------------------------------------------------------------------+
# | Electrontubes v0.4.1 * Electrontube bias calculator [ CheapApps series ]   |
# | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | C3 v0.6 * Colour code of components                                        |
# | Copyright (C) 2004-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for documents                                                     |
# +----------------------------------------------------------------------------+

include ../../Makefile.global

docfiles= `ls | grep -v Makefile | grep -v ??`
lang=hu

all:

clean:

install:
	@echo -n "- Installing document files..."
	@$(install) -d $(datarootdir)/doc/$(name)/$(lang)
	@for x in $(docfiles); do \
	  if [ -e $$x ]; then $(install) -m $(txtmode) $$x $(datarootdir)/doc/$(name)/$(lang); fi; \
	done
	@echo "done."

uninstall:
	@echo -n "- Removing document files..."
	@for x in $(docfiles); do \
	  if [ -e $$x ]; then $(rm) $(datarootdir)/doc/$(name)/$(lang)/$$x; fi; \
	done
	@rmdir $(datarootdir)/doc/$(name)/$(lang)
	@echo "done."

