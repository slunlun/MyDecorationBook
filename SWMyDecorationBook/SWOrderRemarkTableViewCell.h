//
//  SWOrderRemarkTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/25.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^orderRemarkChangedBlock)(NSString *remark);
@interface SWOrderRemarkTableViewCell : UITableViewCell
- (void)setOrderRemark:(NSString *)orderRemark;
@property(nonatomic, copy) orderRemarkChangedBlock remarkChangeBlock;
@end
