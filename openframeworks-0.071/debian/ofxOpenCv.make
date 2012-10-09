LIBRARY = libopenframeworks-opencv
include common.make
PKGCONFIG_LIST=openframeworks opencv
SOURCES = $(shell find src -name '*.cpp' -o -name '*.cc' 2>/dev/null)
HEADERS = $(shell find src -name '*.h' -o -name '*.hpp' 2>/dev/null)

