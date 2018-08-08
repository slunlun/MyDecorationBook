//
//  NSDate+SWDateExt.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/8.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "NSDate+SWDateExt.h"

@implementation NSDate (SWDateExt)
+ (NSDate *)dateYMD {
    //get seconds since 1970
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

@end
