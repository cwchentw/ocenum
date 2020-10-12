#pragma once

#import <Foundation/Foundation.h>
#import "OCEnumValue.h"


@interface OCEnum : NSObject {
@private
    NSMutableDictionary *data;
    NSUUID *uuid;
}

-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
-(NSNumber *) combineFlags:(OCEnumValue *)first, ...;
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end