//
//  SKAllResultViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKAllResultViewController.h"
#import "Masonry.h"
#import "SKResultTableViewCell.h"
#import "SKDetailInfoVC.h"
#import "SKTaxContext.h"
@interface SKAllResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation SKAllResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 100;
    [self.view addSubview:tableView];
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView = tableView;
    [tableView registerClass:[SKResultTableViewCell class] forCellReuseIdentifier: @"cell"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.left.right.bottom.equalTo(self.view);
        }
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@" %ld 月",section+1];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataArray = self.dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SKDetailInfoVC *VC = [[SKDetailInfoVC alloc]init];
    VC.monthStr = [NSString stringWithFormat:@"%ld月详情",indexPath.section+1];
    VC.incomeStr = self.dataArray[indexPath.section].lastObject;
    NSDictionary *dic = self.taxInfoDataArray[indexPath.section];
    NSDictionary *levelDic = dic[PERSONAL_TAX_LEAVE];
    NSNumber *taxRate = levelDic[TAX_RATE];
    NSNumber *quickCount = levelDic[TAX_QUICK_DISCOUNT];
    NSNumber *taxValue = dic[PERSONAL_TAX_COUNT];
    NSArray *taxInfoArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%.1f",[taxRate floatValue]*100],[NSString stringWithFormat:@"%.1f",[quickCount floatValue]],[NSString stringWithFormat:@"%.1f",[taxValue floatValue]] ,nil];
    VC.dataArray = taxInfoArray;
    
    [self.navigationController pushViewController:VC animated:YES];
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
