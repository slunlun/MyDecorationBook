//
//  SWShoppingItemInfoViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"
#import "SWMarketItem.h"

typedef void(^shoppingItemUpdateBlock)(SWProductItem *shoppingItem);
@interface SWShoppingItemInfoViewController : UIViewController
- (instancetype)initWithProductItem:(SWProductItem *)productItem inMarket:(SWMarketItem *)market;
@property(nonatomic, strong) SWProductItem *shoppingItem;
@property(nonatomic, strong) SWMarketItem *marketItem;
@end
