//
//  SKCityChooseViewController.h
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTaxContext.h"
#import "SKCityTaxPaymentRatioDetailViewController.h"

typedef void(^cityChooseCompletedBlock)(NSString *cityName);

NS_ASSUME_NONNULL_BEGIN

@interface SKCityChooseViewController : UIViewController

@property (nonatomic, copy) cityChooseCompletedBlock chooseCompletedBlock;

@end

NS_ASSUME_NONNULL_END
