//
//  SKAllResultViewController.h
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SKAllResultViewController : UIViewController
@property(nonatomic, strong)NSArray<NSArray<NSString *>*> *dataArray;
@property(nonatomic, strong)NSArray<NSDictionary *>*taxInfoDataArray;
@end


