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

    enum_t *e = [[_data valueForKey:NSStringFromSelector(cmd)] pointerValue];

    return e;
}

@implementation OCEnum
+(NSNumber *) valueOf: (void *)enumValue
{
    enum_t *e = (enum_t *)enumValue;
    return [NSNumber numberWithUnsignedInt:e->value];
}

#define IS_UUID_EQUAL(a, b) [(a).UUIDString isEqualToString: (b).UUIDString]

+(BOOL) isEqualBetweenEnum: (void *)a andEnum: (void *)b
{
    enum_t *_a = (enum_t *)a;
    enum_t *_b = (enum_t *)b;

    if (!(IS_UUID_EQUAL(_a->uuid, _b->uuid)))
        return NO;

    return _a->value == _b->value;
}

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

    enum_t *_first = malloc(sizeof(enum_t));
    if (!_first) {
        [data release];
        [self release];
        return nil;
    }

    _first->value = 0;
    _first->uuid = [self uuid];

    [data setObject:[NSValue valueWithPointer:_first] forKey: first];

    va_list args;
    va_start(args, first);

    unsigned i = 1;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        enum_t *_arg = malloc(sizeof(enum_t));
        if (!_arg) {
            va_end(args);
            for (NSString *key in [data allKeys]) {
                NSValue *v = [data valueForKey:key];
                enum_t *e = [v pointerValue];
                free(e);
                [v release];
            }
            [data release];
            [self release];
            return nil;
        }
        _arg->value = i;
        _arg->uuid = [self uuid];
        [data setObject:[NSValue valueWithPointer:_arg] forKey: arg];
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

    enum_t *_first = malloc(sizeof(enum_t));
    if (!_first) {
        [data release];
        [self release];
        return nil;
    }

    _first->value = 1;
    _first->uuid = [self uuid];

    [data setObject:[NSValue valueWithPointer:_first] forKey: first];

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        enum_t *_arg = malloc(sizeof(enum_t));
        if (!_arg) {
            va_end(args);
            for (NSString *key in [data allKeys]) {
                NSValue *v = [data valueForKey:key];
                enum_t *e = [v pointerValue];
                free(e);
                [v release];
            }
            [data release];
            [self release];
            return nil;
        }
        _arg->value = i;
        _arg->uuid = [self uuid];
        [data setObject:[NSValue valueWithPointer:_arg] forKey: arg];
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
    for (NSString *key in [data allKeys]) {
        NSValue *v = [data valueForKey:key];
        enum_t *e = [v pointerValue];
        free(e);
    }

    [data release];
    [super dealloc];
}

-(unsigned) combineFlagsByStrings:(NSString *)first, ...
{
    unsigned result = 0;
    enum_t *e = NULL;
    
    e = [[data valueForKey:first] pointerValue];
    result |= e->value;

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        e = [[data valueForKey:arg] pointerValue];
        result |= e->value;
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(unsigned) combineFlagsBySelectors:(SEL)first, ...
{
    unsigned result = 0;
    enum_t *e = NULL;
    
    e = [[data valueForKey:NSStringFromSelector(first)] pointerValue];
    result |= e->value;

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        SEL _arg = arg;
        e = [[data valueForKey:NSStringFromSelector(_arg)] pointerValue];
        result |= e->value;
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