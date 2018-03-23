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
#import "AppDelegate.h"

#define SELECTED_MARK_VIEW_SPEED 100.0f
static NSString *CATEGORY_CELL_IDENTIFY = @"CATEGORY_CELL_IDENTIFY";

@interface SWMarketCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>

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

- (void)setSelectedMarkCategoryIndex:(NSInteger)selectedMarkCategoryIndex {
    _selectedMarkCategoryIndex = selectedMarkCategoryIndex;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).currentMarketCategory = self.categoryArray[selectedMarkCategoryIndex];
}

#pragma mark - Common Init
- (void)commonInit {
    _marketCategoryTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _marketCategoryTableView.delegate = self;
    _marketCategoryTableView.dataSource = self;
    _marketCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _marketCategoryTableView.backgroundColor = SW_TAOBAO_BLACK;
    _marketCategoryTableView.allowsMultipleSelection = NO;
    _marketCategoryTableView.allowsSelection = YES;
    
    [self.view addSubview:_marketCategoryTableView];
    [_marketCategoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    _selectedMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _selectedMarkView.backgroundColor = SW_TAOBAO_ORANGE;
    [self.marketCategoryTableView addSubview:_selectedMarkView];
    [self.marketCategoryTableView bringSubviewToFront:_selectedMarkView];
}

#pragma mark - Update
- (void)updateData {
    self.categoryArray = [SWMarketCategoryStorage allMarketCategory];
    [self.marketCategoryTableView reloadData];
   // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
   // UITableViewCell *cell = [self.marketCategoryTableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // self.categoryArray
    CGRect cellFrame = cell.frame;
    CGRect markCellFrame = CGRectMake(cellFrame.origin.x + cellFrame.size.width - 20, cellFrame.origin.y, 20, cellFrame.size.height);
    NSLog(@"org Cell frame is %@", NSStringFromCGRect(cell.frame));
    NSLog(@"Cell frame is %@", NSStringFromCGRect(cellFrame));
     NSLog(@"Mark frame is %@", NSStringFromCGRect(markCellFrame));
    [UIView animateWithDuration:0.5 animations:^{
        self.selectedMarkView.frame = markCellFrame;
    }];
    
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
    CGRect cellFrame = [cell convertRect:cell.frame toView:self.view];
    
    if (self.selectedMarkCategoryIndex == indexPath.row) {
        CGRect cellFrame = [cell convertRect:cell.frame toView:self.view];
        self.selectedMarkView.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, 20, cellFrame.size.height);
    }
    return cell;
}

@end
