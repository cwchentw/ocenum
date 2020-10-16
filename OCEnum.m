#import <stdarg.h>
#import "OCEnum.h"


@interface OCEnum ()
-(NSMutableDictionary *) data;
@end

@implementation OCEnum
static id enum_value(id self, SEL cmd);

-(instancetype) initSymbolWithStrings:(NSString *)first, ...
{
    if (!self)
        return self;

    self = [super init];

    enumClass = nil;
    keys = nil;
    data = nil;

    enumClass = [self enumClass];
    if (!enumClass) {
        [self release];
        return nil;
    }

    keys = [[NSMutableArray alloc] init];
    if (!keys) {
        [self release];
        return nil;
    }

    data = [[NSMutableDictionary alloc] init];
    if (!data) {
        [self release];
        return nil;
    }

    id _first = [[objc_getClass(class_getName(enumClass)) alloc]
        initWithValue:[NSNumber numberWithUnsignedInt: 0]];
    if (!_first) {
        [self release];
        return nil;
    }

    [keys addObject:first];
    [data setObject:_first forKey:first];

    va_list args;
    va_start(args, first);

    unsigned i = 1;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        id _arg = [[objc_getClass(class_getName(enumClass)) alloc]
            initWithValue:[NSNumber numberWithUnsignedInt:i]];
        if (!_arg) {
            [self release];
            va_end(args);
            return nil;
        }

        [keys addObject:arg];
        [data setObject:_arg forKey:arg];

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

static id enum_value(id self, SEL cmd)
{
    OCEnum *_self = self;

    NSMutableDictionary *_data = [_self data];

    id e = [_data valueForKey:NSStringFromSelector(cmd)];

    return e;
}

-(instancetype) initFlagWithStrings:(NSString *)first, ...
{
    if (!self)
        return self;

    self = [super init];

    enumClass = nil;
    keys = nil;
    data = nil;

    enumClass = [self enumClass];

    keys = [[NSMutableArray alloc] init];
    if (!keys) {
        [self release];
        return nil;
    }

    data = [[NSMutableDictionary alloc] init];
    if (!data) {
        [self release];
        return nil;
    }

    id _first = [[objc_getClass(class_getName(enumClass)) alloc]
        initWithValue:[NSNumber numberWithUnsignedInt: 1]];
    if (!_first) {
        [self release];
        return nil;
    }

    [keys addObject:first];
    [data setObject:_first forKey:first];

    va_list args;
    va_start(args, first);

    unsigned i = 2;
    id arg = nil;
    while ((arg = va_arg(args, id))) {
        id _arg =[[objc_getClass(class_getName(enumClass))  alloc]
            initWithValue:[NSNumber numberWithUnsignedInt:i]];
        if (!_arg) {
            [self release];
            va_end(args);
            return nil;
        }

        [keys addObject:arg];
        [data setObject:_arg forKey:arg];

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
    [enumClass release];  /* FIXME: Check it later. */
    [keys release];
    [data release];
    [super dealloc];
}

static id enum_value_init(id self, SEL cmd, NSNumber *value);
static id enum_value_value(id self, SEL cmd);
static BOOL enum_value_is_equal_to(id self, SEL cmd, id other);

-(Class) enumClass
{
    /* Singleton. */
    if (enumClass)
        return enumClass;

    Class klass = objc_allocateClassPair(
        [NSObject class],
        [[NSString stringWithFormat:@"OCEnumValue%@",
            [[NSUUID UUID] UUIDString]] cString],
        0);

    class_addIvar(klass,
        "value",
        sizeof(NSNumber),
        log2(sizeof(NSNumber *)),
        "@");

    class_addMethod(klass,
        NSSelectorFromString(@"initWithValue:"),
        (IMP)enum_value_init,
        "@@:@");

    class_addMethod(klass,
        NSSelectorFromString(@"value"),
        (IMP)enum_value_value,
        "@@:");

    class_addMethod(klass,
        NSSelectorFromString(@"isEqualToEnumValue:"),
        (IMP)enum_value_is_equal_to,
        "@@:@");

    objc_registerClassPair(klass);

    return klass;
}

static id enum_value_init(id self, SEL cmd, NSNumber *value)
{
    Ivar v = class_getInstanceVariable([self class], "value");

    object_setIvar(self, v, value);

    return self;
}

static id enum_value_value(id self, SEL cmd)
{
    Ivar v = class_getInstanceVariable([self class], "value");

    return object_getIvar(self, v);
}

static BOOL enum_value_is_equal_to(id self, SEL cmd, id other)
{
    if (![self isMemberOfClass:[other class]])
        return NO;

    return [[self value] unsignedIntValue]
        == [[other value] unsignedIntValue];
}

-(NSArray *) values
{
    NSMutableArray *arr = \
        [[NSMutableArray alloc] init];
    if (!arr)
        return nil;

    for (NSString *k in keys)
        [arr addObject:[data valueForKey:k]];

    return [NSArray arrayWithArray:arr];
}

-(NSNumber *) combineFlags:(id)first, ...
{
    unsigned result = 0;

    result |= [enum_value_value(first, @selector(value))
        unsignedIntValue];

    va_list args;
    va_start(args, first);

    id arg = nil;
    while ((arg = va_arg(args, id))) {
        result |= [enum_value_value(arg, @selector(value))
            unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...
{
    unsigned result = 0;
    id e = nil;
    
    e = [data valueForKey:first];
    if (!e)
        return nil;

    result |= [enum_value_value(e, @selector(value))
        unsignedIntValue];

    va_list args;
    va_start(args, first);

    id arg = nil;
    while ((arg = va_arg(args, id))) {
        e = [data valueForKey:arg];
        if (!e) {
            va_end(args);
            return nil;
        }

        result |= [enum_value_value(e, @selector(value))
            unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...
{
    unsigned result = 0;
    id e = nil;
    
    e = [data valueForKey:NSStringFromSelector(first)];
    if (!e)
        return nil;

    result |= [enum_value_value(e, @selector(value))
        unsignedIntValue];

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

        result |= [enum_value_value(e, @selector(value))
            unsignedIntValue];
    }

    va_end(args);

    return [NSNumber numberWithUnsignedInt:result];
}

-(NSMutableDictionary *) data
{
    return data;
}
@end
