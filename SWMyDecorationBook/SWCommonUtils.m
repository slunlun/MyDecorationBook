//
//  SWCommonUtils.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/29.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWCommonUtils.h"
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height

//iPhone_X layout

#define Status_H                 [UIApplication sharedApplication].statusBarFrame.size.height

#define NavBar_H                  44

#define Nav_Height                (Status_H + NavBar_H)

@implementation SWCommonUtils
+ (CGFloat)systemNavBarHeight {
    return Nav_Height;
}
@end
