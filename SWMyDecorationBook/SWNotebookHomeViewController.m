//
//  SWNotebookHomeViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/5/2.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWNotebookHomeViewController.h"
#import "SWShoppingItemHomePageVC.h"
#import "AppDelegate.h"

@interface SWNotebookHomeViewController ()

@end

@implementation SWNotebookHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Common init
- (void)commonInit {
    UIBarButtonItem *shoppingItemHomePage = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Market"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingItemHomePageClicked:)];
    self.navigationItem.leftBarButtonItem = shoppingItemHomePage;
}

#pragma mark - UI Response
- (void)shoppingItemHomePageClicked:(UIBarButtonItem *)barItem {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).drawerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
