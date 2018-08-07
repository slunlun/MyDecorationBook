//
//  SWBarChartView.m
//  SWBarChart
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWBarChartView.h"
#import "HexColor.h"

@interface SWBarChartView()<CAAnimationDelegate>
@property(nonatomic, assign) CGFloat fillPercent;
@property(nonatomic, strong) CALayer *barChartLayer;
@end

@implementation SWBarChartView

- (instancetype)initWithFillPercent:(CGFloat)percent {
    if (self = [super init]) {
        _fillPercent = percent;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame fillPercent:(CGFloat)percent {
    if (self = [super initWithFrame:frame]) {
        _fillPercent = percent;
    }
    return self;
}

- (void)updateChartView:(CGFloat) percent {
    [_barChartLayer removeFromSuperlayer];
    _fillPercent = percent;
    
#define BAR_CHART_MARGIN 3.0f
    UIBezierPath *barChartPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:3.0];
    [barChartPath closePath];
    CAShapeLayer *barChartLayer = [[CAShapeLayer alloc] init];
    barChartLayer.path = barChartPath.CGPath;
    barChartLayer.fillColor = [UIColor colorWithHexString:@"#C8E7EF"].CGColor;
    _barChartLayer = barChartLayer;
    [self.layer addSublayer:barChartLayer];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = barChartPath.CGPath;
    maskLayer.strokeEnd = 0;
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.lineWidth =  barChartPath.lineWidth;
    maskLayer.fillColor = [UIColor redColor].CGColor;
    barChartLayer.mask = maskLayer; // 透明遮罩，不透明显示
    
    // 添加动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:self.fillPercent];
    scaleAnimation.duration = 0.8f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [maskLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
   
}



@end
