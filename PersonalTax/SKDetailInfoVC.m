//
//  SKDetailInfoVC.m
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKDetailInfoVC.h"
#import "SKSocialSecurityView.h"
#import "Masonry.h"
#import "SKBaseFormView.h"
#import "SKTaxContext.h"
#import "SKSocialSecurityStrategy.h"
#define SKMARKCOLOR  [UIColor colorWithRed:242/255.0 green:81/255.0 blue:28/255.0 alpha:1]
@interface SKDetailInfoVC ()
//@property (nonatomic, strong) UILabel *payLabel;
//@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, assign) CGFloat salary;
@end

@implementation SKDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.monthStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
}
- (void)commonInit {
    self.salary = [SKTaxContext sharedInstance].salary;
    UILabel *payLabel = [[UILabel alloc]init];
    [self.view addSubview:payLabel];
    payLabel.text = [NSString stringWithFormat:@"税前月薪 : %.2f 元",self.salary];
    UILabel *lastPayLabel = [[UILabel alloc]init];
    [self.view addSubview:lastPayLabel];
    lastPayLabel.text = [NSString stringWithFormat:@"上年月薪 : %.2f 元",[SKTaxContext sharedInstance].lastSalary];
    UILabel *incomeLabel = [[UILabel alloc]init];
    [self.view addSubview:incomeLabel];
    incomeLabel.textColor = SKMARKCOLOR;
    incomeLabel.text = [NSString stringWithFormat:@"税后所得 : %@",self.incomeStr];
    
    UIScrollView *bgScrollView = [[UIScrollView alloc]init];
    bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgScrollView];
    self.bgScrollView = bgScrollView;
    bgScrollView.contentSize = CGSizeMake(0, 850);
    bgScrollView.showsVerticalScrollIndicator =NO;
    
    UILabel *thresholdLabel = [[UILabel alloc]init];
    thresholdLabel.text = [NSString stringWithFormat:@"起征点 : 5000.0 元"];
    [bgScrollView addSubview:thresholdLabel];
    SKSocialSecurityView *socialView = [[SKSocialSecurityView alloc]init];
    [bgScrollView addSubview:socialView];

    socialView.dataArray = [self getSocialSecurityDetailArrayfromStrategy:[SKTaxContext sharedInstance].currentSecurityStrategy];
    
    SKBaseFormView *specialView = [[SKBaseFormView alloc]init];
    [bgScrollView addSubview:specialView];
    
    specialView.dataArray = [self getSpecialDetailData];
    specialView.titleLabel.text = @"专项扣除详情";

    SKBaseFormView *taxView = [[SKBaseFormView alloc]init];
    [bgScrollView addSubview:taxView];
    NSArray *taxTitleArray = @[@"预扣率(%)",@"速算扣除数",@"个税(元)"];
    NSArray *taxDataArray = [NSArray arrayWithObjects:taxTitleArray,self.dataArray, nil];
    taxView.dataArray = taxDataArray;
    
    taxView.titleLabel.text = @"个税详情";
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.height.equalTo(@40);

        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(10);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.equalTo(@30);
        }
       
    }];
    [lastPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payLabel.mas_bottom).offset(5);
        make.left.right.equalTo(payLabel);
        make.height.equalTo(@30);
    }];
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastPayLabel.mas_bottom).offset(5);
        make.left.right.equalTo(payLabel);
        make.height.equalTo(@30);
    }];
    [bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(incomeLabel.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            
        } else {
            make.top.equalTo(incomeLabel.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }
    }];
    
    [thresholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgScrollView).offset(10);
        make.left.right.equalTo(payLabel);
        make.height.equalTo(@40);
    }];
    [socialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thresholdLabel.mas_bottom).offset(10);
        make.left.right.equalTo(incomeLabel);
    }];
    [specialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialView.mas_bottom).offset(10);
        make.left.right.equalTo(socialView);
    }];
    [taxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(specialView.mas_bottom);
        make.left.right.equalTo(specialView);
    }];
}

