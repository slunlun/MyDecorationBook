//
//  SWUserTutorialManager.h
//  SWSpotLightView
//
//  Created by Eren on 2018/8/22.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWTutorialNode : NSObject
- (instancetype)initWithPoint:(CGPoint)point radius:(CGFloat)radius text:(NSString *)text;
- (instancetype)initWithPoint:(CGPoint)point radius:(CGFloat)radius view:(UIView *)view;
@property(nonatomic, assign) CGPoint spotlightPoint;
@property(nonatomic, assign) CGFloat spotlightRadius;
@property(nonatomic, strong) NSString *tutorialText;
@property(nonatomic, strong) UIView *tutorialView;
@end



@interface SWUserTutorialManager : NSObject
+ (instancetype)sharedInstance;
- (void)setUpTutorialViewWithNodes:(NSArray<SWTutorialNode *> *)tutorialNodes inView:(UIView *)view;
@end
