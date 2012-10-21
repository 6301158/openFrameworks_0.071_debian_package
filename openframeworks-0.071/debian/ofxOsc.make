LIBRARY = libopenframeworks-osc
include common.make
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc

