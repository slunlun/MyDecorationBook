//
//  SWSpeechBubble.m
//  CoolPicChat
//
//  Created by Eren on 09/04/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWSpeechBubble.h"

#define ICON_WIDTH 30
#define ARROW_WIDTH 60.0f
#define ARROW_HEIGHT 60.0f
#define TOP_MARGIN 25.0f
#define BOTTOM_MARGIN 8.0f
#define RIGHT_MARGIN 5.0f
@implementation SWSpeechBubble
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 添加箭头
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(CGRectGetWidth(self.frame) - 3*RIGHT_MARGIN, TOP_MARGIN)];
    [arrowPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - RIGHT_MARGIN, (CGRectGetHeight(self.frame) - BOTTOM_MARGIN - TOP_MARGIN)/2 + TOP_MARGIN)];
    [arrowPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - 3*RIGHT_MARGIN, CGRectGetHeight(self.frame) - BOTTOM_MARGIN)];
    arrowPath.lineWidth = 1.5f;
    [[UIColor lightGrayColor] setStroke];
    [arrowPath stroke];
}

- (void)commonInit {
    CGFloat titleLabHeight = 15;
    
    self.speechTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), titleLabHeight)];
    self.speechTitleLab.textAlignment = NSTextAlignmentCenter;
    self.speechTitleLab.font = [UIFont systemFontOfSize:titleLabHeight];
    [self addSubview:self.speechTitleLab];
    
    self.speechContentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabHeight + 5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - titleLabHeight)];
    CGFloat fontSize = CGRectGetHeight(self.bounds) - titleLabHeight;
    self.speechContentLab.font = [UIFont systemFontOfSize:fontSize];
    self.speechContentLab.numberOfLines = 0;
    self.speechContentLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.speechContentLab];
    
   
    
    CGFloat arrowWidth = 70.0f;
    CGFloat arrowHeight = 70.0f;
    UIView *arrow = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - arrowWidth)/2, -arrowHeight - 10, arrowWidth, arrowHeight)];
    arrow.backgroundColor = [UIColor whiteColor];
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(0, arrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(arrowWidth/2, 0)];
    [arrowPath addLineToPoint:CGPointMake(arrowWidth, arrowHeight)];
    [arrowPath closePath];
    CAShapeLayer *arrowMaskLayer = [[CAShapeLayer alloc] init];
    arrowMaskLayer.path = arrowPath.CGPath;
    arrow.layer.mask = arrowMaskLayer;
    arrow.alpha = 0.7;
    [self addSubview:arrow];
}
@end
