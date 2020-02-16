# Don't print executed commands
.SILENT:

test_compile:
	$(MAKE) -C tests

test: test_compile
	tests/run_tests.sh