# Memcheck cover

Memcheck cover provides a bash helper for Valgrind Memcheck analysis.\
It also provides an HTML report generator formatting Valgrind raw reports and highlighting important parts to help you interpret those results.\
It can easily be used in you CI environment to automatically generate reports.

A demonstration being better than any words, you can find a [generated HTML report example here](https://david-garcin.github.io/demos/memcheck-cover/index.html).

### :eight_spoked_asterisk: The Valgrind's Memcheck tool runner

The `memcheck_runner.sh` script is a wrapper that will run a binary under Valgrind's Memcheck tool.

#### :large_orange_diamond: Prerequisites

For the `memcheck_runner.sh` script to work, the following tools must be installed and accessible using the PATH environment variable:
  - `bash` Bash version 4 and upper only are supported.
  - `valgrind` Valgrind version 3.13 was tested, older version might not work as intended

#### :large_orange_diamond: Memcheck runner usage

Here is its usage (it can be accessed using the `--help` option):
```
Usage: memcheck_runner.sh [OPTIONS]... -- [BIN] [BIN_ARG]...
Runs the BIN with the BIN_ARGs through valgrind memcheck analyser.

Options:
  -h|--help               Displays this help message.
  -i|--ignore=FILE        Provides valgrind FILE as the suppression file.
  -o|--output-name=NAME   [MANDATORY] Defines the output file name
                          (will be suffixed with the .memcheck extension).
  -s|--gen-suppressions   Enables valgrind suppression generation in the output
                          file, those can be used to create a suppression file.
  --fullpath-after=       (with nothing after the '=')
                          Show full source paths in call stacks.
  --fullpath-after=STR    Like --fullpath-after=, but only show the part of the
                          path after 'STR'. Allows removal of path prefixes.
                          Use this flag multiple times to specify a set of
                          prefixes to remove.
```

The only mandatory option is the `--output-name`, which will define the output file path and name.\
If the path does not exist, it will be created.\
The `.memcheck` extension will automatically be added to it for compatibility with the `generate_html_report.sh` script.

Example:
```shell
$ memcheck_runner.sh --output-name "my/output/path/filename" -- true can take useless params and still be one true self
Info: Output file set to: 'my/output/path/filename.memcheck'
Info: Creating output directory 'my/output/path/'
Info: Running the following cmd with valgrind:
      "true" "can" "take" "useless" "params" "and" "still" "be" "one" "true" "self"
```

##### :small_blue_diamond: Valgrind suppressions

You can specify a violation suppression file using the `--ignore` option.\
Such suppression file must follow [Valgrind's suppression file rules](https://valgrind.org/docs/manual/mc-manual.html#mc-manual.suppfiles).

Suppressions can be generated within the report using the `--gen-suppressions` option.\
The suppression will look like that in the report:
```
[...]
==21849== 4 bytes in 1 blocks are definitely lost in loss record 1 of 1
==21849==    at 0x4C3017F: operator new(unsigned long) (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==21849==    by 0x108687: breakage::evil_definitely_lost_func() (main.cpp:4)
==21849==    by 0x10869B: main (main.cpp:10)
==21849==
{
   <insert_a_suppression_name_here>
   Memcheck:Leak
   match-leak-kinds: definite
   fun:_Znwm
   fun:_ZN8breakage25evil_definitely_lost_funcEv
   fun:main
}
==21849== LEAK SUMMARY:
==21849==    definitely lost: 4 bytes in 1 blocks
[...]
```

This call will output the Valgind's report to the `filename.memcheck` file within the `my/output/path/` directory, which in this example was created.\
The Valgrind analysis was run using the `true` binary, passing it many parameters.

##### :small_blue_diamond: Display sources fullpath

From [Valgrind's documentation](https://www.valgrind.org/docs/manual/manual-core.html#opt.fullpath-after):
```
By default Valgrind only shows the filenames in stack traces, but not full paths to source files.
When using Valgrind in large projects where the sources reside in multiple different directories, this can be inconvenient.
`--fullpath-after` provides a flexible solution to this problem.
When this option is present, the path to each source file is shown, with the following all-important caveat:
if string is found in the path, then the path up to and including string is omitted, else the path is shown unmodified.
Note that string is not required to be a prefix of the path.

For example, consider a file named /home/janedoe/blah/src/foo/bar/xyzzy.c. Specifying --fullpath-after=/home/janedoe/blah/src/ will cause Valgrind to show the name as foo/bar/xyzzy.c.

Because the string is not required to be a prefix, --fullpath-after=src/ will produce the same output. This is useful when the path contains arbitrary machine-generated characters.
For example, the path /my/build/dir/C32A1B47/blah/src/foo/xyzzy can be pruned to foo/xyzzy using --fullpath-after=/blah/src/.

If you simply want to see the full path, just specify an empty string: --fullpath-after=. This isn't a special case, merely a logical consequence of the above rules.

Finally, you can use --fullpath-after multiple times. Any appearance of it causes Valgrind to switch to producing full paths and applying the above filtering rule.
Each produced path is compared against all the --fullpath-after-specified strings, in the order specified. The first string to match causes the path to be truncated as described above.
If none match, the full path is shown.
This facilitates chopping off prefixes when the sources are drawn from a number of unrelated directories.
```

Passing the `--fullpath-after` to `memcheck_runner.sh` will forward it directly to Valgrind, having the previously described effect.

#### :large_orange_diamond: Valgrind's Memcheck tool options

For now, Valgrind's options are not customizable.

The following options are used:
  - `--track-origins=yes`\
When set to yes, Memcheck keeps track of the origins of all uninitialized values.\
Then, when an uninitialised value error is reported, Memcheck will try to show the origin of the value.\
An origin can be one of the following four places: a heap block, a stack allocation, a client request, or miscellaneous other sources (eg, a call to brk).
  - `--leak-check=full`\
Memcheck will give details for each definitely lost or possibly lost block, including where it was allocated.\
It cannot tell you when or how or why the pointer to a leaked block was lost; you have to work that out for yourself.\
In general, you should attempt to ensure your programs do not have any definitely lost or possibly lost blocks at exit.
  - `--show-reachable=yes`\
This is equivalent to `--show-leak-kinds=all`
  - `--show-leak-kinds=all`\
Memcheck will report for its complete set of leak kinds.\
This is equivalent to `--show-leak-kinds=definite,indirect,possible,reachable`
  - `--num-callers=50`\
Specifies the maximum number of entries shown in stack traces that identify program locations.
  - `--fair-sched=yes`\
This activates a fair scheduler.\
In short, if multiple threads are ready to run, the threads will be scheduled in a round robin fashion.

For more details, please refer to the [Valgrind's documentation](https://valgrind.org/docs/manual/).

---

### :eight_spoked_asterisk: The HTML report generator

The `generate_html_report.sh` script will generate an HTML report with all the Memcheck result files in a given directory.

#### :large_orange_diamond: Prerequisites

For the `generate_html_report.sh` script to work, the following tools must be installed and accessible using the PATH environment variable:
  - `bash` Bash version 4 and upper only are supported.
  - `gawk` GNU awk 4.1.4 was tested, older version might not work as intended

#### :large_orange_diamond: HTML report generator usage

Here is its usage (it can be accessed using the `--help` option):
```
Usage: generate_html_report.sh [OPTIONS]...
Parses all .memcheck files from a given directory and generates an HTML
report.

Options:
  -h|--help             Displays this help message.
  -g|--generate-config  Generates a 'memcheck-cover.config' file in the current
                        directory, containing the default configuration values.

  -c|--config=FILE      Loads the configuration from FILE. An example
                        configuration file can be generated using the
                        --generate-config option.
                        If this option is not set, or values are missing in
                        FILE, the default values will be used.
  -i|--input-dir=DIR    [MANDATORY] Defines the input directory where the
                        .memcheck files are.
                        The files will be searched in directories recursivly.
  -o|--output-dir=DIR   [MANDATORY] Defines the output directory where the
                        HTML report will be produced.
```

There are two mandatory parameters to the generator:
  - `--input-dir` which defines the path where the Memcheck reports to be processed are.\
The generator will iterate over sub-directories and process any `.memcheck` file it finds.
  - `--output-dir` which defines the path in which the HTML report will be generated.

If the default violation settings does not fit you, each violation criticality can be adjusted.\
A configuration file, with all the available criticality settings and their default values, can be generated using the `--generate-config` option:
```shell
$ generate_html_report.sh --generate-config
Info: Generating configuration with default values: 'memcheck-cover.config'...
Done. The generated configuration can be modified and then loaded
by the current script using the --config option.
If a violation is not set, the default value will be used.
```
The default configuration file is generated in the current directory in the file `memcheck-cover.config`.\
You can then change any criticality to fit your needs, and pass it to the generator using the `--config` option.\
If any criticality is missing from the file, the default one will be applied.

Passing any configuration file with invalid parameters or parameter values will result in an error.\
For example:
  - `Error: Invalid configuration value 'dummy' for parameter: memcheck_violation_criticality['contains_unaddressable']` => The `dummy` criticality does not exist
  - `Error: Invalid configuration parameter: memcheck_violation_criticality['dummy_param']` => The `dummy_param` key does not exist for `memcheck_violation_criticality`

Here is a generation example, with the following tree:
```
my/output/path/
├── another_dir/
│   ├── a_report.memcheck
│   └── other_report.memcheck
└── filename.memcheck
```

Let's run the HTML generator:
```shell
generate_html_report.sh --input-dir "my/output/path/" --output-dir "my/output/path/report/" --config memcheck-cover.config
Info: Input directory set to: 'my/output/path/'
Info: Loading configuration from file 'memcheck-cover.config'...
Info: Processing memcheck file 'filename.memcheck' ...
Info: Processing memcheck file 'another_dir/a_report.memcheck' ...
Info: Processing memcheck file 'another_dir/other_report.memcheck' ...
Info: Generating index.html...
```

The result will look like this:
```
my/output/path/report/
├── another_dir/
│   ├── a_report.memcheck.html.part
│   └── other_report.memcheck.html.part
├── filename.memcheck.html.part
├── index.html
├── memcheck-cover.css
└── memcheck-cover.js
```

#### :large_orange_diamond: Advanced options

##### :small_blue_diamond: Path prefix substitution

This option is only available through the configuration file (see **-g|--generate-config** option).

It can be defined by filling the following associative array:
```shell
memcheck_path_prefix_replacement["<prefix_to_replace>"]="<replacement_value>"
```

Where the key `prefix_to_replace` is the path's prefix to be replaced\
And the value `replacement_value` is the replacing value (it can be left empty to remove the prefix completly)

For example, setting:
```shell
memcheck_path_prefix_replacement["/var/user/repo"]="<repo>"
```

Would convert the following report line:
```text
==1==    at 0x10101042: myFunc() (/var/user/repo/src/lib1/MyClass.cpp:14)
```

To:
```
==1==    at 0x10101042: myFunc() (<repo>/src/lib1/MyClass.cpp:14)
```

Multiple replacements can be defined

:warning: The source path needs to be displayed for this to work (see [Display source fullpath](#small_blue_diamond-display-sources-fullpath))

##### :small_blue_diamond: Source control server link generation

This option is only available through the configuration file (see **-g|--generate-config** option).

It can be defined by filling the following associative arrays (both are needed):
```shell
memcheck_url_prefix_replacement["<path_prefix>"]="<repository_url_prefix>"
memcheck_url_prefix_replacement_type["<path_prefix>"]="<repository_type>"
```

Where the key `path_prefix` is the file path prefix to the repository root directory.

The value `repository_url_prefix` is the source control server prefix to the repository.\
Here are some example:
  - Github: https://github.com/example/example_project/blob/master/
  - GitLab: https://gitlab.com/example/example_project/-/blob/master/
  - BitBucket: http://bitbucket.org/example/example_project/src/master/

And the value `repository_type` is one of the supported server type (case does not matter):
  - GitHub
  - GitLab
  - BitBucket

:warning: It's advised to set a link pointing to a specific commit sha1 instead of a branch so that the report's links would always point to a meaningful line.

For example, setting:
```shell
memcheck_url_prefix_replacement["/var/user/repo/"]="https://github.com/example/example_project/blob/master/"
memcheck_url_prefix_replacement_type["/var/user/repo/"]="github"
```

Would convert the following report line:
```text
==1==    at 0x10101042: myFunc() (/var/user/repo/src/lib1/MyClass.cpp:14)
```

To:
```
==1==    at 0x10101042: myFunc() (<a href="https://github.com/example/example_project/blob/master/src/lib1/MyClass.cpp#L14">/var/user/repo/src/lib1/MyClass.cpp:14</a>)
```

Multiple replacements can be defined
