This document describes the basic design decisions behind bashlib. There will be some redundancy in the explanations below so you don't have to read the whole thing if you're only interested in specific aspects.

# Naming convention
## Prefixes <a id="Prefixes"></a>
Every name in bashlib is prefixed by _something_ to

- mark it as part of bashlib
- not pollute the global namespace (chances are very slim that you'll be using the same prefixes as bashlib, if any)
- group similar things together.

This ominous _something_ consists of three parts, separated by underscores `_`.

1. A leading underscore `_` marks a variable or function as __internal__, i.e. not supposed to be considered as part of the public API. Obviously, this is optional since it only applies to a very small subset of bashlib. And being the exception to the above mentioned rule, there's no additional underscore to separate this part from the next one.
2. The abbreviation `bl` or `BL` is used to mark it as part of __bashlib__.
3. An as-small-as-possible term describes the __general nature__ of the function or variable.

See [Functions](#Functions) and [Variables](#Variables) for more details (and examples).

## Files
bashlib is organized as a set of different source files, grouping together functions and variables of similar nature. For example, the file `bl_log` contains everything related to logging.

The filename is based on the [prefix](#Prefixes) that is used to name all things.

Some source files are split into two parts, a regular named one like `bl_fs` and one with an additional `_base` suffix like `bl_fs_base`. This is required in some cases to resolve dependency-related issues. For example, `bl_fs` is meant to provide basic filesystem-related functions and `bl_log` is built upon `bl_fs`. There wouldn't be a way to use logging inside `bl_fs` if it was monolithic.

## Other stuff
- Whenever we denote a directory, we use `DIR` and not `PATH`. So it's `BL_LOG_DIR` and not `BL_LOG_PATH`.

# Functions <a id="Functions"></a>
- Function names are always in lower case letters and prefixed by the filename they're in.
- If the prefix introduces an ugly redundancy, the redundant part will be omitted.
- Underscores `_` are used to separate the parts of the name from each other.

For example, the name of the function to log an informational message is `log_i`. Being part of the file `bl_log`, it's supposed to inherit the prefix `bl_log`, which would lead to the complete name being `bl_log_log_i`. Since that's an ugly name, the rundant part is omitted and the final name is `bl_log_i`.

Functions are defined in C-style, not POSIX-style. (Yes, that makes them incompatible to POSIX.)

``` bash
function bl_log_do_stuff
{
   ... doing some stuff ...
}
```

Function arguments are always assigned to local variables at the beginning of the function body, even in the simplest cases. This is a measure of self-documentation in the code.

``` bash
function bl_do_stuff_with_file
{
   local file=$1

   ... doing interesting stuff here ...
}
```

Other (non-argument) local variables are supposed to be declared right before they are used, not all at once at the beginning of the function.

If a function is only meant for internal purposes and not considered to be part of the public API, an underscore `_` is to be added to the already established prefix.

``` bash
function _bl_log_internal_helper_function
{
   ... something is going on here ...
}
```

# Variables <a id="Variables"></a>
- Global variable names are always in upper case letters and prefixed by the filename they're in.
- If the prefix introduces an ugly redundancy, the redundant part will be omitted.
- Local variable names are always in lower case letters. (no prefix)
- Underscores `_` are used to separate the parts of the name from each other.

For example, the name of the global variable holding the directory name where the logfile is to be created is `LOG_DIR`. Being part of the file `bl_log`, it's supposed to inherit the prefix `BL_LOG`, which would lead to the the complete name being `BL_LOG_LOG_DIR`. Since that's an ugly name, the redundant part is omitted and the final name is `BL_LOG_DIR`.

If a global variable is only meant for internal purposes and not considered to be part of the public API, an underscore `_` is to be added to the already established prefix, e.g. `_BL_LOG_SOMETHING_INTERAL`.

# Performance
bashlib prefers __design__ and simplicity __over performance__. That's not supposed to mean that it's being lazy or wasting system resources on purpose - it does not! - but it doesn't sacrifice a simple solution for a more complicated one just to save some CPU cycles. bashlib is not meant for performance critical stuff, it's meant to (hopefully) make things easier. For example, bashlib makes extensive use of subshelling when calling functions to benefit from local variable scope. That's bad for performance but good for design.  
I'd like to think that we only waste the CPU cycles that we don't notice being there in the first place - not accounting for scenarios like "I need to do X a million times in less than Y seconds".

# External programs
bashlib tries to do as much as possible inside bash without relying on external programs. That being said, we're not going to reinvent the wheel if widely-used and matured programs are available (and have been around for much longer than I've been around Unix/Linux) and can be considered as a given set of the most basic utilities like (GNU) core utilities. For example, getting a file- or directory name from a given path is plain string manipulation in a lot of cases. That could be done with bash functionality, but would be an unexpected and more error-prone deviation from what one is used to who's written scripts and worked with `dirname`, `basename` etc. before.

# Multiplatform
This topic hasn't been fully sorted out yet.  
In a nutshell: bashlib is multiplatform where bash (v4.x) is available, but with exceptions (that's the _not fully sorted out_ part). The exceptions are the core utilities, which (may) behave differently depending on the platform.  
The main target platform for bashlib is Linux, and that won't change. Since my home server runs FreeBSD, I'll make bashlib work with that as well. (At least the parts I need; there's already some Linux vs FreeBSD functions in bashlib, but I'm not sure about the current approach. It needs more time.) Every other platform is potentially hit-or-miss.

Questions to be figured out:
- Make GNU core utils a mandatory requirement on every platform?
- Work with/around what each platform has to offer to the best possible extent, resulting in different behavoirs?
- Let a script run on an unsupported platform, hoping for the best? (=won't eat your cat)
- Don't let a script run on an unsupported platform, fearing it'll eat your cat?
- ...
