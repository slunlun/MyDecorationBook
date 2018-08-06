//
//  SWSpeechBubble.m
//  CoolPicChat
//
//  Created by Eren on 09/04/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWSpeechBubble.h"
#import "Masonry.h"
#define ICON_WIDTH 30
#define ARROW_WIDTH 60.0f
#define ARROW_HEIGHT 60.0f
#define TOP_MARGIN 25.0f
#define BOTTOM_MARGIN 8.0f
#define RIGHT_MARGIN 5.0f
@implementation SWSpeechBubble
- (instancetype)init {
    if (self = [super init]) {
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
    
//    CGFloat arrowWidth = 70.0f;
//    CGFloat arrowHeight = 70.0f;
//    UIBezierPath *arrowPath2 = [[UIBezierPath alloc] init];
//    [arrowPath2 moveToPoint:CGPointMake((CGRectGetWidth(self.frame) - arrowWidth)/2, 0)];
//    [arrowPath2 addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)/2, arrowHeight + 10)];
//    [arrowPath2 addLineToPoint:CGPointMake((CGRectGetWidth(self.frame) - arrowWidth)/2 + arrowWidth, 0)];
//    [arrowPath2 closePath];
//    [[UIColor greenColor] setStroke];
//    [[UIColor greenColor] setFill];
//    [arrowPath2 stroke];
//    [arrowPath2 fill];
}

- (void)commonInit {

    CGFloat titleLabHeight = 15;
    self.speechTitleLab = [[UILabel alloc] init];
    self.speechTitleLab.textAlignment = NSTextAlignmentCenter;
    self.speechTitleLab.font = [UIFont systemFontOfSize:titleLabHeight];
    [self addSubview:self.speechTitleLab];
    [self.speechTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@15);
    }];
    
    self.speechContentLab = [[UILabel alloc] init];
    CGFloat fontSize = 35.0f;
    self.speechContentLab.font = [UIFont systemFontOfSize:fontSize];
    self.speechContentLab.numberOfLines = 0;
    self.speechContentLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.speechContentLab];
    [self.speechContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.speechTitleLab).offset(15);
    }];
    
    // 添加箭头子view
    UIView *arrowView = [[UIView alloc] init];
    arrowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        make.width.equalTo(@60);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.speechTitleLab.mas_top);
    }];
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(0, 70)];
    [arrowPath addLineToPoint:CGPointMake(30, 0)];
    [arrowPath addLineToPoint:CGPointMake(60, 70)];
    [arrowPath closePath];
    CAShapeLayer *arrowMaskLayer = [[CAShapeLayer alloc] init];
    arrowMaskLayer.path = arrowPath.CGPath;
    arrowView.layer.mask = arrowMaskLayer;
    arrowView.alpha = 0.6;
 
}
@end
