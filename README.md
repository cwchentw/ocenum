# OCEnum

A lightweight enumeration class system for Objective-C, inspired by Java-style enums.

OCEnum allows you to define enums as objects with names and values, enabling type-safe comparisons, string representation, and runtime reflection—features not natively available in Objective-C.

## System Requirements

- Clang or GCC with Objective-C support
- Cocoa (macOS) or GNUstep (Linux / cross-platform)

Tested on **GNUstep** with **Ubuntu 24.04 LTS**.

## Building

To build as a dynamic library:

```sh
make dynamic
```

To build as a static library:

```sh
make static
```

## Example Usage

See [`main.m`](main.m) for a full example of how to declare and use an OCEnum.

## Notes

- The Objective-C compiler may emit warnings about "unrecognized selectors" when compiling OCEnum code. These warnings are safe to ignore: OCEnum uses runtime message dispatch to implement dynamic behavior, and those selectors are not declared in static interfaces.
- For compatibility on non-Apple platforms, the build system uses **GCC's `libobjc`** when compiling under GNUstep.
- Compatibility on macOS may vary depending on your version of the Objective-C runtime.

## License

MIT License
© 2020–2025 ByteBard
