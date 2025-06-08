#include <assert.h>
#import <Foundation/Foundation.h>
#import "OCEnum.h"

#define PUTS(FORMAT, ...) \
    fprintf(stdout, "%s\n", \
        [[NSString stringWithFormat: \
            FORMAT, ##__VA_ARGS__] UTF8String]);

int main(void)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!pool) return 1;

    // Example 1: Traffic Light Enum (Symbolic)
    {
        OCEnum *trafficLight = [[[OCEnum alloc]
            initSymbolWithStrings: @"green", @"yellow", @"red",
            nil] autorelease];

        assert(0 == [[[trafficLight green] value] unsignedIntValue]);
        assert(1 == [[[trafficLight yellow] value] unsignedIntValue]);
        assert(2 == [[[trafficLight red] value] unsignedIntValue]);

        id redLight = [trafficLight red];
        assert([redLight isEqualToEnumValue:[trafficLight red]]);
        assert(![redLight isEqualToEnumValue:[trafficLight green]]);

        for (id e in [trafficLight values])
            PUTS(@"%@", [e value]);

        puts("---");
    }

    // Example 2: File Mode Enum (Bit flags)
    {
        OCEnum *fileMode = [[[OCEnum alloc]
            initFlagWithStrings: @"exec", @"write", @"read",
            nil] autorelease];

        assert(1 == [[[fileMode exec] value] unsignedIntValue]);
        assert(2 == [[[fileMode write] value] unsignedIntValue]);
        assert(4 == [[[fileMode read] value] unsignedIntValue]);

        for (id e in [fileMode values])
            PUTS(@"%@", [e value]);

        unsigned mode = [[fileMode combineFlags:
            [fileMode read], [fileMode exec],
            nil] unsignedIntValue];
        assert(5 == mode);

        mode = [[fileMode combineFlags:
            [fileMode read], [fileMode write], [fileMode exec],
            nil] unsignedIntValue];
        assert(7 == mode);

        mode = [[fileMode combineFlagsByStrings:
            @"read", @"exec",
            nil] unsignedIntValue];
        assert(5 == mode);

        mode = [[fileMode combineFlagsByStrings:
            @"read", @"write", @"exec",
            nil] unsignedIntValue];
        assert(7 == mode);

        mode = [[fileMode combineFlagsBySelectors:
            @selector(read), @selector(exec),
            nil] unsignedIntValue];
        assert(5 == mode);

        mode = [[fileMode combineFlagsBySelectors:
            @selector(read), @selector(write), @selector(exec),
            nil] unsignedIntValue];
        assert(7 == mode);
    }

    [pool drain];
    return 0;
}
