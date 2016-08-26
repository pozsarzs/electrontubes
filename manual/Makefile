# +----------------------------------------------------------------------------+
# | Electrontubes v0.4.1 * Electrontube bias calculator                        |
# | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
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
	  if [ -e $(name)_$$x.1 ]; \
	  then \
	    $(install) -d $(mandir)/$$x/man1; \
	    $(install) -m $(txtmode) $(name)_$$x.1 $(mandir)/$$x/man1; \
	    mv $(mandir)/$$x/man1/$(name)_$$x.1 $(mandir)/$$x/man1/$(name).1 ; \
	  fi; \
	done
	@$(install) -d $(mandir)/man1;
	@mv $(mandir)/en/man1/* $(mandir)/man1
	@rmdir $(mandir)/en/man1/
	@rmdir $(mandir)/en
	@echo "done."

uninstall:
	@echo -n "- Removing manual files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.1 ]; \
	  then \
	    $(rm) $(mandir)/$$x/man1/$(name).1; \
	  fi; \
	done
	@$(rm) $(mandir)/man1/$(name).1;
	@echo "done."

