//
//  SKBaseFormView.h
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKBaseFormView : UIView
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSArray<NSArray<NSString *> *>*dataArray;
- (instancetype)initWithDataArray:(NSArray<NSArray<NSString *> *>*)dataArray;
@end

NS_ASSUME_NONNULL_END