#pragma mark ------> 三险一金详情
- (NSArray *)getSocialSecurityDetailArrayfromStrategy:(SKSocialSecurityStrategy *)strategy {
    CGFloat P_EDValue = [[SKTaxContext sharedInstance] calculatePersonalED];
    CGFloat C_EDValue = [[SKTaxContext sharedInstance] calculateCompanyED];
    CGFloat P_MDValue = [[SKTaxContext sharedInstance] calculatePersonalMD];
    CGFloat C_MDValue = [[SKTaxContext sharedInstance] calculateCompanyMD];
    CGFloat P_UEValue = [[SKTaxContext sharedInstance] calculatePersonalUE];
    CGFloat C_UEValue = [[SKTaxContext sharedInstance] calculateCompanyUE];
    CGFloat P_HFValue = [[SKTaxContext sharedInstance] calculatePersonalHF];
    CGFloat C_HFValue = [[SKTaxContext sharedInstance] calculateCompanyHF];
    NSArray *titleArray = [NSArray arrayWithObjects:@" ",@"个人",@"单位", nil];
    NSArray *subTitleArray = [NSArray arrayWithObjects:@" ",@"比例%",@"金额(元)",@"比例%",@"金额(元)", nil];
    NSArray *EDArray = [NSArray arrayWithObjects:@"养老",[NSString stringWithFormat:@"%.1f",[strategy.P_ED floatValue] * 100], [NSString stringWithFormat:@"%.2f",P_EDValue],[NSString stringWithFormat:@"%.1f",[strategy.C_ED floatValue] * 100],[NSString stringWithFormat:@"%.2f",C_EDValue],nil];
    
    NSArray *MDArray = [NSArray arrayWithObjects:@"医疗",[NSString stringWithFormat:@"%.1f",[strategy.P_MD floatValue] * 100], [NSString stringWithFormat:@"%.2f",P_MDValue],[NSString stringWithFormat:@"%.1f",[strategy.C_MD floatValue] * 100],[NSString stringWithFormat:@"%.2f",C_MDValue],nil];
    NSArray *UEArray = [NSArray arrayWithObjects:@"失业",[NSString stringWithFormat:@"%.1f",[strategy.P_UE floatValue] * 100], [NSString stringWithFormat:@"%.2f",P_UEValue],[NSString stringWithFormat:@"%.1f",[strategy.C_UE floatValue] * 100],[NSString stringWithFormat:@"%.2f",C_UEValue],nil];
     NSArray *HFArray = [NSArray arrayWithObjects:@"公积金",[NSString stringWithFormat:@"%.1f",[strategy.P_HF floatValue] * 100], [NSString stringWithFormat:@"%.2f",P_HFValue],[NSString stringWithFormat:@"%.1f",[strategy.C_HF floatValue] * 100],[NSString stringWithFormat:@"%.2f",C_HFValue],nil];
    
    NSArray *totalArray = [NSArray arrayWithObjects:@"小计",[NSString stringWithFormat:@"%.2f",(P_EDValue+P_MDValue+P_UEValue+P_HFValue)],[NSString stringWithFormat:@"%.2f",(C_EDValue+C_MDValue+C_UEValue+C_HFValue)],nil];
    
    
    NSArray *socialDataArray = [NSArray arrayWithObjects:titleArray,subTitleArray,EDArray,MDArray,UEArray,HFArray,totalArray, nil];
    return socialDataArray;
}
#pragma mark -----> 专项扣除详情
- (NSArray *)getSpecialDetailData {
    NSMutableArray *allSpecialArray = [NSMutableArray arrayWithObjects:@[@"项目",@"金额(元)"], nil];
    NSArray *specialArray = [[SKTaxContext sharedInstance] selectedDeductions];
    for (SKSpecialDeduction *deduction in specialArray) {
        NSMutableArray *itemArray = [[NSMutableArray alloc]init];
        [itemArray addObject:deduction.title];
        [itemArray addObject:[NSString stringWithFormat:@"%.0f",deduction.deduction]];
        [allSpecialArray addObject:itemArray];
    }
    CGFloat count = [[SKTaxContext sharedInstance] specialDeductionCount];
    [allSpecialArray addObject:@[@"小计",[NSString stringWithFormat:@"%.0f",count]]];
    return allSpecialArray;
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
