#import <stdarg.h>
#import "OCEnum.h"

typedef struct enum_t enum_t;

struct enum_t {
    unsigned value;
    NSUUID *uuid;
};


@interface OCEnum ()
-(NSMutableDictionary *) data;
-(NSUUID *) uuid;
@end

static enum_t * enum_value(id self, SEL cmd)
{
    OCEnum *_self = self;

    NSMutableDictionary *_data = [_self data];

    OCEnumValue *e = [_data valueForKey:NSStringFromSelector(cmd)];

    return e;
}

@implementation OCEnum
-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...
{
    if (!self)
        return self;

    self = [super init];

    uuid = [NSUUID UUID];

    data = [[NSMutableDictionary alloc] init];
    if (!data) {
        [self release];
        return nil;
    }

    OCEnumValue *_first = [[OCEnumValue alloc]
        initWithUUID:[self uuid] value:[NSNumber numberWithUnsignedInt: 0]];
    if (!_first) {
        [self release];
        return nil;
    }

    [data setObject:_first forKey: first];

    va_list args;
    va_start(args, first);

    unsigned i = 1;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        OCEnumValue *_arg = [[OCEnumValue alloc]
            initWithUUID:[self uuid] value:[NSNumber numberWithUnsignedInt:i]];
        if (!_arg) {
            [self release];
            va_end(args);
            return nil;
        }
        [data setObject:_arg forKey: arg];
        ++i;
    }

    for (NSString *key in [data allKeys]) {
        class_addMethod([self class],
            NSSelectorFromString(key),
            (IMP)enum_value,
            "@@:");
    }

    va_end(args);

    return self;
}

-(OCEnum *) initFlagWithStrings:(NSString *)first, ...
{
    if (!self)
        return self;

    self = [super init];

    uuid = [NSUUID UUID];

    data = [[NSMutableDictionary alloc] init];
    if (!data) {
        [self release];
        return nil;
    }

    OCEnumValue *_first = [[OCEnumValue alloc]
        initWithUUID:[self uuid] value:[NSNumber numberWithUnsignedInt: 1]];
    if (!_first) {
        [self release];
        return nil;
    }

    [data setObject:_first forKey: first];

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        OCEnumValue *_arg =[[OCEnumValue alloc]
            initWithUUID:[self uuid] value:[NSNumber numberWithUnsignedInt:i]];
        if (!_arg) {
            [self release];
            va_end(args);
            return nil;
        }
        [data setObject:_arg forKey: arg];
        i <<= 1;
    }

    for (NSString *key in [data allKeys]) {
        class_addMethod([self class],
            NSSelectorFromString(key),
            (IMP)enum_value,
            "@@:");
    }

    va_end(args);

    return self;
}

-(void) dealloc
{
    [data release];
    [super dealloc];
}

-(NSNumber *) combineFlags:(OCEnumValue *)first, ...
{
    unsigned result = 0;
    OCEnumValue *e = nil;

    e = first;
    result |= [[e value] unsignedIntValue];

    va_list args;
    va_start(args, first);

    id arg = nil;
    while ((arg = va_arg(args, id))) {
        e = arg;
        result |= [[e value] unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...
{
    unsigned result = 0;
    OCEnumValue *e = nil;
    
    e = [data valueForKey:first];
    if (!e)
        return nil;

    result |= [[e value] unsignedIntValue];

    va_list args;
    va_start(args, first);

    id arg = nil;
    while ((arg = va_arg(args, id))) {
        e = [data valueForKey:arg];
        if (!e) {
            va_end(args);
            return nil;
        }

        result |= [[e value] unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...
{
    unsigned result = 0;
    OCEnumValue *e = nil;
    
    e = [data valueForKey:NSStringFromSelector(first)];
    if (!e)
        return nil;

    result |= [[e value] unsignedIntValue];

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        SEL _arg = arg;
        e = [data valueForKey:NSStringFromSelector(_arg)];
        if (!e) {
            va_end(args);
            return nil;
        }

        result |= [[e value] unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSMutableDictionary *) data
{
    return data;
}

-(NSUUID *) uuid;
{
    return uuid;
}
@end