
//
//  UIView+UIExt.m
//  CoreAnimationDemo
//
//  Created by EShi on 11/3/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "UIView+UIExt.h"

#define DEFAULT_SHADOW_WIDTH 3
#define DEFAULT_SHADOW_OPACITY 0.2f

@implementation UIView (UIExt)
- (void) cornerRadian:(CGFloat) radian
{
    [self cornerRadian:radian clipsToBounds:YES];
}

- (void)cornerRadian:(CGFloat)radian clipsToBounds:(BOOL) shouldClip
{
    [self.layer setCornerRadius:radian];
    self.clipsToBounds = shouldClip;
}

- (void)borderWidth:(CGFloat) width
{
    [self.layer setBorderWidth:width];
}

- (void)borderColor:(UIColor *) color
{
    [self.layer setBorderColor:color.CGColor];
}

- (void)addShadow:(UIViewShadowPosition)position color:(UIColor *) color
{
    [self addShadow:position color:color width:DEFAULT_SHADOW_WIDTH Opacity:DEFAULT_SHADOW_OPACITY];
}

#define redBubbleTag 13524
- (void)showNotificationBubble {
#define redBubbleSize 8.0f
    UIView *redBubbleView = [[UIView alloc] init];
    redBubbleView.tag = redBubbleTag;
    redBubbleView.layer.backgroundColor = [UIColor redColor].CGColor;
    [redBubbleView cornerRadian:redBubbleSize/2];
    redBubbleView.frame = CGRectMake(self.frame.size.width - redBubbleSize/2 - 5, -redBubbleSize/2 + 2 , redBubbleSize, redBubbleSize);
    [self addSubview:redBubbleView];
}
- (void)dismissNotificationBubble {
    UIView *redBubbleView = [self viewWithTag:redBubbleTag];
    [redBubbleView removeFromSuperview];
}

- (void)addShadow:(UIViewShadowPosition)position color:(UIColor *) color width:(CGFloat)width Opacity:(float) opacity
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = 1.0f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    
    if (position & UIViewShadowPositionTop)     [self addShadowTopPath:shadowPath pathWidth:width];
    if (position & UIViewShadowPositionBottom)  [self addShadowBottomPath:shadowPath pathWidth:width];
    if (position & UIViewShadowPositionLeft)    [self addShadowLeftPath:shadowPath pathWidth:width];
    if (position & UIViewShadowPositionRight)   [self addShadowRightPath:shadowPath pathWidth:width];
    
    [self drawShadow:shadowPath];
}


- (UIBezierPath *)addShadowTopPath:(UIBezierPath *)path pathWidth:(CGFloat)pathWidth

{
    CGPoint p1 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y - pathWidth);
    CGPoint p2 = CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y - pathWidth);
    CGPoint p3 = CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y);
    CGPoint p4 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    
    return path;
}

- (UIBezierPath *)addShadowBottomPath:(UIBezierPath *)path pathWidth:(CGFloat)pathWidth
{
    CGPoint p1 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height);
    CGPoint p2 = CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height);
    CGPoint p3 = CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height + pathWidth);
    CGPoint p4 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height + pathWidth);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    return path;
    
}

- (UIBezierPath *)addShadowLeftPath:(UIBezierPath *)path pathWidth:(CGFloat)pathWidth
{
    CGPoint p1 = CGPointMake(self.bounds.origin.x - pathWidth, self.bounds.origin.y);
    CGPoint p2 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y);
    CGPoint p3 = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height);
    CGPoint p4 = CGPointMake(self.bounds.origin.x - pathWidth, self.bounds.origin.y + self.bounds.size.height);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    return path;
    
}

- (UIBezierPath *)addShadowRightPath:(UIBezierPath *)path pathWidth:(CGFloat)pathWidth
{
    CGPoint p1 = CGPointMake(self.bounds.size.width + self.bounds.origin.x, self.bounds.origin.y);
    CGPoint p2 = CGPointMake(self.bounds.size.width + self.bounds.origin.x + pathWidth, self.bounds.origin.y);
    CGPoint p3 = CGPointMake(self.bounds.size.width + self.bounds.origin.x + pathWidth, self.bounds.origin.y + self.bounds.size.height);
    CGPoint p4 = CGPointMake(self.bounds.size.width + self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    return path;
}

- (void)drawShadow:(UIBezierPath *)path
{
    self.layer.shadowPath = path.CGPath;
}
@end
