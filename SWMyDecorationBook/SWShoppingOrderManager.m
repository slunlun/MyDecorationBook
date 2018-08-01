//
//  SWShoppingOrderManager.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingOrderManager.h"
static SWShoppingOrderManager *sharedObj = nil;

@interface SWShoppingOrderManager()
@end

@implementation SWShoppingOrderManager
+ (instancetype)sharedInstance {
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[SWShoppingOrderManager alloc] init];
    });
    return sharedObj;
}

- (void)bootUp {
    
}

- (void)insertNewOrder:(SWOrder *)shoppingOrder {
    
}

- (void)removeShoppingOrder:(SWOrder *)shoppingOrder {
    
}

- (NSArray *)allOrdersInCategory {
    
}

@end
