LIBRARY = libopenframeworks-3dmodelloader
include common.make
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc -Isrc/3DS/
HEADERS = ofx3DModelLoader.h ofx3DBaseLoader.h model3DS.h texture3DS.h \
			Vector3DS.h
