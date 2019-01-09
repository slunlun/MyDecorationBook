//
//  SKDetailInfoVC.h
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKDetailInfoVC : UIViewController
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSString *monthStr;
@property (nonatomic, strong)NSString *incomeStr;
@end

NS_ASSUME_NONNULL_END
