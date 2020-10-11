#pragma once

#import <Foundation/Foundation.h>


@interface OCEnum : NSObject {
@private
    NSMutableDictionary *data;
    NSUUID *uuid;
}

+(NSNumber *) valueOf: (void *)enumValue;
+(BOOL) isEqualBetweenEnum: (void *)a andEnum: (void *)b;
-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end