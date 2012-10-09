openFrameworks_0.071_debian_package
===================================

Attemp to make a debian package for OpenFrameworks v0.071

WARNING! It is still under development. Use it under your own responsability (well... it applies also when the package works :-P)

If you want to test it, you can follow the next steps:

1. git clone the sources
2. make the source (cd openframeworks-0.071 ; dpkg-buildpackage -rfakeroot -uc)
3. if the packages are made, install them (cd .. ; sudo dpkg -i libopenframeworks0071_0.071-1.1_i386.deb libopenframeworks0071-dbg_0.071-1.1_i386.deb openframeworks-dev_0.071-1.1_i386.deb )
4. there is a script in openframeworks-0.071/debian/scripts/ called test-with-Makefile.sh that enters in each example src directory, creates a new Makefile for these packages, compile the app and starts it.

So far, some of the examples doesn't work for me for any reason. These are:
./examples/gl/geometryShaderExample/
./examples/gl/GPUparticleSystemExample
./examples/3d/modelNoiseExample
./examples/video/asciiVideo
./examples/addons/oscChatSystemExample
./examples/addons/assimpExample
./examples/addons/allAddonsExample
./examples/sound/audioOutputExample
./examples/sound/soundPlayerExample

You can find the packages compiled in the downloads section, as well as the original source code of OF.

There are still some things that should be commented here before start with the development. I'll try to update this README as soon as possible.
 
