# Changelog

All notable changes to the Memcheck-Cover project will be documented in this file.

## [Unreleased](https://github.com/Farigh/memcheck-cover/tree/HEAD)

[Full Changelog](https://github.com/Farigh/memcheck-cover/compare/release-1.2...HEAD)

## [v1.2](https://github.com/Farigh/memcheck-cover/releases/tag/release-1.2) (2021-03-14)

[Full Changelog](https://github.com/Farigh/memcheck-cover/compare/release-1.1...release-1.2)

**New features:**
  - Add support for Valgrind's `--fullpath-after` option to the `memcheck_runner.sh` script
  - Add support for path prefix substitution to the `generate_html_report.sh` script (issue [#15](https://github.com/Farigh/memcheck-cover/issues/15))
  - Add support for version control server link to the `generate_html_report.sh` script (issue [#16](https://github.com/Farigh/memcheck-cover/issues/16))

**Enhancements:**
  - Reduced the report header size
  - Improved the report dark themes (Process termination and host stacktrace titles are now more visible)
  - Reworked the report title selection to match the theme selection style

**Fixed bugs:**
  - Color reset sequence was not working properly in some environment (was set to `\e[00m` instead of `\e[0m`)
  - Fixed gawk newer version (5.0) raised warnings

## [v1.1](https://github.com/Farigh/memcheck-cover/releases/tag/release-1.1) (2020-08-05)

[Full Changelog](https://github.com/Farigh/memcheck-cover/compare/release-1.0...release-1.1)

**Enhancements:**
  - Add dark theme alternatives (issue [#5](https://github.com/Farigh/memcheck-cover/issues/5))
  - Persist both `theme` and `title type` display settings (issue [#8](https://github.com/Farigh/memcheck-cover/issues/8))
  - Set the <title> HTML tag (issue [#10](https://github.com/Farigh/memcheck-cover/issues/10))

**Fixed bugs:**
  - Incorrect generation while specifying an output-dir without a trailing slash (issue [#7](https://github.com/Farigh/memcheck-cover/issues/7))
  - Wrong MIME type warning (issue [#12](https://github.com/Farigh/memcheck-cover/issues/12))

## [v1.0](https://github.com/Farigh/memcheck-cover/releases/tag/release-1.0) (2020-05-08)

[Full history](https://github.com/Farigh/memcheck-cover/commits/release-1.0)

The initial version of the memcheck-cover tools.

The `memcheck_runner.sh` script supports the following options:
  - `-h|--help` which displays the help message.
  - `-i|--ignore=FILE` which provides FILE to Valgrind as the suppression file.
  - `-o|--output-name=NAME` which is mandatory and defines the output file name (which will be suffixed with the .memcheck extension).
  - `-s|--gen-suppressions` which enables Valgrind suppression generation in the output file, those can be used to create a suppression file.

---

The `generate_html_report.sh` script supports the following options:
  - `-h|--help` which displays this help message.
  - `-g|--generate-config` which generates a 'memcheck-cover.config' file in the current directory, containing the default configuration values.
  - `-c|--config=FILE` which loads the configuration from FILE. An example configuration file can be generated using the --generate-config option.\
If this option is not set, or values are missing in FILE, the default values will be used.
  - `-i|--input-dir=DIR` which is mandatory and defines the input directory where the .memcheck files are.\
The files will be searched in directories recursivly.
  - `-o|--output-dir=DIR` which is mandatory and defines the output directory where the HTML report will be produced.

The `generate_html_report.sh` script highlights the following elements:
  - SUMMARY headers
  - Sources file and line in stacktraces
  - Violation suppressions
  - LEAK SUMMARY elements from memcheck/mc_leakcheck.c:
    - definitely lost: .\* bytes in .\* blocks
    - indirectly lost: .\* bytes in .\* blocks
    - possibly lost: .\* bytes in .\* blocks
    - still reachable: .\* bytes in .\* blocks
    - of which reachable via heuristic:
  - Violations from memcheck/mc_errors.c:
    - contains unaddressable byte(s)
    - Use of uninitialised value of size
    - Conditional jump or move depends on uninitialised value(s)
    - Syscall param .\* contains uninitialised byte(s)
    - Syscall param .\* points to unaddressable byte(s)
    - Syscall param .\* points to uninitialised byte(s)
    - Unaddressable byte(s) found during client check request
    - Uninitialised byte(s) found during client check request
    - Invalid free() / delete / delete[] / realloc()
    - Mismatched free() / delete / delete []
    - Invalid read of size
    - Invalid write of size
    - Jump to the invalid address stated on the next line
    - Source and destination overlap in
    - Illegal memory pool address
    - [0-9]+ bytes in [0-9]+ blocks are definitely lost in loss record
    - [0-9]+ bytes in [0-9]+ blocks are indirectly lost in loss record
    - [0-9]+ bytes in [0-9]+ blocks are possibly lost in loss record
    - [0-9]+ bytes in [0-9]+ blocks are still reachable in loss record
    - Argument '.\*' of function .\* has a fishy (possibly negative) value:
  - Context from memcheck/mc_errors.c:
    - Uninitialised value was created by a stack allocation
    - Uninitialised value was created by a heap allocation
    - Uninitialised value was created by a client request
    - Uninitialised value was created
  - Context from coregrind/m_syswrap/syswrap-generic.c:
    - Warning: invalid file descriptor [0-9]+ in syscall .\*()
  - Block violation and context from memcheck/mc_leakcheck.c:
    - Block 0x[0-9a-fA-F]+..0x[0-9a-fA-F]+ overlaps with block 0x[0-9a-fA-F]+..0x[0-9a-fA-F]+
    - Blocks allocation contexts:
  - Signal context from : coregrind/m_signals.c
    - Access not within mapped region
    - Bad permissions for mapped region
    - General Protection Fault
    - Illegal opcode
    - Illegal operand
    - Illegal addressing mode
    - Illegal trap
    - Privileged opcode
    - Privileged register
    - Coprocessor error
    - Internal stack error
    - Integer divide by zero
    - Integer overflow
    - FP divide by zero
    - FP overflow
    - FP underflow
    - FP inexact
    - FP invalid operation
    - FP subscript out of range
    - FP denormalize
    - Invalid address alignment
    - Non-existent physical address
    - Hardware error
    - Warning: bad signal number [0-9]+ in sigaction()
    - Warning: ignored attempt to set .\* handler in sigaction();
    - the .\* signal is used internally by Valgrind
    - the .\* signal is uncatchable
    - Process terminating with default action of signal [0-9]+
  - Address context from : coregrind/m_addrinfo.c
    - Address 0x[0-9a-fA-F]+ is just below the stack ptr.
    - Address 0x[0-9a-fA-F]+ is on thread .\*'s stack.
    - Address 0x[0-9a-fA-F]+ is not stack'd, malloc'd or (recently) free'd
    - Address 0x[0-9a-fA-F]+ is not stack'd, malloc'd or on a free list
    - in frame #[0-9]+, created by .\*
    - .\* bytes below stack pointer
    - In stack guard protected page, .\* bytes below stack pointer
    - Address 0x[0-9a-fA-F]+ is .\* bytes inside a block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes after a block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes before a block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes inside an unallocated block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes after an unallocated block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes before an unallocated block of size .\* in arena
    - Address 0x[0-9a-fA-F]+ is .\* bytes inside a .\* of size
    - Address 0x[0-9a-fA-F]+ is .\* bytes after a .\* of size
    - Address 0x[0-9a-fA-F]+ is .\* bytes before a .\* of size
    - Block was alloc'd at
    - Block was alloc'd by thread
    - Address 0x[0-9a-fA-F]+ is .\* bytes inside data symbol ".\*"
    - Address 0x[0-9a-fA-F]+ is in the .\* segment of
    - Address 0x[0-9a-fA-F]+ is in the brk data segment
    - Address 0x[0-9a-fA-F]+ is .\* bytes after the brk data segment limit
    - Address 0x[0-9a-fA-F]+ is in a .\* segment
