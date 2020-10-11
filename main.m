#include <assert.h>

#import <Foundation/Foundation.h>
#import "OCEnum.h"

int main(void)
{
    NSAutoreleasePool *pool = \
        [[NSAutoreleasePool alloc] init];
    if (!pool)
        return 1;

    {
        OCEnum *trafficLight = [[[OCEnum alloc]
            initSymbolWithStrings: @"green", @"yellow", @"red", nil]
                autorelease];
        
        assert(0 == [[OCEnum valueOf:[trafficLight green]] unsignedIntValue]);
        assert(1 == [[OCEnum valueOf:[trafficLight yellow]] unsignedIntValue]);
        assert(2 == [[OCEnum valueOf:[trafficLight red]] unsignedIntValue]);

        void *redLight = [trafficLight red];
        assert([OCEnum isEqualBetweenEnum:redLight andEnum:[trafficLight red]]);
        assert(![OCEnum isEqualBetweenEnum:redLight andEnum:[trafficLight green]]);
    }

    {
        OCEnum *fileMode = [[[OCEnum alloc]
            initFlagWithStrings: @"exec", @"write", @"read", nil]
                autorelease];

        assert(1 == [[OCEnum valueOf:[fileMode exec]] unsignedIntValue]);
        assert(2 == [[OCEnum valueOf:[fileMode write]] unsignedIntValue]);
        assert(4 == [[OCEnum valueOf:[fileMode read]] unsignedIntValue]);

        unsigned mode = [[fileMode
            combineFlagsByStrings: @"read", @"exec", nil]
                unsignedIntValue];
        assert(5 == mode);

        mode = [[fileMode
            combineFlagsByStrings: @"read", @"write", @"exec", nil]
                unsignedIntValue];
        assert(7 == mode);

        mode = [[fileMode combineFlagsBySelectors:
            @selector(read), @selector(exec), nil]
                unsignedIntValue];
        assert(5 == mode);

        mode = [[fileMode combineFlagsBySelectors:
            @selector(read), @selector(write), @selector(exec), nil]
                unsignedIntValue];
        assert(7 == mode);
    }

    [pool drain];

    return 0;
}