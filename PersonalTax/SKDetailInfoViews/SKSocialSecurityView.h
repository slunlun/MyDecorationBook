//
//  SKSocialSecurityView.h
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SKSocialSecurityView : UIView
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSArray<NSArray<NSString *> *>*dataArray;
- (instancetype)initWithDataArray:(NSArray<NSArray<NSString *> *>*)dataArray;
@end

