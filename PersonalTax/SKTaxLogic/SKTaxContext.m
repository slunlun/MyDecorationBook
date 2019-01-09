//
//  SKTaxContext.m
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKTaxContext.h"


// 三险一金plist的key
#define ID @"SS_ID"
#define TITLE @"SS_TITLE"
#define P_ED @"P_ED"        // 个人养老保险比例
#define P_MD @"P_MD"        // 个人医疗保险比例
#define P_UE @"P_UE"        // 个人失业保险比例
#define P_PF @"P_HF"        // 个人公积金保险比例
#define C_ED @"C_ED"        // 公司养老保险比例
#define C_MD @"C_MD"        // 公司医疗保险比例
#define C_UE @"C_UE"        // 公司失业保险比例
#define C_PF @"C_HF"        // 公司公积金保险比例
#define MAX_SS_BASELINE @"MAX_SS_BASELINE"  // 社保最高基数
#define MAX_PF_BASELINE @"MAX_PF_BASELINE"  // 公积金最高基数

// 个税预扣率表的key
#define TAX_LEAVE_1 @"TAX_LEAVE_1"
#define TAX_LEAVE_2 @"TAX_LEAVE_2"
#define TAX_LEAVE_3 @"TAX_LEAVE_3"
#define TAX_LEAVE_4 @"TAX_LEAVE_4"
#define TAX_LEAVE_5 @"TAX_LEAVE_5"
#define TAX_LEAVE_6 @"TAX_LEAVE_6"
#define TAX_LEAVE_7 @"TAX_LEAVE_7"


// 个人免税额
#define PERSONAL_TAX_FREE 5000.0f

@implementation SKSpecialDeduction
@end

@interface SKTaxContext()
@property (nonatomic, strong) NSMutableArray<SKSocialSecurityStrategy *> *socialSecurityStrategies;
@property (nonatomic, strong, readwrite) SKSocialSecurityStrategy *currentSecurityStrategy;
@property (nonatomic, strong, readwrite) NSMutableArray *deductions;
@property (nonatomic, strong) NSDictionary *personalTaxRateTable;
@property (nonatomic, strong, readwrite) SKSpecialDeduction *childDeduction;
@property (nonatomic, strong, readwrite) SKSpecialDeduction *adultEducationDeduction;
@property (nonatomic, strong, readwrite) SKSpecialDeduction *housingDeduction;
@property (nonatomic, strong, readwrite) SKSpecialDeduction *parentSupportDeduction;
@end

@implementation SKTaxContext
+ (instancetype)sharedInstance {
    static SKTaxContext *sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[SKTaxContext alloc] init];
    });
    return sharedObj;
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self loadAllSocialSecurity];
        _childDeduction = [[SKSpecialDeduction alloc] init];
        _childDeduction.title = @"子女教育";
        _childDeduction.deduction = 0.0f;
        
        _adultEducationDeduction = [[SKSpecialDeduction alloc] init];
        _adultEducationDeduction.title = @"继续教育";
        _adultEducationDeduction.deduction = 0.0f;
        
        _housingDeduction = [[SKSpecialDeduction alloc] init];
        _housingDeduction.title = @"住房情况";
        _housingDeduction.deduction = 0.0f;
        
        _parentSupportDeduction = [[SKSpecialDeduction alloc] init];
        _parentSupportDeduction.title = @"赡养老人";
        _parentSupportDeduction.deduction = 0.0f;
    }
    return self;
}

#pragma mark - social security
- (void)loadAllSocialSecurity {
    NSMutableArray *sandBoxDataArray = [[NSMutableArray alloc]initWithContentsOfFile:[self socialSecurityPlistPath]];
    if (sandBoxDataArray ==nil) { // 程序第一次启动时，以bundle中的plist 为模板，设置document 目录下的 SKSocialSecurity.plist
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"SKSocialSecurity" ofType:@"plist"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        [dataArray writeToFile:[self socialSecurityPlistPath] atomically:YES];
        sandBoxDataArray = [[NSMutableArray alloc]initWithContentsOfFile:[self socialSecurityPlistPath]];
    }
    
   
    [sandBoxDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *strategyDict = (NSDictionary *)obj;
        SKSocialSecurityStrategy *ss = [[SKSocialSecurityStrategy alloc] init];
        [ss setValuesForKeysWithDictionary:strategyDict];
        [self.socialSecurityStrategies addObject:ss];
    }];
    self.currentSecurityStrategy = self.socialSecurityStrategies.firstObject;  // 第一个三险一金策略为默认项
}

