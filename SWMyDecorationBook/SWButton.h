//
//  SWButton.h
//  SWButton
//
//  Created by Eren (Teng) Shi on 10/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SWButtonLayoutType) {
    SWButtonLayoutTypeImageRight = 1,
    SWButtonLayoutTypeImageTop,
    SWButtonLayoutTypeImageBottom,
    SWButtonLayoutTypeImageLeft,
};

@interface SWButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame buttonType:(SWButtonLayoutType)buttonType;
- (instancetype)initWithButtonType:(SWButtonLayoutType)buttonType;
@end
