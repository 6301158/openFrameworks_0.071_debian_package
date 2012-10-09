PROG=particles

all: $(PROG)

SOURCES = $(shell find . -name "*.cpp")
OBJS = $(SOURCES:.cpp=.o)

PKGCONFIG_LIST = openframeworks openframeworks-addons

CFLAGS = -O2 -g -Wall
LDFLAGS = -Wl,-z,defs -Wl,--as-needed -Wl,--no-undefined
LIBS = $$(pkg-config $(PKGCONFIG_LIST) --libs)

EXTRA_CFLAGS = $$(pkg-config $(PKGCONFIG_LIST) --cflags)

$(PROG): $(OBJS)
	g++ -o $@ $(LDFLAGS) $(OBJS) $(LIBS)

%.o: %.cpp
	g++ -o $@ -c $+ $(CFLAGS) $(EXTRA_CFLAGS)

clean:
	rm -f $(PROG) *.o *~
