LIBRARY = libopenframeworks-3dmodelloader
include common.make
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc -Isrc/3DS/
