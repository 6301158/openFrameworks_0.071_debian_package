LIBRARY=libopenframeworks
OFDIR=./

all: $(LIBRARY).a $(LIBRARY).so

MAJOR=0071
MINOR=0

SOURCES = $(shell find . -name "*.cpp")

SHARED_OBJS = $(SOURCES:.cpp=.shared.o)
STATIC_OBJS = $(SOURCES:.cpp=.static.o)

OF_HEADERS = $(shell awk '/include/ {print}' ./ofMain.h | sed 's/"//g' | sed 's/\#include//')
OTHER_HEADERS = tesselator.h ofVec3f.h ofVec2f.h ofVec4f.h ofEventUtils.h \
				ofMain.h ofMatrix3x3.h ofMatrix4x4.h ofQuaternion.h \
				cairo-features.h cairo-pdf.h cairo.h cairo-version.h \
				cairo-deprecated.h cairo-svg.h ofBaseSoundStream.h \
				ofPASoundStream.h ofBaseSoundPlayer.h ofOpenALSoundPlayer.h \
				kiss_fft.h kiss_fftr.h ofGstVideoGrabber.h ofGstUtils.h \
				ofGstVideoPlayer.h ofAppGlutWindow.h ofAppBaseWindow.h

PKGCONFIG_LIST=gstreamer-0.10 freetype2 gstreamer-app-0.10 gstreamer-video-0.10 \
	libavcodec libavutil glee libudev glew gtk+-2.0 openal jack zlib

EXTRA_CFLAGS=-I$(OFDIR)/../FreeImage/include -I$(OFDIR)/../assimp/include \
	-I$(OFDIR)/../assimp/include/Compiler -I$(OFDIR)/../cairo/include \
	-I$(OFDIR)/../cairo/include/pixman-1 -I$(OFDIR)/../cairo/include/libpng15 \
	-I$(OFDIR)/../cairo/include/cairo \
	-I$(OFDIR)/../freetype/include -I$(OFDIR)/../freetype/include/freetype2 \
	-I$(OFDIR)/../freetype/include/freetype2/freetype \
	-I$(OFDIR)/../freetype/include/freetype2/freetype/internal \
	-I$(OFDIR)/../freetype/include/freetype2/freetype/internal/services \
	-I$(OFDIR)/../freetype/include/freetype2/freetype/config \
	-I$(OFDIR)/../glew/include -I$(OFDIR)/../glew/include/GL \
	-I$(OFDIR)/../kiss/include -I$(OFDIR)/../portaudio/include \
	-I$(OFDIR)/../rtAudio/include -I$(OFDIR)/../tess2/include \
	-I$/usr/include/Poco -I$(OFDIR)/../glu/include -I$(OFDIR)/ \
	-I$(OFDIR)/communication -I$(OFDIR)/math -I$(OFDIR)/gl -I$(OFDIR)/utils \
	-I$(OFDIR)/3d -I$(OFDIR)/video -I$(OFDIR)/types -I$(OFDIR)/graphics \
	-I$(OFDIR)/app -I$(OFDIR)/sound -I$(OFDIR)/events -pthread \
	-I/usr/include/gstreamer-0.10 -I/usr/include/glib-2.0 \
	-I/usr/lib/i386-linux-gnu/glib-2.0/include \
	-I/usr/include/libxml2 -pthread -I/usr/include/gtk-2.0 \
	-I/usr/lib/i386-linux-gnu/gtk-2.0/include -I/usr/include/atk-1.0 \
	-I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 \
	-I/usr/include/pango-1.0 -I/usr/include/gio-unix-2.0/ \
	-I/usr/include/glib-2.0 -I/usr/lib/i386-linux-gnu/glib-2.0/include \
	-I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng12 \
	-DOF_USING_GTK  $$(pkg-config $(PKGCONFIG_LIST) --cflags)

STATIC_CFLAGS= -O2 -g -Wall $(EXTRA_CFLAGS)
SHARED_CFLAGS= $(STATIC_CFLAGS) -fPIC

LDFLAGS= -Wl,-z,defs -Wl,--as-needed -Wl,--no-undefined
EXTRA_LDFLAGS=
LIBS= \
	-lunicap -lfreeimage -lPocoNet -lPocoUtil -lPocoFoundation -lswscale \
	-lglut -lGLU -lGL -lglee -lopenal -lasound -lsndfile -lvorbis -lFLAC -logg \
	-loscpack -L../../debian/tmp/usr/lib/  \
	$$(pkg-config $(PKGCONFIG_LIST) --libs)

DESTDIR=./debian/tmp
EXTRA_LIBS=$(OFDIR)/../kiss/lib/linux/libkiss.a \
	$(OFDIR)/../tess2/lib/linux/libtess2.a \
	$(OFDIR)/../portaudio/lib/linux/libportaudio.a

$(LIBRARY).so.$(MAJOR).$(MINOR): $(SHARED_OBJS)
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ $(LDFLAGS) $(EXTRA_LDFLAGS) -shared \
		-Wl,-soname,$(LIBRARY).so.$(MAJOR) \
		-o $(LIBRARY).so.$(MAJOR).$(MINOR) \
		$+ -o $@ $(EXTRA_LIBS) $(LIBS)

$(LIBRARY).so: $(LIBRARY).so.$(MAJOR).$(MINOR)
	rm -f $@.$(MAJOR)
	ln -s $@.$(MAJOR).$(MINOR) $@.$(MAJOR)
	rm -f $@
	ln -s $@.$(MAJOR) $@

$(LIBRARY).a: $(STATIC_OBJS)
	ar cru $@ $+

%.shared.o: %.cpp
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ -o $@ -c $+ $(SHARED_CFLAGS)

%.shared.o: %.c
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	gcc -o $@ -c $+ $(SHARED_CFLAGS)

%.so : %.o
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ $(LDFLAGS) $(EXTRA_LDFLAGS) -shared $^ -o $@

%.static.o: %.cpp
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ -o $@ -c $+ $(STATIC_CFLAGS)

%.static.o: %.c
	export PKG_CONFIG_PATH=debian/pkgconfig:$$PKG_CONFIG_PATH; \
	gcc -o $@ -c $+ $(STATIC_CFLAGS)

clean:
	rm -f $(STATIC_OBJS) $(SHARED_OBJS)
	rm -f *.so *.so* *.a
	find . -name "*.o" -exec rm -f {} \;

install: $(LIBRARY).a $(LIBRARY).so
	mkdir -p "$(DESTDIR)/usr/lib/"
	cp -a *.a "$(DESTDIR)/usr/lib/"
	cp -a *.so* "$(DESTDIR)/usr/lib/"

	echo $(OF_HEADERS)

	mkdir -p "$(DESTDIR)/usr/include/openFrameworks/"
	for file in $(OF_HEADERS); do \
		find . -name $$file  | \
		xargs -I {} cp {} "$(DESTDIR)/usr/include/openFrameworks/"; \
	done

	echo "Installing other headers:"
	for file in $(OTHER_HEADERS); do \
		find .. -name $$file  | \
		xargs -I {} cp {} "$(DESTDIR)/usr/include/openFrameworks/"; \
	done
