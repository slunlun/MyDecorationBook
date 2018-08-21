//
//  SWMarketContactViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketContactViewController.h"
#import "SWUIDef.h"
#import "Masonry.h"
#import "SWMarketContact.h"

@interface SWMarketContactViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *contactTableView;
@property(nonatomic, strong) NSArray *contactArray;
@end

@implementation SWMarketContactViewController

- (instancetype)initWithContactArray:(NSArray *)contactArray {
    if (self = [super init]) {
        _contactArray = contactArray;
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CommonInit
- (void)commonInit {
    self.navigationItem.title = @"联系商家";
    
    _contactTableView = [[UITableView alloc] init];
    [_contactTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL_IDENTIFY"];
    _contactTableView.delegate = self;
    _contactTableView.dataSource = self;
    _contactTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_contactTableView];
    [_contactTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }
    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SW_CELL_DEFAULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWMarketContact *contact = self.contactArray[indexPath.row];
    NSString *msg = [NSString stringWithFormat:@"要联系 %@ 吗？", contact.name];
    UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *telNum = [NSString stringWithFormat:@"tel://%@", contact.telNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancleAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWMarketContact *contact = self.contactArray[indexPath.row];
    NSString * identifier= @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //自适应图片（大小）
    cell.textLabel.text = contact.name;
    cell.textLabel.font = SW_DEFAULT_FONT_LARGE;
    cell.imageView.image = [UIImage imageNamed:@"Contact"];
    cell.detailTextLabel.text = contact.telNum;
    cell.detailTextLabel.font = SW_DEFAULT_MIN_FONT;
    cell.detailTextLabel.textColor = SW_MAIN_BLUE_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
