LIBRARY=libopenFrameworks

DESTDIR=
OF_LIBS=assimp cairo fmodex FreeImage freetype glew kiss poco portaudio \
        rtAudio tess2

#install: $(LIBRARY).a $(LIBRARY).so
install: $(LIBRARY).a
	mkdir -p "$(DESTDIR)/usr/lib/"
	cp -a *.a "$(DESTDIR)/usr/lib/"
#	cp -a *.so* "$(DESTDIR)/usr/lib/"

	#cd $(CURDIR)/../../../../libs/openFrameworks
	mkdir -p "$(DESTDIR)/usr/include/openFrameworks/"
	echo ----------------------
	#pwd
	#find ../../../../libs/openFrameworks -name "*.h"
	find ../../../../libs/openFrameworks -name "*.h" | \
		while read f; \
		do \
			cp "$$f" "$(DESTDIR)/usr/include/openFrameworks/"; \
			echo cp "$$f" "$(DESTDIR)/usr/include/openFrameworks/" ; \
		done
	echo ----------------------
	echo "Installing other libraries:"
	
	for a in $(OF_LIBS) ;\
	do \
		echo "Installing $a..." ;\
		find ../../../../libs/$a -name "*.h" | \
		while read f; \
		do \
			cp "$$f" "$(DESTDIR)/usr/include/openFrameworks/"; \
			echo cp "$$f" "$(DESTDIR)/usr/include/openFrameworks/" ; \
		done ;\
		find ../../../../libs/$a -name "*.a" | \
		while read f; \
		do \
			cp "$$f" "$(DESTDIR)/usr/lib/"; \
			echo cp "$$f" "$(DESTDIR)/usr/lib/" ; \
		done ;\
		find ../../../../libs/$a -name "*.so" | \
		while read f; \
		do \
			cp "$$f" "$(DESTDIR)/usr/lib/"; \
			echo cp "$$f" "$(DESTDIR)/usr/lib/" ; \
		done ;\
	done

