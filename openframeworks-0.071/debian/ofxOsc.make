LIBRARY = libopenframeworks-osc
include common.make
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc -Ilibs/oscpack/src/osc -Ilibs/oscpack/src -Ilibs/oscpack/src/ip

