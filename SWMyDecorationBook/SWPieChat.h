//
//  SWPieChat.h
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SWPieChatSegment : NSObject
- (instancetype)initWithValue:(CGFloat)value title:(NSString *)title color:(UIColor *)color;
@property(nonatomic, strong) UIColor *segmentColor;
@property(nonatomic, strong) NSString *segmentTitle;
@property(nonatomic, assign) CGFloat segmentValue;
@property(nonatomic, assign) CGFloat segmentRatio;
@end

@class SWPieChat;
@protocol SWPieChatDelegate<NSObject>
@optional
- (void)pieChatDidShow:(SWPieChat *)pieChat defaultSegment:(SWPieChatSegment *)pieChatSegment;
- (void)pieChat:(SWPieChat *)pieChat didSelectSegment:(SWPieChatSegment *)pieChatSegment;
@end

@interface SWPieChat : UIView
@property(nonatomic, weak) id<SWPieChatDelegate> delegate;
- (void)updateProportions:(NSArray<SWPieChatSegment *>*)proportions;
@end


