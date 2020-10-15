#pragma once

#import <Foundation/Foundation.h>


@interface OCEnum : NSObject {
@private
<<<<<<< HEAD
    Class enumClass;
=======
    NSMutableArray *keys;
>>>>>>> 4a62f64c5286bc0b2eb8cc73103eba3e3f3fe2bc
    NSMutableDictionary *data;
    NSUUID *uuid;
}

-(OCEnum *) initSymbolWithStrings:(NSString *)first, ...;
-(OCEnum *) initFlagWithStrings:(NSString *)first, ...;
-(void) dealloc;
<<<<<<< HEAD
-(Class) enumClass;
-(NSNumber *) combineFlags:(id)first, ...;
=======
-(NSArray *) values;
-(NSNumber *) combineFlags:(OCEnumValue *)first, ...;
>>>>>>> 4a62f64c5286bc0b2eb8cc73103eba3e3f3fe2bc
-(NSNumber *) combineFlagsByStrings:(NSString *)first, ...;
-(NSNumber *) combineFlagsBySelectors:(SEL)first, ...;
@end