- (NSArray<SKSocialSecurityStrategy *> *)allSecurityStrategies {
    return [self.socialSecurityStrategies copy];
}

- (void)updateCurrentSecurityStrategy:(SKSocialSecurityStrategy *)strategy {
    self.currentSecurityStrategy = strategy;
    [self.socialSecurityStrategies removeObject:strategy];
    [self.socialSecurityStrategies insertObject:strategy atIndex:0];
    [self updateSocialSecurityPlist];
}

- (void)updateSocialSecurityPlist {
    NSString *plistPath = [self socialSecurityPlistPath];
 
    NSMutableArray *dataArray = [NSMutableArray array];
    for (SKSocialSecurityStrategy *ss in self.socialSecurityStrategies) {
        NSDictionary *dict = [ss convertToDictionary];
        [dataArray addObject:dict];
    }
    [dataArray writeToFile:plistPath atomically:YES];
}

- (NSString *)socialSecurityPlistPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePatch = [path stringByAppendingPathComponent:@"SKSocialSecurity.plist"];
    return filePatch;
}

#pragma mark -  专项扣除
- (void)updateChildDeduction:(SKChildStatus)childStatus {
    switch (childStatus) {
        case SKChildStatusOne:
        {
            self.childDeduction.deduction = 1000.0f;
        }
            break;
        case SKChildStatusTwo:
        {
            self.childDeduction.deduction = 2000.0f;
        }
            break;
        case SKChildStatusThree:
        {
            self.childDeduction.deduction = 3000.0f;
        }
            break;
        case SKChildStatusNONE:
        {
            self.childDeduction.deduction = 0.0f;
        }
            break;
        default:
            break;
    }
}

- (void)updateAdultEducationDeduction:(SKAdultEducationStatus)adultEducationStatus {
    switch (adultEducationStatus) {
        case SKAdultEducationStatusAcademic:
        {
            self.adultEducationDeduction.deduction = 400.0f;
        }
            break;
        case SKAdultEducationStatusVocational:
        {
            self.adultEducationDeduction.deduction = 0.0f;
        }
            break;
        case SKAdultEducationStatusNONE:
        {
            self.adultEducationDeduction.deduction = 0.0f;
        }
            break;
        default:
            break;
    }
}

- (void)updateHousingDeduction:(SKHousingStatus)housingStatus {
    switch (housingStatus) {
        case SKHousingStatusFirstHousingLoan:
        {
            self.housingDeduction.deduction = 1000.0f;
        }
            break;
        case SKHousingStatusRentLeave1:
        {
            self.housingDeduction.deduction = 1500.0f;
        }
            break;
        case SKHousingStatusRentLeave2:
        {
            self.housingDeduction.deduction = 1100.0f;
        }
            break;
        case SKHousingStatusRentLeave3:
        {
            self.housingDeduction.deduction = 800.0f;
        }
            break;
        case SKHousingStatusNONE:
        {
            self.housingDeduction.deduction = 0.0f;
        }
            break;
        default:
            break;
    }
}

- (void)updateParentsSupportDeduction:(SKParentsSupportStatus)parentSupportStatus {
    switch (parentSupportStatus) {
        case SKParentsSupportStatusOnlyChild:
        {
            self.parentSupportDeduction.deduction = 2000.0f;
        }
            break;
        case SKParentsSupportStatusNoOnlyChild:
        {
            self.parentSupportDeduction.deduction = 1000.0f;
        }
            break;
        case SKParentsSupportStatusNONE:
        {
            self.parentSupportDeduction.deduction = 0.0f;
        }
            break;
        default:
            break;
    }
}

