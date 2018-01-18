//
//  SWMarketViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketItem.h"
typedef void(^marketInfoUpdateBlock)(SWMarketItem *marketItem);

@interface SWMarketViewController : UIViewController
@property(nonatomic, strong) SWMarketItem *marketItem;
@property(nonatomic, copy) marketInfoUpdateBlock updateBlock;
@end
