//
//  SKCityTaxPaymentRatioDetailViewController.h
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/28.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTaxContext.h"

typedef void(^saveButtonClickedBlock)(NSString *cityName);

NS_ASSUME_NONNULL_BEGIN

@interface SKCityTaxPaymentRatioDetailViewController : UIViewController

@property (nonatomic,copy) saveButtonClickedBlock saveButtonClickedBlock;

-(instancetype)initWithStragetyModel:(SKSocialSecurityStrategy *)strategyModel;

@end

NS_ASSUME_NONNULL_END
