TEMPLATE	= app
LANGUAGE	= C++
CONFIG		+= qt opengl
QT			+= opengl
INCLUDEPATH =	../../include 
LIBS		+= -ldl

HEADERS 	=	SignalGenerator.h \
				DeckLinkDeviceDiscovery.h \
				DeckLinkOutputDevice.h

SOURCES 	= 	main.cpp \
				../../include/DeckLinkAPIDispatch.cpp \
				DeckLinkDeviceDiscovery.cpp \
				DeckLinkOutputDevice.cpp \
            	SignalGenerator.cpp

FORMS 		= 	SignalGenerator.ui

