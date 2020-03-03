# Don't print executed commands
.SILENT:

test_compile:
	$(MAKE) -C tests bin_compile

setup_tests:
	$(MAKE) -C tests setup_tests

test: test_compile setup_tests
	tests/run_tests.sh