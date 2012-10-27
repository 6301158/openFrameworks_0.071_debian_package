LIBRARY = libopenframeworks-assimpmodelloader
include common.make
PKGCONFIG_LIST=openframeworks assimp
EXTRA_CFLAGS= $$(pkg-config $(PKGCONFIG_LIST) --cflags) -Isrc -Ilibs/assimp/include/
HEADERS = ofx3DBaseLoader.h ofxAssimpMeshHelper.h ofxAssimpModelLoader.h \
			assimp.h aiScene.h aiTypes.h Compiler/poppack1.h \
			Compiler/pushpack1.h aiAnim.h aiAssert.h aiCamera.h aiColor4D.h \
			aiColor4D.inl aiConfig.h aiDefines.h aiFileIO.h aiLight.h \
			aiMaterial.h aiMaterial.inl aiMatrix3x3.h aiMatrix3x3.inl \
			aiMatrix4x4.h aiMatrix4x4.inl aiMesh.h aiPostProcess.h \
			aiQuaternion.h aiScene.h aiTexture.h aiTypes.h aiVector2D.h \
			aiVector3D.h aiVector3D.inl aiVersion.h assimp.hpp DefaultLogger.h \
			IOStream.h IOSystem.h Logger.h LogStream.h NullLogger.h \
			ProgressHandler.h
