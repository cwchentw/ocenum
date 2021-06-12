# ocenum

Enumeration class for Objective-C.

## System Requirements

* Clang or GCC with Objective-C support
* Cocoa or GNUstep

Tested against GNUstep on Ubuntu 18.04 LTS.

## Usage

Build a dynamic library:

```
$ make dynamic
```

Build a static library:

```
$ make static
```

## Documentation

See [main.m](/main.m) for its usage.

## Note

Your Objective-C compiler will emit many warnings about potentially unresponsive messages. It's fine to neglect these warnings because those messages are generated on runtime, not showing in the interface of your enumeration object.

For better compatibility between libobjc and GNUstep, we use the libobjc of GCC on non-Apple platforms.

`OCEnum` may not work on some versions of MacOS.

## Copyright

Copyright (c) 2020-2021 Michelle Chen.  Licensed under MIT.
