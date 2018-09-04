//
//  SWSystemHeaderView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/31.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWSystemHeaderView;
@protocol SWSystemHeaderViewDelegate<NSObject>
- (void)systemHeaderViewdidSelectedSystemConfigBtn:(SWSystemHeaderView *)systemHeaderView;
@end

@interface SWSystemHeaderView : UIView
- (void)updateCostSummary:(CGFloat)totalCost budget:(CGFloat)budget;
@property(nonatomic, assign) id<SWSystemHeaderViewDelegate>delegate;
@end
