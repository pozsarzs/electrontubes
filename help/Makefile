# +----------------------------------------------------------------------------+
# | Electrontubes v0.4.1 * Electrontube bias calculator                        |
# | Copyright (C) 2012-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for help files                                                    |
# +----------------------------------------------------------------------------+

include ../Makefile.global

dirs=`ls -d module_*`

all:

clean:

install:
	@echo -n "- Installing help files..."
	@$(install) -d $(datarootdir)/$(name)/help/
	@for dir in $(dirs); do \
	  $(install) -d $(datarootdir)/$(name)/help/$$dir; \
	  $(install) -m $(txtmode) $$dir/* $(datarootdir)/$(name)/help/$$dir/; \
	done
	@$(install) -m $(txtmode) *.html $(datarootdir)/$(name)/help/
	@$(install) -m $(txtmode) *.css $(datarootdir)/$(name)/help/
	@echo "done."

uninstall:
	@echo -n "- Removing help files..."
	@for dir in $(dirs); do \
	  $(rm) $(datarootdir)/$(name)/help/$$dir/*; \
	  rmdir $(datarootdir)/$(name)/help/$$dir; \
	done
	@$(rm) $(datarootdir)/$(name)/help/*.html
	@$(rm) $(datarootdir)/$(name)/help/*.css
	@rmdir $(datarootdir)/$(name)/help/
	@rmdir $(datarootdir)/$(name)/
	@echo "done."
