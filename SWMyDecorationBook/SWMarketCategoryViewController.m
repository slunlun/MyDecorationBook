//
//  SWMarketCategoryViewController.m
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/2/6.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import "SWMarketCategoryViewController.h"
#import "SWMarketCategoryStorage.h"
#import "SWUIDef.h"
#import "Masonry.h"

#define SELECTED_MARK_VIEW_SPEED 100.0f
static NSString *CATEGORY_CELL_IDENTIFY = @"CATEGORY_CELL_IDENTIFY";

@interface SWMarketCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *marketCategoryTableView;
@property(nonatomic, strong) UIView *selectedMarkView;
@property(nonatomic, strong) NSArray *categoryArray;
@property(nonatomic, assign) NSInteger selectedMarkCategoryIndex;
@end

@implementation SWMarketCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self updateData];
    _selectedMarkCategoryIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Setter/Getter
- (NSArray *)categoryArray {
    if (_categoryArray == nil) {
        _categoryArray = [[NSArray alloc] init];
    }
    return _categoryArray;
}

#pragma mark - Common Init
- (void)commonInit {
    _marketCategoryTableView = [[UITableView alloc] init];
    _marketCategoryTableView.delegate = self;
    _marketCategoryTableView.dataSource = self;
    _marketCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _marketCategoryTableView.backgroundColor = SW_TAOBAO_BLACK;
    _marketCategoryTableView.allowsMultipleSelection = NO;
    _marketCategoryTableView.allowsSelection = YES;
    
    [self.view addSubview:_marketCategoryTableView];
    
    [_marketCategoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.top.equalTo(self.mas_topLayoutGuide);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
        
        make.left.right.equalTo(self.view);
    }];
    
}

#pragma mark - Update
- (void)updateData {
    self.categoryArray = [SWMarketCategoryStorage allMarketCategory];
    [self.marketCategoryTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // self.categoryArray
    CGRect cellFrame = [cell convertRect:cell.frame toView:tableView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CATEGORY_CELL_IDENTIFY];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CATEGORY_CELL_IDENTIFY];
    }
    SWMarketCategory *marketCategory = self.categoryArray[indexPath.row];
    cell.textLabel.text = marketCategory.categoryName;
    cell.textLabel.font = SW_DEFAULT_FONT;
    cell.backgroundColor = SW_TAOBAO_BLACK;
    cell.textLabel.textColor = SW_DISABLE_GRAY;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    return cell;
}

@end
