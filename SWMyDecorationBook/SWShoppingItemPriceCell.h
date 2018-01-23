//
//  SWShoppingItemPriceCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWItemUnit.h"
@class SWShoppingItemPriceCell;
typedef void(^priceUnitActionBlock)(SWShoppingItemPriceCell *cell);

@interface SWShoppingItemPriceCell : UITableViewCell
@property(nonatomic, strong) UILabel *priceUnitLab;
@property(nonatomic, copy) priceUnitActionBlock priceUnitActionBlock;
@property(nonatomic, strong) NSString *priceUnitStr;
@property(nonatomic, strong) UITextField *priceTextField;
@end
