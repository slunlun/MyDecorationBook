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
#import "HexColor.h"
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
    _selectedMarkCategoryIndex = 0;
    [self commonInit];
    [self updateData];
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
    
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width
    
#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height
    
    //iPhone_X layout
    
#define iPhone_X                 (SCREEN_HEIGHT == 812.0)
    
#define Status_H                 (iPhone_X ? 44 : 20)
    
#define NavBar_H                  44
    
#define Nav_Height                (Status_H + NavBar_H)
    
    [self.view addSubview:_marketCategoryTableView];
    [_marketCategoryTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(NavBar_H);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(NavBar_H);
        }
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-MARKET_CATEGORY_VIEW_BOTTOM_HEIGHT);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-MARKET_CATEGORY_VIEW_BOTTOM_HEIGHT);
        }
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedMarkCategoryIndex inSection:0];
    [_marketCategoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _editBtn.layer.shadowColor  = SW_TAOBAO_BLACK.CGColor;
    _editBtn.layer.shadowOffset = CGSizeMake(0, -10.0);
    _editBtn.layer.shadowOpacity = 1.0f;
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
    _addBtn.layer.shadowColor  = SW_TAOBAO_BLACK.CGColor;
    _addBtn.layer.shadowOffset = CGSizeMake(0, -10.0);
    _addBtn.layer.shadowOpacity = 1.0f;
    
    _addBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    [_addBtn addTarget:self action:@selector(addCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setImage:[UIImage imageNamed:@"Add-Cross"] forState:UIControlStateNormal];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setTitleColor:SW_DISABLE_GRAY forState:UIControlStateNormal];
    _addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _addBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _addBtn.titleLabel.font = SW_DEFAULT_FONT;
    _addBtn.backgroundColor = SW_TAOBAO_BLACK;
    [self.view addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_marketCategoryTableView.mas_bottom);
        make.left.equalTo(self.editBtn.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _saveEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveEditBtn.layer.shadowColor  = SW_TAOBAO_BLACK.CGColor;
    _saveEditBtn.layer.shadowOffset = CGSizeMake(0, -10.0);
    _saveEditBtn.layer.shadowOpacity = 1.0f;
    
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
    self.selectedMarkCategoryIndex = indexPath.row;
    SWMarketCategory *markCategory = self.categoryArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didClickMarketCategory:)]) {
        [self.delegate marketCategoryVC:self didClickMarketCategory:markCategory];
    }
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
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#F56219"];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SWMarketCategory *marketCategory = self.categoryArray[indexPath.row];
    NSString *messageString = [NSString stringWithFormat:@"确定删除%@吗?(%@下的所有商家信息将被删除)", marketCategory.categoryName, marketCategory.categoryName];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SWMarketCategoryStorage removeMarkeetCategory:marketCategory];
        [self updateData];
        if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didDeleteMarketCategory:)]) {
            [self.delegate marketCategoryVC:self didUpdateMarketCategory:marketCategory];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedMarkCategoryIndex inSection:0];
    [_marketCategoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
        
        [_addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.left.equalTo(self.editBtn.mas_right);
            make.width.equalTo(@0);
            make.bottom.equalTo(self.view);
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
        
        [_addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marketCategoryTableView.mas_bottom);
            make.left.equalTo(self.editBtn.mas_right);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
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
    
    // 默认选择第一个
    if (self.categoryArray.count) {
        SWMarketCategory *markCategory = self.categoryArray[0];
        self.selectedMarkCategoryIndex = 0;
        [self.marketCategoryTableView reloadData];
        if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didClickMarketCategory:)]) {
            [self.delegate marketCategoryVC:self didClickMarketCategory:markCategory];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didClickMarketCategory:)]) {
            [self.delegate marketCategoryVC:self didClickMarketCategory:nil];
        }
    }
   
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)addCategoryBtnClicked:(UIButton *)addBtn {
    [self.marketCategoryTableView setEditing:NO animated:YES];
    [self.marketCategoryTableView reloadData];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"新建分类" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"分类名称";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        if (![textField.text isEqualToString:@""]) {
            NSString *categoryName = textField.text;
            BOOL categoryExisted = NO;
            for (SWMarketCategory *marketCategory in self.categoryArray) {
                if ([marketCategory.categoryName isEqualToString:categoryName]) {
                    categoryExisted = YES;
                    break;
                }
            }
            if (!categoryExisted) {
                SWMarketCategory *newCategory = [[SWMarketCategory alloc] initWithCategoryName:categoryName];
                [SWMarketCategoryStorage insertMarketCategory:newCategory];
                [self updateData];
                self.selectedMarkCategoryIndex = self.categoryArray.count - 1;
                if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didClickMarketCategory:)]) {
                    [self.delegate marketCategoryVC:self didClickMarketCategory:newCategory];
                }
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)configMarketCategory:(SWMarketCategory *)marketCategory {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"分类名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = marketCategory.categoryName;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        if (![textField.text isEqualToString:@""] && ![textField.text isEqualToString:marketCategory.categoryName]) {
            marketCategory.categoryName = textField.text;
            [SWMarketCategoryStorage updateMarketCategory:marketCategory];
            [self updateData];
            if ([self.delegate respondsToSelector:@selector(marketCategoryVC:didUpdateMarketCategory:)]) {
                [self.delegate marketCategoryVC:self didUpdateMarketCategory:marketCategory];
            }
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
