all:
	$(MAKE) -C contrib/crisscross
#	$(MAKE) -C contrib/crisscross test
	$(MAKE) -f source/Makefile

clean:
	$(MAKE) -f source/Makefile clean

distclean: clean
	$(MAKE) -C contrib/crisscross clean

contrib:
	$(MAKE) -C contrib/crisscross
