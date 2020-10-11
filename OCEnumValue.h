#pragma once

#import <Foundation/Foundation.h>

@interface OCEnumValue : NSObject {
@private
    NSNumber *value;
    NSUUID *uuid;
}

-(OCEnumValue *) initWithUUID:(NSUUID *)uuid value:(NSNumber *)value;
-(BOOL) isEqualToEnumValue: (OCEnumValue *)enumValue;
-(NSNumber *) value;
@end