//
//  SKSpecialAdditionalDeductionDetailVC.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/29.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKSpecialAdditionalDeductionDetailVC.h"
#import "Masonry.h"
#import "SKTaxPaymentItemDataModel.h"
#import "SKTaxContext.h"

@interface SKSpecialAdditionalDeductionDetailVC ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation SKSpecialAdditionalDeductionDetailVC

- (instancetype)initWithDataArray:(NSArray *)dataArr
{
    self = [super init];
    if (self) {
        _dataArray = dataArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"专项扣除详情";
    [self commonInit];
    
    // Do any additional setup after loading the view.
}

- (void)commonInit
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *childEducationTitleLabel = [[UILabel alloc] init];
    childEducationTitleLabel.text = @"子女教育:";
    [self.view addSubview:childEducationTitleLabel];
    
    UILabel *continuingEducationLabel = [[UILabel alloc] init];
    continuingEducationLabel.text = @"继续教育:";
    [self.view addSubview:continuingEducationLabel];
    
    UILabel *housingSituationLabel = [[UILabel alloc] init];
    housingSituationLabel.text = @"住房情况:";
    [self.view addSubview:housingSituationLabel];
    
    UILabel *pensionLabel = [[UILabel alloc] init];
    pensionLabel.text = @"赡养老人:";
    [self.view addSubview:pensionLabel];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"合计:";
    [self.view addSubview:totalLabel];
    
    UILabel *infomationLabel = [[UILabel alloc] init];
    infomationLabel.text = @"* 职业资格教育和大病医疗需要在汇缴地主管税务机关进行汇算清缴申报时办理扣除。不计入每月个税扣除。";
    infomationLabel.numberOfLines = 0;
    infomationLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:infomationLabel];
    
    [childEducationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@45);
    }];
    
    [continuingEducationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(childEducationTitleLabel.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@45);
    }];
    
    [housingSituationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(continuingEducationLabel.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@45);
    }];
    
    [pensionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(housingSituationLabel.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@45);
    }];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(pensionLabel.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@45);
    }];
    
    [infomationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(totalLabel.mas_bottom).offset(20);
        make.width.equalTo(@(300));
        make.height.equalTo(@100);
    }];
    
    ///infomationLabel.backgroundColor = [UIColor orangeColor];
    
    for (SKTaxPaymentItemDataModel *model in _dataArray) {
        if (model.type == SKTaxModelTypeChildEducation) {
            if (model.childStatus != SKChildStatusNONE) {
                NSString *value = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].childDeduction.deduction];
                childEducationTitleLabel.text = [NSString stringWithFormat:@"子女教育:    %@元",value];
            }else{
                NSString *value = @"0.00";
                childEducationTitleLabel.text = [NSString stringWithFormat:@"子女教育:    %@元",value];
            }
        }
        
        if (model.type == SKTaxModelTypeContinuingEducation) {
            if (model.adultEduStatus != SKAdultEducationStatusNONE) {
                NSString *value = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].adultEducationDeduction.deduction];
                continuingEducationLabel.text = [NSString stringWithFormat:@"继续教育:    %@元",value];
            }else{
                NSString *value = @"0.00";
                continuingEducationLabel.text = [NSString stringWithFormat:@"继续教育:    %@元",value];
            }
        }
        
        if (model.type == SKTaxModelTypeHousingSituation) {
            if (model.houseStatus != SKHousingStatusNONE) {
                NSString *value = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].housingDeduction.deduction];
                housingSituationLabel.text = [NSString stringWithFormat:@"住房情况:    %@元",value];
            }else{
                NSString *value = @"0.00";
                housingSituationLabel.text = [NSString stringWithFormat:@"住房情况:    %@元",value];
            }
        }
        
        if (model.type == SKTaxModelTypeSupportForTheElderly) {
            if (model.parentsSupportStatus != SKParentsSupportStatusNONE) {
                NSString *value = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].parentSupportDeduction.deduction];
                pensionLabel.text = [NSString stringWithFormat:@"赡养老人:    %@元",value];
            }else{
                NSString *value = @"0.00";
                pensionLabel.text = [NSString stringWithFormat:@"赡养老人:    %@元",value];
            }
        }
    }
    
 
    if([SKTaxContext sharedInstance].specialDeductionCount > 0) {
           NSString *value = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].specialDeductionCount];
          totalLabel.text = [NSString stringWithFormat:@"合计: %@元",value];
    }else
    {
          NSString *value = @"0.00";
          totalLabel.text = [NSString stringWithFormat:@"合计: %@元",value];
    }
  
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
