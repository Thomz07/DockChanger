ARCHS = arm64 arm64e

TARGET = ::11.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DockChanger

DockChanger_FILES = Tweak.xm 
DockChanger_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dockchanger
include $(THEOS_MAKE_PATH)/aggregate.mk