- (CGFloat)specialDeductionCount {
    return self.childDeduction.deduction + self.parentSupportDeduction.deduction + self.housingDeduction.deduction + self.adultEducationDeduction.deduction;
}

- (NSArray *)selectedDeductions {
    NSMutableArray *retArray = [NSMutableArray array];
    if (self.childDeduction.deduction != 0) {
        [retArray addObject:self.childDeduction];
    }
    if (self.adultEducationDeduction.deduction != 0) {
        [retArray addObject:self.adultEducationDeduction];
    }
    if (self.housingDeduction.deduction != 0) {
        [retArray addObject:self.housingDeduction];
    }
    if (self.parentSupportDeduction.deduction != 0) {
        [retArray addObject:self.parentSupportDeduction];
    }
    return retArray;
}

#pragma mark -  清空状态
- (void)cleanUpTaxContext {
    self.childDeduction.deduction = 0.0f;
    self.adultEducationDeduction.deduction = 0.0f;
    self.housingDeduction.deduction = 0.0f;
    self.parentSupportDeduction.deduction = 0.0f;
}

- (void)resetSocialSecurityStrageties
{
    [self.socialSecurityStrategies removeAllObjects];
    
    NSMutableArray *sandBoxDataArray = [[NSMutableArray alloc]initWithContentsOfFile:[self socialSecurityPlistPath]];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"SKSocialSecurity" ofType:@"plist"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    [dataArray writeToFile:[self socialSecurityPlistPath] atomically:YES];
    sandBoxDataArray = [[NSMutableArray alloc]initWithContentsOfFile:[self socialSecurityPlistPath]];
    
    [sandBoxDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *strategyDict = (NSDictionary *)obj;
        SKSocialSecurityStrategy *ss = [[SKSocialSecurityStrategy alloc] init];
        [ss setValuesForKeysWithDictionary:strategyDict];
        [self.socialSecurityStrategies addObject:ss];
    }];
    self.currentSecurityStrategy = self.socialSecurityStrategies.firstObject;
}

#pragma mark - 根据应缴税额，确定预扣率
- (NSDictionary *)fetchPersonalTaxRate:(CGFloat)taxableIncome {
    NSString *taxLeave = TAX_LEAVE_1;
    if (36000 < taxableIncome && taxableIncome <=144000) {
        taxLeave = TAX_LEAVE_2;
    }else if (144000 < taxableIncome && taxableIncome <=300000) {
        taxLeave = TAX_LEAVE_3;
    }else if (300000 < taxableIncome && taxableIncome <=420000) {
        taxLeave = TAX_LEAVE_4;
    }else if (420000 < taxableIncome && taxableIncome <=660000) {
        taxLeave = TAX_LEAVE_5;
    }else if (660000 < taxableIncome && taxableIncome <=960000) {
        taxLeave = TAX_LEAVE_6;
    }else if (960000 < taxableIncome) {
        taxLeave = TAX_LEAVE_7;
    }
    NSDictionary *taxRate = self.personalTaxRateTable[taxLeave];
    return taxRate;
}

