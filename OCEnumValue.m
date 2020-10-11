#import "OCEnumValue.h"

@interface OCEnumValue ()
-(NSUUID *) uuid;
@end

@implementation OCEnumValue
-(OCEnumValue *) initWithUUID:(NSUUID *)_uuid value:(NSNumber *)_value
{
    if (!self)
        return self;

    uuid = _uuid;
    value = _value;

    return self;
}

#define IS_UUID_EQUAL(a, b) [(a).UUIDString isEqualToString: (b).UUIDString]

-(BOOL) isEqualToEnumValue: (OCEnumValue *)enumValue
{
    if (!IS_UUID_EQUAL([self uuid], [enumValue uuid]))
        return NO;

    return [[self value] unsignedIntValue] == 
        [[enumValue value] unsignedIntValue];
}

-(NSNumber *) value
{
    return value;
}

-(NSUUID *) uuid
{
    return uuid;
}
@end