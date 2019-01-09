//
//  SKTaxContext.h
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SKSocialSecurityStrategy.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SKChildStatus) {
    SKChildStatusNONE = 0,
    SKChildStatusOne,
    SKChildStatusTwo,
    SKChildStatusThree,
};

typedef NS_ENUM(NSUInteger, SKAdultEducationStatus) {
    SKAdultEducationStatusNONE = 0,
    SKAdultEducationStatusAcademic,
    SKAdultEducationStatusVocational,
};

typedef NS_ENUM(NSUInteger, SKHousingStatus) {
    SKHousingStatusNONE = 0,
    SKHousingStatusFirstHousingLoan,
    SKHousingStatusRentLeave1,
    SKHousingStatusRentLeave2,
    SKHousingStatusRentLeave3,
};

typedef NS_ENUM(NSUInteger, SKParentsSupportStatus) {
    SKParentsSupportStatusNONE = 0,
    SKParentsSupportStatusNoOnlyChild,
    SKParentsSupportStatusOnlyChild,
};

#define PERSONAL_TAX_LEAVE @"PERSONAL_TAX_LEAVE"
#define TAX_RATE @"TAX_RATE"
#define TAX_QUICK_DISCOUNT @"TAX_QUICK_DISCOUNT"
#define PERSONAL_TAX_COUNT @"PERSONAL_TAX_COUNT"

// 专项扣除modle
@interface SKSpecialDeduction : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat deduction;
@end

@interface SKTaxContext : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong, readonly) SKSocialSecurityStrategy *currentSecurityStrategy;
@property (nonatomic, assign) CGFloat salary;
@property (nonatomic, assign) CGFloat lastSalary;
@property (nonatomic, strong, readonly) NSMutableArray *deductions;
@property (nonatomic, strong, readonly) SKSpecialDeduction *childDeduction;
@property (nonatomic, strong, readonly) SKSpecialDeduction *adultEducationDeduction;
@property (nonatomic, strong, readonly) SKSpecialDeduction *housingDeduction;
@property (nonatomic, strong, readonly) SKSpecialDeduction *parentSupportDeduction;

// 三险一金策略
- (void)updateCurrentSecurityStrategy:(SKSocialSecurityStrategy *)strategy;
- (NSArray<SKSocialSecurityStrategy *> *)allSecurityStrategies;

// 专项扣除
- (void)updateChildDeduction:(SKChildStatus)childStatus;
- (void)updateAdultEducationDeduction:(SKAdultEducationStatus)adultEducationStatus;
- (void)updateHousingDeduction:(SKHousingStatus)housingStatus;
- (void)updateParentsSupportDeduction:(SKParentsSupportStatus)parentSupportStatus;
- (CGFloat)specialDeductionCount;
- (NSArray *)selectedDeductions;

//加载
- (void)loadAllSocialSecurity;

// 清空状态
- (void)cleanUpTaxContext;
- (void)resetSocialSecurityStrageties;

// 计算每个月个人所得税
- (NSArray<NSDictionary *> *)calculatePersonalIncomeTax;
// 计算个人应缴社保及公积金
- (CGFloat)calculatePersonalSocialSecurityAndHousingFund;
- (CGFloat)calculatePersonalED; // 个人养老
- (CGFloat)calculatePersonalMD; // 个人医疗
- (CGFloat)calculatePersonalUE; // 个人失业
- (CGFloat)calculatePersonalHF; // 个人公积金

- (CGFloat)calculateCompanyED;  // 公司养老
- (CGFloat)calculateCompanyMD;  // 公司医疗
- (CGFloat)calculateCompanyUE;  // 公司失业
- (CGFloat)calculateCompanyHF;  // 公司公积金


@end

NS_ASSUME_NONNULL_END
