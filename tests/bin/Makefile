# Don't print executed commands
.SILENT:

project_DIRS := $(sort $(dir $(wildcard */)))
project_BINS := $(project_DIRS:/=_bin)

all: $(project_BINS)

%_bin:
	$(MAKE) -C $*
