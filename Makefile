all: build

clean:
	$(MAKE) -C source clean

distclean: clean
	$(MAKE) -C source distclean

build:
	$(MAKE) -C source
