//
//  UIView+UIExt.h
//  CoreAnimationDemo
//
//  Created by EShi on 11/3/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(long, UIViewShadowPosition) {
    UIViewShadowPositionTop        = 0x00000001,
    UIViewShadowPositionBottom     = 0x00000002,
    UIViewShadowPositionLeft       = 0x00000004,
    UIViewShadowPositionRight      = 0x00000008,
};

@interface UIView (UIExt)
- (void)cornerRadian:(CGFloat) radian;
- (void)cornerRadian:(CGFloat)radian clipsToBounds:(BOOL) shouldClip;
- (void)borderWidth:(CGFloat) width;
- (void)borderColor:(UIColor *) color;

// Note: This method can not use with set cornerRadian for cornerRadian will cut the border
- (void)addShadow:(UIViewShadowPosition)position color:(UIColor *) color width:(CGFloat)width Opacity:(float) opacity;
- (void)addShadow:(UIViewShadowPosition)position color:(UIColor *) color;

// notification red bubble
- (void)showNotificationBubble;
- (void)dismissNotificationBubble;
@end
