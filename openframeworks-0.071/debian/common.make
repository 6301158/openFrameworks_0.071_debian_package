all: $(LIBRARY).a $(LIBRARY).so

SOURCES = $(shell find src libs -name '*.cpp' -o -name '*.cc' 2>/dev/null)
#HEADERS = $(shell find src libs -name '*.h' -o -name '*.hpp' 2>/dev/null)

MAJOR=0071
MINOR=0

SHARED_OBJS = $(SOURCES:.cpp=.shared.o)
STATIC_OBJS = $(SOURCES:.cpp=.static.o)

PKGCONFIG_LIST=openframeworks

EXTRA_CFLAGS = $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Ilibs

STATIC_CFLAGS = -O2 -g -Wall $(EXTRA_CFLAGS) -I../../debian/tmp/usr/include/openFrameworks
SHARED_CFLAGS = $(STATIC_CFLAGS) -fPIC

LDFLAGS= -Wl,-z,defs -Wl,--as-needed -Wl,--no-undefined
EXTRA_LDFLAGS=

LIBS= 
EXTRA_LIBS= $$(pkg-config $(PKGCONFIG_LIST) --libs) -Llibs

$(LIBRARY).so.$(MAJOR).$(MINOR): $(SHARED_OBJS)
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ $(LDFLAGS) $(EXTRA_LDFLAGS) -shared \
		-Wl,-soname,$(LIBRARY).so.$(MAJOR) \
		-o $(LIBRARY).so.$(MAJOR).$(MINOR) \
		$+ -o $@ $(EXTRA_LIBS) $(LIBS) -L../../debian/tmp/usr/lib

$(LIBRARY).so: $(LIBRARY).so.$(MAJOR).$(MINOR)
	rm -f $@.$(MAJOR)
	ln -s $@.$(MAJOR).$(MINOR) $@.$(MAJOR)
	rm -f $@
	ln -s $@.$(MAJOR) $@

$(LIBRARY).a: $(STATIC_OBJS)
	ar cru $@ $+

%.shared.o: %.cpp
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ -o $@ -c $+ $(SHARED_CFLAGS)

%.shared.o: %.c
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	gcc -o $@ -c $+ $(SHARED_CFLAGS)

%.so : %.o
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ $(LDFLAGS) $(EXTRA_LDFLAGS) -shared $^ -o $@

%.static.o: %.cpp
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	g++ -o $@ -c $+ $(STATIC_CFLAGS)

%.static.o: %.c
	export PKG_CONFIG_PATH=../../debian/pkgconfig:$$PKG_CONFIG_PATH; \
	gcc -o $@ -c $+ $(STATIC_CFLAGS)

clean:
	rm -f $(STATIC_OBJS) $(SHARED_OBJS)
	rm -f *.so *.so* *.a

DESTDIR=./debian/tmp

install: $(LIBRARY).a $(LIBRARY).so
	mkdir -p "$(DESTDIR)/usr/lib/"
	cp -a *.a "$(DESTDIR)/usr/lib/"
	cp -a *.so* "$(DESTDIR)/usr/lib/"

	mkdir -p "$(DESTDIR)/usr/include/openFrameworks/"
	#cp $(HEADERS) "$(DESTDIR)/usr/include/openFrameworks/"
	for file in $(HEADERS); do \
		find . -name $$file  | \
		xargs -I {} cp {} "$(DESTDIR)/usr/include/openFrameworks/"; \
	done

