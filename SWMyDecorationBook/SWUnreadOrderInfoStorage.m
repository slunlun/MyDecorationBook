//
//  SWUnreadOrderInfoStorage.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/28.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWUnreadOrderInfoStorage.h"
#import "MagicalRecord.h"
#import "SWUnreadOrderMsg+CoreDataClass.h"
@implementation SWUnreadOrderInfoStorage
+ (NSArray *)allUnreadOrderInfos {
    __block NSArray *retArray = nil;
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        retArray = [SWUnreadOrderMsg MR_findAllInContext:localContext];
    }];
    return retArray;
}

+ (void)removeAllOrderInfos {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        [SWUnreadOrderMsg MR_truncateAll];
    }];
}

@end
