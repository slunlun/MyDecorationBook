//
//  SWBudgetCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^budgetChanged)(NSString* totalBudget);
@interface SWBudgetCell : UITableViewCell
- (void)updateBudget:(NSString *)budget;
@property(nonatomic, copy)budgetChanged budgetUpdate;
@end
