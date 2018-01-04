//
//  SWMarketViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketViewController.h"
#import "SWMarketItem.h"
#import "SWNewMarketTelNumCell.h"

static NSString *TEL_CELL_IDENTIFIER = @"TEL_CELL_IDENTIFIER";
@interface SWMarketViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *marketInfoTableView;
@end

@implementation SWMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _marketInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _marketInfoTableView.delegate = self;
    _marketInfoTableView.dataSource = self;
    [_marketInfoTableView registerClass:[SWNewMarketTelNumCell class] forCellReuseIdentifier:TEL_CELL_IDENTIFIER];
    [self.view addSubview:_marketInfoTableView];
    _marketInfoTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWNewMarketTelNumCell *cell = [tableView dequeueReusableCellWithIdentifier:TEL_CELL_IDENTIFIER];
    if (indexPath.row == 0) {
        SWMarketContact *contact = [[SWMarketContact alloc] init];
        contact.name = @"纪勇";
        contact.telNum = @"13748503749";
        cell.marketContact = contact;
    }else if(indexPath.row == 2) {
        SWMarketContact *contact = [[SWMarketContact alloc] init];
        contact.name = @"毅力张冰";
        contact.telNum = @"13345456349";
        contact.defaultContact = YES;
        cell.marketContact = contact;
    }
    return cell;
    
}
@end
