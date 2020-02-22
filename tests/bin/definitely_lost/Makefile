CXXFLAGS = -std=c++11 -g3 -ggdb3 -Og

# Don't print executed commands
.SILENT:

# Keep make from removing intermediate files
.PRECIOUS: out/%

project_SRC := main.cpp
project_BIN=definitely_lost

all: $(addprefix out/,$(project_BIN))

out/%: $(project_SRC)
	[ -d out/ ] || mkdir out
	echo [CXX] $*
	g++ $(CXXFLAGS) -o out/$* $(project_SRC)
