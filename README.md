openFrameworks_0.071_debian_package
===================================

Attemp to make a debian package for OpenFrameworks v0.071 (so far, 32 bit)

WARNING! It is still under development. Use it under your own responsability (well... it applies also when the package works :-P)

So far, some of the examples doesn't work for me for any reason. Information about this can be found in the wiki:
https://github.com/punkto/openFrameworks_0.071_debian_package/wiki/examples-compilation-status

You can find the actual lintian output here: https://github.com/punkto/openFrameworks_0.071_debian_package/wiki/lintian-output

You can find the packages compiled in the downloads section, as well as the original source code of OF.

How to test the packages.
========================

1\. First, get a brand new Debian testing/unstable installation.

Now, you have to download the sources.

If you want to use git, you can get the source code  using git and ask for the original source code

<pre><code>
$ git clone git://github.com/punkto/openFrameworks_0.071_debian_package.git
$ cd openframeworks-0.071
openframeworks-0.071$ dpkg-buildpackage -Tget-orig-source
</code></pre>

Alternatively, go to the “downloads” section and download the full package:

<pre><code>
$ wget https://github.com/downloads/punkto/openFrameworks_0.071_debian_package/openframeworks_0.071-1.1_i386_2012_10_13.tar.gz
$ tar -xf openframeworks_0.071-1.1_i386_2012_10_13.tar.gz
$ ls *openframeworks*
libopenframeworks0071_0.071-1.1_i386.deb      openframeworks_0.071-1.1.dsc                     openframeworks_0.071-1.1_i386.changes
libopenframeworks0071-dbg_0.071-1.1_i386.deb  openframeworks_0.071-1.1_i386_2012_10_13.tar.gz  openframeworks_0.071.orig.tar.gz
openframeworks_0.071-1.1.debian.tar.gz        openframeworks_0.071-1.1_i386.build              openframeworks-dev_0.071-1.1_i386.deb
</code></pre>

In this case, you’ll need to expand the source code:

<pre><code>
$ dpkg-source -x openframeworks_0.071-1.1.dsc
</code></pre>

2\. In order to know the necessary packages for the compilation, you can ask for the unsatisfied dependences in this way:

<pre><code>
$ cd openframeworks-0.071/
openframeworks-0.071$ dpkg-checkbuilddeps
dpkg-checkbuilddeps: Dependencias de construcción no satisfechas: debhelper (>= 8.0.0) dh-buildinfo quilt pkg-config libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libudev-dev libfreetype6-dev libavcodec-dev libavformat-dev libavutil-dev libunicap2-dev libfreeimage-dev libpoco-dev libswscale-dev freeglut3-dev libglu1-mesa-dev libgl1-mesa-dev glee-dev libxmu-dev libxxf86vm-dev libraw1394-dev libcv-dev libopencv-dev libopenal-dev libsndfile1-dev libjack-dev libglew1.5-dev libasound2-dev libassimp-dev
</code></pre>

3\. And install all required packages. Remember to install devscripts too:

<pre><code>
# apt-get install build-essential debhelper devscripts  dh-buildinfo quilt pkg-config libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libudev-dev libfreetype6-dev libavcodec-dev libavformat-dev libavutil-dev libunicap2-dev libfreeimage-dev libpoco-dev libswscale-dev freeglut3-dev libglu1-mesa-dev libgl1-mesa-dev glee-dev libxmu-dev libxxf86vm-dev libraw1394-dev libcv-dev libopencv-dev libopenal-dev libsndfile1-dev libjack-dev libglew1.5-dev libasound2-dev libassimp-dev
</code></pre>

4\. You are ready for compiling:

<pre><code>
openframeworks-0.071$ debuild -us -uc
</code></pre>

Waiting...

This is a good time to visit some good references about package developing in Debian:

SourcePackage - Debian Wiki
http://wiki.debian.org/SourcePackage

Chapter 6. Building the package
http://www.debian.org/doc/manuals/maint-guide/build.en.html#debuild

waiting...

If everything has been OK, the last lines you’ll see are lintian warnings and errors that must be addressed in order to get a correct Debian package. This lines are like these:

<pre><code>
E: openframeworks-dev: helper-templates-in-copyright
W: openframeworks-dev: copyright-has-url-from-dh_make-boilerplate
E: openframeworks-dev: copyright-contains-dh_make-todo-boilerplate
W: openframeworks-dev: readme-debian-contains-debmake-template
W: openframeworks-dev: superfluous-clutter-in-homepage <insert the upstream URL, if relevant>
W: openframeworks-dev: bad-homepage <insert the upstream URL, if relevant>
Finished running lintian.
</code></pre>

5\. Now it’s time to install the packages:

<pre><code>
openframeworks-0.071$ ls ../*openframeworks*.deb
../libopenframeworks0071_0.071-1.1_i386.deb  ../libopenframeworks0071-dbg_0.071-1.1_i386.deb  ../openframeworks-dev_0.071-1.1_i386.deb
$ su
openframeworks-0.071# cd ..
# dpkg -i *openframeworks*.deb
Selecting previously unselected package libopenframeworks0071.
(Leyendo la base de datos ... 169982 ficheros o directorios instalados actualmente.)
Desempaquetando libopenframeworks0071 (de libopenframeworks0071_0.071-1.1_i386.deb) ...
Selecting previously unselected package libopenframeworks0071-dbg.
Desempaquetando libopenframeworks0071-dbg (de libopenframeworks0071-dbg_0.071-1.1_i386.deb) ...
Selecting previously unselected package openframeworks-dev.
Desempaquetando openframeworks-dev (de openframeworks-dev_0.071-1.1_i386.deb) ...
Configurando libopenframeworks0071 (0.071-1.1) ...
Configurando libopenframeworks0071-dbg (0.071-1.1) ...
Configurando openframeworks-dev (0.071-1.1) …
# exit
</code></pre>

6\. We can make the examples shipped with OF using a script that, for every applications in the directories “examples” and “apps”

- writes a new Makefile in the “src” directory (so the original Makefiles are no modified)
- makes the app
- executes the app
- performs a “make clean”
- deletes the Makefile

<pre><code>
openframeworks-0.071$ cd debian/scripts/
openframeworks-0.071/debian/scripts$ ./test-with-Makefile.sh
-----------------------------------------------------------------
building example in  + ./examples/utils/conversionExample/src
g++ -o main.o -c main.cpp -O2 -g -Wall $(pkg-config openframeworks openframeworks-addons --cflags)
g++ -o testApp.o -c testApp.cpp -O2 -g -Wall $(pkg-config openframeworks openframeworks-addons --cflags)
mkdir -p ../bin
g++ -o ../bin/app -Wl,-z,defs -Wl,--as-needed -Wl,--no-undefined ./main.o ./testApp.o $(pkg-config openframeworks openframeworks-addons --libs)

[...]
</code></pre>

