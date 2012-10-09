#!/bin/bash
# Copyright 2012, Jorge Muñoz <punkto@gmail.com>
# Licensed under the same license as the rest of the package.

# This script writes a new Makefile for each OpenFrameworks example in its src
# file. It also tries to compile and launch it (this only will work if the
# package is compiled and installed)

cd ../../
CURDIR=$(pwd)

DIR_EXAMPLES=$(find ./examples -name "src")
DIR_APPS=$(find ./apps -name "src")

export LC_ALL=C

for dir in $DIR_EXAMPLES $DIR_APPS
do 
	cd $dir
	echo "-----------------------------------------------------------------"
	echo "building example in " + $dir
	cat > Makefile << EOF
PROG=app

all: \$(PROG)

SOURCES = \$(shell find . -name "*.cpp")
OBJS = \$(SOURCES:.cpp=.o)

PKGCONFIG_LIST = openframeworks openframeworks-addons

CFLAGS = -O2 -g -Wall
LDFLAGS = -Wl,-z,defs -Wl,--as-needed -Wl,--no-undefined
LIBS = \$\$(pkg-config \$(PKGCONFIG_LIST) --libs)

EXTRA_CFLAGS = \$\$(pkg-config \$(PKGCONFIG_LIST) --cflags)

\$(PROG): \$(OBJS)
	mkdir -p ../bin
	g++ -o ../bin/\$@ \$(LDFLAGS) \$(OBJS) \$(LIBS)

%.o: %.cpp
	g++ -o \$@ -c \$+ \$(CFLAGS) \$(EXTRA_CFLAGS)

clean:
	rm -f ../bin/\$(PROG) *.o *~

EOF

	make
	cd ../bin
	./app
	cd ../src
	make clean
	rm Makefile
	cd $CURDIR
done

