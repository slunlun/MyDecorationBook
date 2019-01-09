//
//  SKSocialSecurityStrategy.m
//  SKIncomeTaxCalculator
//
//  Created by Eren on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKSocialSecurityStrategy.h"
#import "NSObject+SKRuntime.h"
@interface SKSocialSecurityStrategy()
@property (nonatomic, strong, readwrite) NSString *SS_ID;
@property (nonatomic, strong, readwrite) NSString *SS_TITLE;
@end

@implementation SKSocialSecurityStrategy
- (CGFloat)calculateCompanyPaied:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    CGFloat PFBaseLine = salary > self.MAX_PF_BASELINE.floatValue?self.MAX_PF_BASELINE.floatValue:salary;
    
    return socialSecurityBaseLine * self.C_ED.floatValue +  socialSecurityBaseLine * self.C_MD.floatValue + socialSecurityBaseLine * self.C_UE.floatValue  +  PFBaseLine * self.C_HF.floatValue;
}

- (CGFloat)calculateCompanyED:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.C_ED.floatValue;
}

- (CGFloat)calculateCompanyMD:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.C_MD.floatValue;
}

- (CGFloat)calculateCompanyUE:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.C_UE.floatValue;
}

- (CGFloat)calculateCompanyHF:(CGFloat)salary {
    CGFloat PFBaseLine = salary > self.MAX_PF_BASELINE.floatValue?self.MAX_PF_BASELINE.floatValue:salary;
    return PFBaseLine * self.C_HF.floatValue;
}

- (CGFloat)calculatePersonalPaied:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    CGFloat PFBaseLine = salary > self.MAX_PF_BASELINE.floatValue?self.MAX_PF_BASELINE.floatValue:salary;
    
    return socialSecurityBaseLine * self.P_ED.floatValue +  socialSecurityBaseLine * self.P_MD.floatValue +  socialSecurityBaseLine * self.P_UE.floatValue + PFBaseLine * self.P_HF.floatValue;
}

- (CGFloat)calculatePersonalED:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.P_ED.floatValue;
}

- (CGFloat)calculatePersonalMD:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.P_MD.floatValue;
}

- (CGFloat)calculatePersonalUE:(CGFloat)salary {
    CGFloat socialSecurityBaseLine = salary > self.MAX_SS_BASELINE.floatValue?self.MAX_SS_BASELINE.floatValue:salary;
    return socialSecurityBaseLine * self.P_UE.floatValue;
}

- (CGFloat)calculatePersonalHF:(CGFloat)salary {
    CGFloat PFBaseLine = salary > self.MAX_PF_BASELINE.floatValue?self.MAX_PF_BASELINE.floatValue:salary;
    return PFBaseLine * self.P_HF.floatValue;
}

- (CGFloat)calculateTotaolPaied:(CGFloat)salary {
    return [self calculatePersonalPaied:salary] + [self calculateCompanyPaied:salary];
}

#pragma mark - Equal
- (BOOL)isEqual:(id)object {
    if ([object isMemberOfClass:[SKSocialSecurityStrategy class]]) {
        if ([((SKSocialSecurityStrategy *)object).SS_ID isEqualToString:self.SS_ID]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [self.SS_ID hash];
}

#pragma mark - convertToDictionary
- (NSDictionary *)convertToDictionary {
    return [self getAllPropertiesAndVaules];
    
}

@end
