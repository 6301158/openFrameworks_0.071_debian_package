LIBRARY = libopenframeworks-opencv
include common.make
PKGCONFIG_LIST=openframeworks opencv
SOURCES = $(shell find src -name '*.cpp' -o -name '*.cc' 2>/dev/null)
HEADERS = ofxCvBlob.h ofxCvColorImage.h ofxCvConstants.h ofxCvContourFinder.h \
			ofxCvFloatImage.h ofxCvGrayscaleImage.h ofxCvHaarFinder.h \
			ofxCvImage.h ofxCvMain.h ofxCvShortImage.h ofxOpenCv.h

