//
//  SKCityChooseViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKCityChooseViewController.h"
#import "SKDef.h"
#import "SKTaxContext.h"

@interface SKCityChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *cityTableview;
@property (nonatomic,strong) NSMutableArray *cityData;

@end

@implementation SKCityChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableData];
    [self commonInit];
    // Do any additional setup after loading the view.
}

- (void)commonInit
{
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClcik:)];
    [rightBarButton setTitle:@"重置"];
    rightBarButton.accessibilityValue = @"HOME_PAGE_SET_BTN";
    self.navigationItem.rightBarButtonItems = @[rightBarButton];
    
    //init tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.allowsMultipleSelection = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, kMargin * 4, 0);
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
    self.cityTableview = tableView;
    [self.view addSubview:tableView];
}

- (void)loadTableData
{
//    NSMutableArray *cityData = [[NSMutableArray alloc] initWithObjects:@"北京",@"上海" ,@"广州",@"深圳",@"杭州" ,@"通用",@"自定义", nil];
    self.cityData = [[[SKTaxContext sharedInstance] allSecurityStrategies] mutableCopy];
}

- (void)rightBarButtonItemClcik:(id)sender
{
    [[SKTaxContext sharedInstance] resetSocialSecurityStrageties];
    [self.cityData removeAllObjects];
    [self loadTableData];
    [self.cityTableview reloadData];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAX_CITY_TABLEVIEW_CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TAX_CITY_TABLEVIEW_CELL"];
    }
    
    SKSocialSecurityStrategy *cityModel = self.cityData[indexPath.row];
    cell.textLabel.text = cityModel.SS_TITLE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKSocialSecurityStrategy *selectedCityModel = self.cityData[indexPath.row];
    SKCityTaxPaymentRatioDetailViewController *infoVC = [[SKCityTaxPaymentRatioDetailViewController alloc] initWithStragetyModel:selectedCityModel];
    
    [infoVC setSaveButtonClickedBlock:^(NSString *cityName) {
        if (self.chooseCompletedBlock) {
            self.chooseCompletedBlock(cityName);
        }
    }];
 
    [self.navigationController pushViewController:infoVC animated:NO];
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
