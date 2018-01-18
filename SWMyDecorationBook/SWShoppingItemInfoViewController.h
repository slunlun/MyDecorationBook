//
//  SWShoppingItemInfoViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"

typedef void(^shoppingItemUpdateBlock)(SWProductItem *shoppingItem);
@interface SWShoppingItemInfoViewController : UIViewController
@property(nonatomic, strong) SWProductItem *shoppingItem;
@end
