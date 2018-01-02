//
//  SWMarketHeaderView.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/2/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketItem.h"

typedef void(^marketHeaderActionBlock)(SWMarketItem *);
@interface SWMarketHeaderView : UITableViewHeaderFooterView
@property(nonatomic, strong) SWMarketItem *markItem;
@property(nonatomic, copy) marketHeaderActionBlock actionBlock;
@end
