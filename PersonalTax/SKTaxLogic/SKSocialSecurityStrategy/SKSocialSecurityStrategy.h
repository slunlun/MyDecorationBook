//
//  SKSocialSecurityStrategy.h
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKSocialSecurityStrategy : NSObject
@property (nonatomic, strong, readonly) NSString *SS_ID;
@property (nonatomic, strong, readonly) NSString *SS_TITLE;

@property (nonatomic, strong) NSNumber *P_ED; // 养老
@property (nonatomic, strong) NSNumber *P_MD; // 医疗
@property (nonatomic, strong) NSNumber *P_UE; // 失业
@property (nonatomic, strong) NSNumber *P_HF; // 公积金

@property (nonatomic, strong) NSNumber *C_ED;
@property (nonatomic, strong) NSNumber *C_MD;
@property (nonatomic, strong) NSNumber *C_UE;
@property (nonatomic, strong) NSNumber *C_HF;


@property (nonatomic, strong) NSNumber *MAX_SS_BASELINE;
@property (nonatomic, strong) NSNumber *MAX_PF_BASELINE;


@property (nonatomic, assign) NSInteger testNu;

- (CGFloat)calculateCompanyPaied:(CGFloat)salary;
- (CGFloat)calculateCompanyED:(CGFloat)salary;
- (CGFloat)calculateCompanyMD:(CGFloat)salary;
- (CGFloat)calculateCompanyUE:(CGFloat)salary;
- (CGFloat)calculateCompanyHF:(CGFloat)salary;

- (CGFloat)calculatePersonalPaied:(CGFloat)salary;
- (CGFloat)calculatePersonalED:(CGFloat)salary;
- (CGFloat)calculatePersonalMD:(CGFloat)salary;
- (CGFloat)calculatePersonalUE:(CGFloat)salary;
- (CGFloat)calculatePersonalHF:(CGFloat)salary;
- (CGFloat)calculateTotaolPaied:(CGFloat)salary;

- (NSDictionary *)convertToDictionary;
@end

NS_ASSUME_NONNULL_END
