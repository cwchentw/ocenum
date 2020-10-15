#pragma once

#import <Foundation/Foundation.h>


@interface OCEnum : NSObject {
@private
    Class enumClass;
    NSMutableArray *keys;
    NSMutableDictionary *data;
    NSUUID *uuid;
}

-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
-(Class) enumClass;
-(NSArray *) values;
-(NSNumber *) combineFlags:(id)first, ...;
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end