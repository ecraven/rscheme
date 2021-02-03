##  compiler/resource/buildenv/postambl.mak
##
##    [source]/resource/buildenv/postambl.mak
##
## this is the hand-coded portion of $DIST/Makefile
##

TARGET=install/lib/librs.a

$(TARGET) base: $(SUBPROJ)
	$(RANLIB) $(TARGET)
	cp -f platform/aix/rs.exp install/lib/rs.exp

all:: base install-base shell install-shell

install-base::
	if [ ! -d $(INSTALL_DIR) ] ; then mkdir -p $(INSTALL_DIR) ; fi
	(cd install ; \
	 find . \! \( -name CVS -prune \) -print) > .install.list
	cat .install.list | (cd install ; cpio -oc) \
			  | (cd ${INSTALL_DIR} ; cpio -idc)

clean::
	for i in $(SUBDIRS) ; do (cd $$i && $(MAKE) clean) ; done
	cd rshell && $(MAKE) INSTALL_DIR=$(INSTALL_DIR) clean
	rm -f $(TARGET)

#########################################################################
#
#  The base RScheme shell application
#  (a thin layer that simply provides access to the repl module's
#  Read-Eval-Print loop)
#

shell:: rshell/rs system.img

install-shell:: $(INSTALL_DIR)/resource/system.img \
	  $(INSTALL_DIR)/bin/rs

rshell/rs:: $(INSTALL_DIR)/resource/buildenv/preamble.mak \
	 $(INSTALL_DIR)/lib/librs.a
	cd rshell ; $(MAKE) INSTALL_DIR=$(INSTALL_DIR) \
			    FINAL_INSTALL_DIR=$(FINAL_INSTALL_DIR)

$(INSTALL_DIR)/resource/system.img: system.img
	cp -p system.img $(INSTALL_DIR)/resource

$(INSTALL_DIR)/bin/rs: rshell/rs
	cd rshell ; $(MAKE) INSTALL_DIR=$(INSTALL_DIR) install

#
#  patch the base shell's boot image
#

system.img: tmp/system.bas
	rshell/rs -image tmp/system.bas -c.repl system.img

#########################################################################
#
#  some fasl things
#  (can only run these after installation is complete)
#
# my usual personal selection...
#  SHELL_MODULES=syscalls unixm rstore calendar sets threads fasl debugger

SHELL_MODULES=all

fasl_shell::
	@if test -z "$(SHELL_MODULES)" ; then echo SHELL_MODULES: not set ; \
	 exit 1 ; fi
	INSTALL_DIR=$(INSTALL_DIR) sh pkg/fasl/mkfasl fshell $(SHELL_MODULES)
	cd fshell ; $(MAKE) INSTALL_DIR=$(INSTALL_DIR)
	cd fshell ; $(MAKE) INSTALL_DIR=$(INSTALL_DIR) install

RSC=$(INSTALL_DIR)/bin/rsc

pkg/modules:
	if test -x /bin/mkdirs ; \
	then /bin/mkdirs pkg/modules ;\
	else mkdir -p pkg/modules ; \
	fi

PACKAGES=@default_pkgs@

packages::
	for i in $(PACKAGES) ; \
	do if $(MAKE) PACKAGE=$$i package ; \
	   then : ; \
	   else exit 1 ; \
	   fi ; \
	done

package:: pkg/modules $(RSC)
	cd .. ; packages/pkg-bld $(INSTALL_DIR) $(PACKAGE)

#
#  the module compiler, running from WITHIN this build
#

$(RSC):
	$(MAKE) rsc

include preamble.mak

rsc::
	RS=$(INSTALL_DIR)/bin/rs ../compiler/mkcfg \
		$(INSTALL_DIR) > tmp/cfg2.scm
	RS=$(INSTALL_DIR)/bin/rs ../compiler/mkrsc \
		../compiler \
		$(INSTALL_DIR)/bin \
		$(INSTALL_DIR)/resource/compiler \
		$(INSTALL_DIR) \
		tmp/cfg2.scm
	echo $(CFLAGS) > $(INSTALL_DIR)/resource/compiler/cflags

##
##  this is the end of the hand-coded portion of $DIST/Makefile
##
