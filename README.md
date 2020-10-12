# ocenum

Enumeration class for Objective-C.

## System Requirements

* Clang or GCC with Objective-C support
* Cocoa or GNUstep

Tested against GNUstep on Ubuntu 18.04 LTS. It should work on MacOS as well.

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

## Copyright

Copyright (c) 2020 Michael Chen.  Licensed under MIT.
