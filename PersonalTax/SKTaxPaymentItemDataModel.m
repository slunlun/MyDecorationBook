//
//  SKTaxPaymentItemDataModel.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKTaxPaymentItemDataModel.h"

@implementation SKTaxPaymentItemDataModel

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder isSelected:(BOOL)isSelected modelType:(SKTaxModelType)type;
{
    self = [super init];
    if (self) {
        _itemTitle = title;
        _content = content;
        _placeholder = placeholder;
        _isSelected = isSelected;
        _type = type;
        
        _parentsSupportStatus =  SKParentsSupportStatusNONE;
        _childStatus = SKChildStatusNONE;
        _adultEduStatus = SKAdultEducationStatusNONE;
        _houseStatus = SKHousingStatusNONE;
    }
    return self;
}

// copy
- (id)copyWithZone:(nullable NSZone *)zone {
    SKTaxPaymentItemDataModel *copyModel = [[SKTaxPaymentItemDataModel alloc] init];
    copyModel.itemTitle = [self.itemTitle copy];
    copyModel.content = [self.content copy];
    copyModel.placeholder = [self.placeholder copy];
    copyModel.isSelected = self.isSelected;
    copyModel.type = self.type;
    
    copyModel.parentsSupportStatus = self.parentsSupportStatus;
    copyModel.childStatus = self.childStatus;
    copyModel.adultEduStatus = self.adultEduStatus;
    copyModel.houseStatus = self.houseStatus;
    
    return copyModel;
}

@end

