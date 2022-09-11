# BitBake cheat sheet

## Contents  [web link](https://wiki.st.com/stm32mpu/wiki/BitBake_cheat_sheet#)

- [1Command-line options](https://wiki.st.com/stm32mpu/wiki/BitBake_cheat_sheet#Command-line_options)
- [2.bb file syntax](https://wiki.st.com/stm32mpu/wiki/BitBake_cheat_sheet#-bb_file_syntax)
- [3Additional BitBake-related command](https://wiki.st.com/stm32mpu/wiki/BitBake_cheat_sheet#Additional_BitBake-related_command)
- [4Useful links](https://wiki.st.com/stm32mpu/wiki/BitBake_cheat_sheet#Useful_links)

## 1 Command-line options

Here are a few commonly-used command line options for BitBake.

| Option                                | Meaning                                                      |
| ------------------------------------- | ------------------------------------------------------------ |
| `-c` <task>                           | execute <task> for the image or recipe being built. ex: bitbake -c fetch busybox.Some of the possible tasks are: fetch, configure, compile, package, clean |
| `-f`                                  | force execution of the operation, even if not required       |
| `-b`                                  | execute tasks from a specific .bb recipe directly. This does not handle any dependencies from other recipes.` bitbake -b ../meta-st/meta-st-cannes2/recipes-multimedia/gstreamer/gstreamer1.0-plugins-stm_local.bb  -f -c compile ` |
| `-v`                                  | show verbose output                                          |
| `-DDD`                                | show lots of debug information                               |
| `-s`                                  | show recipe version information                              |
| `-e`                                  | output recipe environment variables` bitbake -e <recipe> `   |
| `--help`                              | get usage help                                               |
| `-c` listtasks <image-or-recipe-name> | show the tasks associated with an image or individual recipe |
| `-g` <recipe>                         | output dependency tree in graphviz format`bitbake -g <recipe> dot -v -Tpng -o package-depends.png package-depends.dot dot -v -Tpng -o pn-depends.png pn-depends.dot dot -v -Tsvg -o task-depends.svg task-depends.dot ` |

Here are a few examples of command line options for BitBake.

| How to                                           | Command                                     | Comment                                                 |
| ------------------------------------------------ | ------------------------------------------- | ------------------------------------------------------- |
| `How to get the version of packages`             | bitbake -s                                  |                                                         |
| `How to get the Image package list`              | bitbake <image> -g                          | Then: cat pn-buildlist                                  |
| `How to clean a module`                          | bitbake <module> -f -c cleanall             |                                                         |
| `How to clean an image`                          | bitbake <image> - c cleanall                |                                                         |
| `How to load the packages to a local hard drive` | bitbake <image> -f -c fetchall              |                                                         |
| `How to get the list of tasks`                   | bitbake <image> -f -c listtasks             |                                                         |
| `How to display all appends`                     | bitbake-layers show-appends                 |                                                         |
| `How to display all layers`                      | bitbake <recipe-or-image-name> -g -u depexp |                                                         |
| `How to configure the kernel`                    | bitbake <kernel_module> -c menuconfig       | kernel module : linux-stm32                             |
| `How to make an SDK relocatable image`           | bitbake <image> -c populate_sdk             | self-extracting image available in tmp-glibc/deploy/sdk |

## 2 .bb file syntax

This table lists some of the syntaxes found in recipe (.bb) files.

| Syntax                                                       | Meaning                                                      | Notes                                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `VAR = "foo" `                                               | simple assignment                                            |                                                              |
| `VAR ?= "foo" `                                              | assign if no other value is already assigned (default assignment) |                                                              |
| `VAR ??=foo `                                                | weak default assignment                                      | takes lower precedence than ?=                               |
| `VAR = "stuff ${OTHER_VAR} more" `                           | variable expansion                                           | OTHER_VAR expanded at time of reference to VAR               |
| `VAR := "stuff ${OTHER_VAR} more" `                          | immediate variable expansion                                 | OTHER_VAR expanded when parsing this line                    |
| `VAR += "foo" `                                              | append with space                                            |                                                              |
| `VAR =+ "foo" `                                              | prepend with space                                           |                                                              |
| `VAR .= "foo" `                                              | append without space                                         |                                                              |
| `VAR =. "foo" `                                              | prepend without space                                        |                                                              |
| `VAR_append = "foo" `                                        | append without space                                         |                                                              |
| `OVERRIDES="string1:string2" VAR = "foo" VAR_string1 = "bar" ` | alternate/override value                                     | if string1 is listed in OVERRIDES, use "bar" for value of VAR, otherwise use "foo" |
| `OVERRIDES="string1:string2" VAR = "foo" VAR_append_string1 = " bar" ` | conditional append                                           | if string1 is in OVERRIDES, then append " bar" to the value of VAR |
| `BBVERSIONS="1.0 1.8 string" VAR="foo" VAR_string="bar" `    | range-specific conditional                                   | If the version of the package is in the specified range (1.0-1.8 in this example), then perform an override on the indicated variable |
| `VAR = "foo ${@<line-of-python-code>}" `                     | python code expansion                                        | ex: VAR = "the date is: ${@time.strftime(’%Y%m%d’,time.gmtime())}" |
| `include foo `                                               | include file                                                 | include file named "foo", search BBPATH                      |
| `require [<path>]foo `                                       | require file                                                 | include file named "foo", failing if not found exactly where specified |
| `do_sometask() {  <shell code> } `                           | define a task using shell code                               |                                                              |
| `python do_sometask {  <python code> `                       | define a task using python code                              |                                                              |
| `addtask sometask (before|after) other_task `                | add a task                                                   | adds a defined task to the list of tasks, with a specific ordering. Zero or more 'before' or 'after' clauses can be used. |
| `VAR [some_flag]="foo" `                                     | associate a subsidiary flag value to a variable              | a few subsidiary flag value names are well-defined: "dirs", "cleandirs", "noexec", "nostamp", "fakeroot", "umask", "deptask", "rdeptask", "recdeptask", "recrdeptask" %%%Flag values appear to be used exclusively with task definitions (i.e. do_sometask) |

## 3 Additional BitBake-related command

| Syntax                                      | Meaning                                                   | Notes                                                        |
| ------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| bitbake-layers                              | Shows information about layers and recipes                | Included in the bitbake/bin directory in openembedded source tree. |
| bitbake-whatchanged <image>                 | Shows all changes made since the last generation of image | `  bitbake st-image-weston  # Edit the recipes  bitbake-whatchanged st-image-weston ` |
| bitbake -g -u depexp <recipe-or-image-name> | Shows dependency information in a graphical interface     |                                                              |
| bitbake -u goggle st-image-weston           | simple graphical interface                                | This is a simple graphical wrapper over the streaming text output of BitBake. It shows collapsible trees for the logs for sub-tasks for each recipe. |

## 4 Useful links

- https://www.openembedded.org/wiki/BitBake_(user)
- http://www.openembedded.org/wiki/Main_Page
- [Yocto Project Develpoment Manual](https://docs.yoctoproject.org/4.0/dev-manual/dev-manual.html)
- [BitBake User Manual](https://docs.yoctoproject.org/4.0/bitbake-user-manual/bitbake-user-manual.html)