#pragma mark -  计算个人所得税
- (NSArray<NSDictionary *> *)calculatePersonalIncomeTax {
    NSMutableArray *personalIncomeTaxes = [NSMutableArray arrayWithCapacity:12];
    CGFloat  socialSecurityPaied = [self.currentSecurityStrategy calculatePersonalPaied:self.salary];
    CGFloat personalDeduction = self.childDeduction.deduction + self.adultEducationDeduction.deduction + self.housingDeduction.deduction + self.parentSupportDeduction.deduction;
    CGFloat personalTaxBaseLine = self.salary - PERSONAL_TAX_FREE - socialSecurityPaied - personalDeduction;
    if (personalTaxBaseLine < 0) {
        personalTaxBaseLine = 0;
    }
    NSDictionary *personalTaxRate = [self fetchPersonalTaxRate:personalTaxBaseLine];
    CGFloat personalTax = personalTaxBaseLine * ((NSNumber *)personalTaxRate[TAX_RATE]).floatValue - ((NSNumber *)personalTaxRate[TAX_QUICK_DISCOUNT]).floatValue;
    NSDictionary *dic = @{PERSONAL_TAX_LEAVE:personalTaxRate, PERSONAL_TAX_COUNT:[NSNumber numberWithFloat:personalTax]};
    [personalIncomeTaxes addObject:dic];
    CGFloat alreadyTaxed = personalTax;
    // 根据1月的值，计算第n月的个税额度
    for (NSInteger n = 2; n < 13; ++n) {
        CGFloat curPersonalTaxBaseLine = personalTaxBaseLine * n;
        NSDictionary *personalTaxRate = [self fetchPersonalTaxRate:curPersonalTaxBaseLine];
        CGFloat personalTax = curPersonalTaxBaseLine * ((NSNumber *)personalTaxRate[TAX_RATE]).floatValue - ((NSNumber *)personalTaxRate[TAX_QUICK_DISCOUNT]).floatValue;
        personalTax -= alreadyTaxed;
        alreadyTaxed += personalTax;
        NSDictionary *dic = @{PERSONAL_TAX_LEAVE:personalTaxRate, PERSONAL_TAX_COUNT:[NSNumber numberWithFloat:personalTax]};
        [personalIncomeTaxes addObject:dic];
    }
    return personalIncomeTaxes;
}

#pragma mark -  计算个人应缴社保及公积金
- (CGFloat)calculatePersonalSocialSecurityAndHousingFund {
    return [self.currentSecurityStrategy calculatePersonalPaied:self.lastSalary];
}

- (CGFloat)calculatePersonalED {
    return [self.currentSecurityStrategy calculatePersonalED:self.lastSalary];
}

- (CGFloat)calculatePersonalMD {
    return [self.currentSecurityStrategy calculatePersonalMD:self.lastSalary];
}

- (CGFloat)calculatePersonalUE {
    return [self.currentSecurityStrategy calculatePersonalUE:self.lastSalary];
}

- (CGFloat)calculatePersonalHF {
    return [self.currentSecurityStrategy calculatePersonalHF:self.lastSalary];
}

- (CGFloat)calculateCompanyED {
    return [self.currentSecurityStrategy calculateCompanyED:self.lastSalary];
}

- (CGFloat)calculateCompanyMD {
    return [self.currentSecurityStrategy calculateCompanyMD:self.lastSalary];
}

- (CGFloat)calculateCompanyUE {
    return [self.currentSecurityStrategy calculateCompanyUE:self.lastSalary];
}

- (CGFloat)calculateCompanyHF {
    return [self.currentSecurityStrategy calculateCompanyHF:self.lastSalary];
}

#pragma mark - setter/getter
- (NSMutableArray *)deductions {
    if (_deductions == nil) {
        _deductions = [NSMutableArray array];
    }
    return _deductions;
}

- (NSMutableArray *)socialSecurityStrategies {
    if (_socialSecurityStrategies == nil) {
        _socialSecurityStrategies = [NSMutableArray array];
    }
    return _socialSecurityStrategies;
}

- (NSDictionary *)personalTaxRateTable {
    if (_personalTaxRateTable == nil) {
        _personalTaxRateTable = @{TAX_LEAVE_1:@{TAX_RATE:@0.03f, TAX_QUICK_DISCOUNT:@0.0f},
                                  TAX_LEAVE_2:@{TAX_RATE:@0.1f, TAX_QUICK_DISCOUNT:@2520.f},
                                  TAX_LEAVE_3:@{TAX_RATE:@0.2f, TAX_QUICK_DISCOUNT:@16920.f},
                                  TAX_LEAVE_4:@{TAX_RATE:@0.25f, TAX_QUICK_DISCOUNT:@31920.0f},
                                  TAX_LEAVE_5:@{TAX_RATE:@0.3f, TAX_QUICK_DISCOUNT:@52920.0f},
                                  TAX_LEAVE_6:@{TAX_RATE:@0.35f, TAX_QUICK_DISCOUNT:@85920.0f},
                                  TAX_LEAVE_7:@{TAX_RATE:@0.45f, TAX_QUICK_DISCOUNT:@181920.0f},
                                  };
    }
    return _personalTaxRateTable;
}


@end
