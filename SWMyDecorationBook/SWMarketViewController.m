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
#import "SWMarketContactSectionHeaderView.h"
#import "SWMarketNameCell.h"
#import "SWUIDef.h"

static NSString *TEL_CELL_IDENTIFIER = @"TEL_CELL_IDENTIFIER";
static NSString *MARKET_CONTACT_HEADER_VIEW_IDENTIFIER = @"MARKET_CONTACT_HEADER_VIEW_IDENTIFIER";
static NSString *MARKET_NAME_CELL_IDENTIFIER = @"MARKET_NAME_CELL_IDENTIFIER";
static NSString *MARKET_CATEGORY_CELL_IDENTIFIER = @"MARKET_CATEGORY_CELL_IDENTIFIER";

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
    [_marketInfoTableView registerClass:[SWMarketContactSectionHeaderView class]
     forHeaderFooterViewReuseIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
    [_marketInfoTableView registerClass:[SWMarketNameCell class] forCellReuseIdentifier:MARKET_NAME_CELL_IDENTIFIER];
    [self.view addSubview:_marketInfoTableView];
    _marketInfoTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_NAME_CELL_IDENTIFIER];
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:TEL_CELL_IDENTIFIER];
            if (indexPath.row == 0) {
                SWMarketContact *contact = [[SWMarketContact alloc] init];
                contact.name = @"纪勇";
                contact.telNum = @"13748503749";
                ((SWNewMarketTelNumCell *)cell).marketContact = contact;
            }else if(indexPath.row == 2) {
                SWMarketContact *contact = [[SWMarketContact alloc] init];
                contact.name = @"毅力张冰";
                contact.telNum = @"13345456349";
                contact.defaultContact = YES;
                ((SWNewMarketTelNumCell *)cell).marketContact = contact;
            }
            [cell setEditing:YES];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
                cell.textLabel.text = @"分类";
                cell.textLabel.font = SW_DEFAULT_FONT;
                cell.detailTextLabel.text = @"请选择";
                cell.detailTextLabel.font = SW_DEFAULT_MIN_FONT;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        SWMarketContactSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
        headerView.addContactAction = ^{
            NSLog(@"TBD");
        };
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    }
    return 40;
}

-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return UITableViewCellEditingStyleDelete;
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}


@end
