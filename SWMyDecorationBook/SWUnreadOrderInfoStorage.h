//
//  SWUnreadOrderInfoStorage.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/28.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWShoppingItemOrder+CoreDataClass.h"

@interface SWUnreadOrderInfoStorage : NSObject
+ (NSArray *)allUnreadOrderInfos;
+ (void)removeAllOrderInfos;
@end
