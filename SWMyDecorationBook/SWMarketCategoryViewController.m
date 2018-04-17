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
#import "SWMarketCategoryTableViewCell.h"
#import "SWDef.h"

#define SELECTED_MARK_VIEW_SPEED 100.0f
#define MARKET_CATEGORY_VIEW_TOP_HEIGHT 80.0f
#define MARKET_CATEGORY_VIEW_BOTTOM_HEIGHT 60.0f

static NSString *CATEGORY_CELL_IDENTIFY = @"CATEGORY_CELL_IDENTIFY";

@interface SWMarketCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray *categoryArray;
@property(nonatomic, assign) NSInteger selectedMarkCategoryIndex;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UIButton *addBtn;
@property(nonatomic, strong) UIButton *saveEditBtn;
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
    
    self.view.backgroundColor = SW_TAOBAO_BLACK;
    
    _marketCategoryTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _marketCategoryTableView.delegate = self;
    _marketCategoryTableView.dataSource = self;
    _marketCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _marketCategoryTableView.backgroundColor = SW_TAOBAO_BLACK;
    _marketCategoryTableView.allowsMultipleSelection = NO;
    _marketCategoryTableView.allowsSelection = YES;
    [_marketCategoryTableView registerClass:[SWMarketCategoryTableViewCell class] forCellReuseIdentifier:CATEGORY_CELL_IDENTIFY];
    
    [self.view addSubview:_marketCategoryTableView];
    [_marketCategoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(MARKET_CATEGORY_VIEW_TOP_HEIGHT);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(MARKET_CATEGORY_VIEW_TOP_HEIGHT);
        }
        make.bottom.equalTo(self.view.mas_bottom).offset(-MARKET_CATEGORY_VIEW_BOTTOM_HEIGHT);
    }];
    _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _editBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setImage:[UIImage imageNamed:@"Edit@30"] forState:UIControlStateNormal];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:SW_DISABLE_GRAY forState:UIControlStateNormal];
    _editBtn.titleLabel.font = SW_DEFAULT_FONT;
    _editBtn.backgroundColor = SW_TAOBAO_BLACK;
    [self.view addSubview:_editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_marketCategoryTableView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).multipliedBy(0.5);
        make.bottom.equalTo(self.view);
    }];
    
    _addBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _addBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_addBtn addTarget:self action:@selector(addCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setImage:[UIImage imageNamed:@"Add-Cross"] forState:UIControlStateNormal];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:SW_DISABLE_GRAY forState:UIControlStateNormal];
    _addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _addBtn.titleLabel.font = SW_DEFAULT_FONT;
    _addBtn.backgroundColor = SW_TAOBAO_BLACK;
//    [self.view addSubview:_addBtn];
//    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_marketCategoryTableView.mas_bottom);
//        make.left.equalTo(self.editBtn.mas_right);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    
    _saveEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveEditBtn addTarget:self action:@selector(saveEditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_saveEditBtn setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
    [_saveEditBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_saveEditBtn setTitleColor:SW_DISABLE_GRAY forState:UIControlStateNormal];
    _saveEditBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _saveEditBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _saveEditBtn.titleLabel.font = SW_DEFAULT_FONT;
    _saveEditBtn.backgroundColor = SW_TAOBAO_BLACK;
    [self.view addSubview:_saveEditBtn];
    [_saveEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_marketCategoryTableView.mas_bottom);
        make.right.equalTo(self.view.mas_left).offset(-20);
        make.bottom.equalTo(self.view);
        make.width.equalTo(@0);
    }];
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
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWMarketCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CATEGORY_CELL_IDENTIFY];
    SWMarketCategory *marketCategory = self.categoryArray[indexPath.row];
    cell.model = marketCategory;
    WeakObj(self);
    cell.configBtnCallback = ^(SWMarketCategory *model) {
        StrongObj(self);
        [self configMarketCategory:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Update UI
- (void)updateViewConstraints {
    if (self.marketCategoryTableView.editing) {
        [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.left.equalTo(self.view.mas_right);
            make.width.equalTo(@0);
            make.bottom.equalTo(self.view);
        }];
       
        [_saveEditBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }else {
        [_editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view).multipliedBy(0.5);
            make.bottom.equalTo(self.view);
        }];
        
        [_saveEditBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.right.equalTo(self.view.mas_left).offset(-20);
            make.bottom.equalTo(self.view);
            make.width.equalTo(@0);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    [super updateViewConstraints];
}

#pragma mark - UI Response
- (void)editBtnClicked:(UIButton *)editBtn {
    [self.marketCategoryTableView setEditing:YES animated:YES];
    [self.marketCategoryTableView reloadData];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)saveEditBtnClicked:(UIButton *)saveEditBtn {
    [self.marketCategoryTableView setEditing:NO animated:YES];
    [self.marketCategoryTableView reloadData];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)addCategoryBtnClicked:(UIButton *)addBtn {
    [self.marketCategoryTableView setEditing:NO animated:YES];
    [self.marketCategoryTableView reloadData];
}

- (void)configMarketCategory:(SWMarketCategory *)marketCategory {
    
}

@end
