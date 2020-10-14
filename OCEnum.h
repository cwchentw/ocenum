#pragma once

#import <Foundation/Foundation.h>
#import "OCEnumValue.h"


@interface OCEnum : NSObject {
@private
    NSMutableArray *keys;
    NSMutableDictionary *data;
    NSUUID *uuid;
}

-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
-(NSArray *) values;
-(NSNumber *) combineFlags:(OCEnumValue *)first, ...;
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end