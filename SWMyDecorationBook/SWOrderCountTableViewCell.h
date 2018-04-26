//
//  SWOrderCountTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^orderCountUpdateBlock)(CGFloat orderCount);

@interface SWOrderCountTableViewCell : UITableViewCell
@property(nonatomic, copy) orderCountUpdateBlock orderCountUpdateBlock;
@end
