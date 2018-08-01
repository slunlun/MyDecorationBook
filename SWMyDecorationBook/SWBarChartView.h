//
//  SWBarChartView.h
//  SWBarChart
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWBarChartView : UIView
- (instancetype)initWithFillPercent:(CGFloat)percent;
- (instancetype)initWithFrame:(CGRect)frame fillPercent:(CGFloat)percent;
@end
