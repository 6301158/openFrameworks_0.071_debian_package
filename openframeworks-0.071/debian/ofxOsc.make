LIBRARY = libopenframeworks-osc
include common.make
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc
HEADERS = ofxOsc.h ofxOscArg.h ofxOscBundle.h ofxOscMessage.h \
			ofxOscReceiver.h ofxOscSender.h
