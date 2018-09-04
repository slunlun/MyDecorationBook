//
//  SWButton.m
//  SWButton
//
//  Created by Eren (Teng) Shi on 10/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWButton.h"
@interface SWButton ()
@property(nonatomic, assign)SWButtonLayoutType buttonLayoutType;
@end
@implementation SWButton
- (instancetype)initWithFrame:(CGRect)frame buttonType:(SWButtonLayoutType)buttonLayoutType {
    if (self = [super initWithFrame:frame]) {
        _buttonLayoutType = buttonLayoutType;
    }
    return self;
}

- (instancetype)initWithButtonType:(SWButtonLayoutType)buttonLayoutType {
    return [self initWithFrame:CGRectZero buttonType:buttonLayoutType];
}

- (void)drawRect:(CGRect)rect {
    UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
    UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    
    switch (self.buttonLayoutType) {
        case SWButtonLayoutTypeImageRight:
        {
            
            imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width);
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
        }
            break;
        case SWButtonLayoutTypeImageTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height * 0.5, (titleSize.width * 0.5), titleSize.height*0.5, -(titleSize.width * 0.5));
            titleEdgeInsets = UIEdgeInsetsMake(titleSize.height * 0.5 + 15, -imageSize.width *0.5, -titleSize.height * 0.5, imageSize.width *0.5);
        }
            break;
        case SWButtonLayoutTypeImageBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(titleSize.height * 0.5, (titleSize.width * 0.5), -titleSize.height*0.5, -(titleSize.width * 0.5));
            titleEdgeInsets = UIEdgeInsetsMake(-titleSize.height * 0.5, -imageSize.width *0.5, titleSize.height * 0.5, imageSize.width *0.5);
        }
            break;
        default:
            break;
    }
    self.titleEdgeInsets = titleEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end
