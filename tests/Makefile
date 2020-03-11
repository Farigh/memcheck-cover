# Don't print executed commands
.SILENT:

test_BINS := $(wildcard bin/*/out/*)
testsuite_setup_DIRS := $(sort $(dir $(wildcard */ts_setup.sh)))
testsuite_setup_OUTS := $(addprefix out/,$(testsuite_setup_DIRS:/=.out))

all: bin_compile setup_tests

out/%.out: %/ts_setup.sh $(test_BINS) utils.test.sh
	$<

setup_tests: $(testsuite_setup_OUTS)

bin_compile:
	$(MAKE) -C bin