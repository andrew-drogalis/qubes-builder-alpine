ifneq (,$(findstring alpine,$(DIST)))
    ALPINELINUX_PLUGIN_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
    DISTRIBUTION := alpinelinux
    BUILDER_MAKEFILE = $(ALPINELINUX_PLUGIN_DIR)Makefile.alpinelinux
    TEMPLATE_SCRIPTS = $(ALPINELINUX_PLUGIN_DIR)scripts
endif

# vim: ft=make
