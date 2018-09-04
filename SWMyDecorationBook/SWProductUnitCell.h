//
//  SWProductUnitCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWItemUnit.h"

typedef void(^productUnitUpdateBlock)(SWItemUnit *itemUnit);
typedef void(^productUnitDelteBlock)(SWItemUnit *itemUnit);

@interface SWProductUnitCell : UITableViewCell
@property(nonatomic, copy) productUnitUpdateBlock unitUpdateBlock;
@property(nonatomic, copy) productUnitDelteBlock unitDeleteBlock;

- (void)setModel:(SWItemUnit *)itemUnit;
@end
