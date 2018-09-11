//
//  SWSpotlightView.h
//  SWSpotLightView
//
//  Created by Eren on 2018/8/15.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWSpotlightView;

@protocol SWSpotlightViewDelegate<NSObject>
- (void)spotlightViewDidTapped:(SWSpotlightView *)spotlightView;
@end

@interface SWSpotlightView : UIView
@property(nonatomic, assign) CGPoint spolightPoint;
@property(nonatomic, assign) CGFloat spolightRadius;
@property(nonatomic, strong) NSString *spotlightText;
@property(nonatomic, strong) UIView *spotlingtView;
@property(nonatomic, weak) id<SWSpotlightViewDelegate> delegate;

- (void)updateSpotlightView;
@end
