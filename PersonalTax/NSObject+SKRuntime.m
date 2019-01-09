//
//  NSObject+SKRuntime.m
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "NSObject+SKRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (SKRuntime)
- (NSDictionary *)getAllPropertiesAndVaules {
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for ( int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) {
            [propsDic setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return propsDic;
}
@end
