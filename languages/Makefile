# +----------------------------------------------------------------------------+
# | C3 v0.6 * Colour code of components                                        |
# | Copyright (C) 2004-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for message files                                                 |
# +----------------------------------------------------------------------------+

include ../Makefile.global

languages = hu

all:

clean:

install:
	@echo -n "- Installing message files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.mo ]; \
	  then \
	    $(install) -d $(localedir)/$$x/LC_MESSAGES; \
	    $(install) -m $(txtmode) $(name)_$$x.mo $(localedir)/$$x/LC_MESSAGES; \
	    mv $(localedir)/$$x/LC_MESSAGES/$(name)_$$x.mo $(localedir)/$$x/LC_MESSAGES/$(name).mo ; \
	  fi; \
	done
	@echo "done."

uninstall:
	@echo -n "- Removing message files..."
	@for x in $(languages); do \
	  if [ -e $(name)_$$x.mo ]; \
	  then \
	    $(rm) $(localedir)/$$x/LC_MESSAGES/$(name).mo; \
	  fi; \
	done
	@echo "done."

