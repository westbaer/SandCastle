TWEAK_NAME = sandcastle
sandcastle_LOGOS_FILES = Tweak.xm
sandcastle_PRIVATE_FRAMEWORKS = AppSupport
sandcastle_CFLAGS=-I.

SUBPROJECTS = client

client_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include framework/makefiles/common.mk
include framework/makefiles/aggregate.mk
include framework/makefiles/tweak.mk
