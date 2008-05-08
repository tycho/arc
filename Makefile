all:
	$(MAKE) -C contrib/CrissCross
#	$(MAKE) -C contrib/CrissCross test
	$(MAKE) -f source/Makefile

clean:
	$(MAKE) -C contrib/CrissCross clean
	$(MAKE) -f source/Makefile clean

contrib:
	$(MAKE) -C contrib/CrissCross
