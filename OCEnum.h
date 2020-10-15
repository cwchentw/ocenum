#pragma once

#import <Foundation/Foundation.h>


@interface OCEnum : NSObject {
@private
    Class enumClass;
    NSMutableDictionary *data;
    NSUUID *uuid;
}

-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
-(Class) enumClass;
-(NSNumber *) combineFlags:(id)first, ...;
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end