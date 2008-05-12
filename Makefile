all:
	$(MAKE) -C contrib/CrissCross
#	$(MAKE) -C contrib/CrissCross test
	$(MAKE) -f source/Makefile

clean:
	$(MAKE) -f source/Makefile clean

distclean: clean
	$(MAKE) -C contrib/CrissCross clean

contrib:
	$(MAKE) -C contrib/CrissCross
