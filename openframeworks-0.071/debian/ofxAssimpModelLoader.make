LIBRARY = libopenframeworks-assimpmodelloader
include common.make
PKGCONFIG_LIST=openframeworks assimp
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc -Ilibs/assimp/include/
