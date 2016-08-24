# +----------------------------------------------------------------------------+
# | C3 v0.6 * Colour code of components                                        |
# | Copyright (C) 2004-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for manuals                                                       |
# +----------------------------------------------------------------------------+

include ../Makefile.global

languages = en hu

all:

clean:

install:
	@echo -n "- Installing manual files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.7 ]; \
	  then \
	    $(install) -d $(mandir)/$$x/man7; \
	    $(install) -m $(txtmode) $(name)_$$x.7 $(mandir)/$$x/man7; \
	    mv $(mandir)/$$x/man7/$(name)_$$x.7 $(mandir)/$$x/man7/$(name).7 ; \
	  fi; \
	done
	@$(install) -d $(mandir)/man7;
	@mv $(mandir)/en/man7/* $(mandir)/man7
	@rmdir $(mandir)/en/man7/
	@rmdir $(mandir)/en
	@echo "done."

uninstall:
	@echo -n "- Removing manual files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.7 ]; \
	  then \
	    $(rm) $(mandir)/$$x/man7/$(name).7; \
	  fi; \
	done
	@$(rm) $(mandir)/man7/$(name).7;
	@echo "done."

