TEMPLATE  	= app
LANGUAGE  	= C++
CONFIG		+= qt opengl
QT			+= opengl
INCLUDEPATH =	../../include ../NVIDIA_GPUDirect/include
LIBS		+= -lGLU -ldl -ldvp -L../NVIDIA_GPUDirect/i386 -L../NVIDIA_GPUDirect/x86_64 -Wl,-rpath=.:../NVIDIA_GPUDirect/i386:../NVIDIA_GPUDirect/x86_64

HEADERS 	=	../../include/DeckLinkAPIDispatch.cpp \
				LoopThroughWithOpenGLCompositing.h \
				OpenGLComposite.h \
				GLExtensions.h \
				VideoFrameTransfer.h

SOURCES 	= 	main.cpp \
				../../include/DeckLinkAPIDispatch.cpp \
				LoopThroughWithOpenGLCompositing.cpp \
				OpenGLComposite.cpp \
				GLExtensions.cpp \
				VideoFrameTransfer.cpp

FORMS 		= 	LoopThroughWithOpenGLCompositing.ui
