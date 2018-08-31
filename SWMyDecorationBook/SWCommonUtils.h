//
//  SWCommonUtils.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/29.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWCommonUtils : NSObject
+ (CGFloat)systemNavBarHeight;
+ (NSString *)getExtension:(NSString *)fullpath error:(NSError **)error;
+ (NSString*) getMiMeType:(NSString*)filepath;
@end
