# +----------------------------------------------------------------------------+
# | Electrontubes v0.3.1 * Electrontube bias calculator [ CheapApps series ]   |
# | Copyright (C) 2012 Pozsar Zsolt <pozsarzs@gmail.com>                       |
# | C3 v0.6 * Colour code of components                                        |
# | Copyright (C) 2004-2016 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =	desktop documents/hu documents languages manual source
srcdirs = source

all:
	@echo Compiling $(name):
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo Cleaning source code:
	@for dir in $(srcdirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@echo "Source code is cleaned."

install:
	@echo Installing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Application is installed."

uninstall:
	@echo Removing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir uninstall; fi; \
	done
	@echo "Application is removed."
