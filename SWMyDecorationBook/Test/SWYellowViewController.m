//
//  SWYellowViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWYellowViewController.h"
#import "SWBlueViewController.h"
#import "SWRedViewController.h"

#import "AppDelegate.h"
@interface SWYellowViewController ()
@property(nonatomic, assign) NSInteger index;
@end

@implementation SWYellowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 180, 180)];
    [changeButton setTitle:@"Change View" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
}

- (void)changeButtonClicked:(UIButton *)button
{
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    if (_index % 2) {
        SWRedViewController *redVC = [[SWRedViewController alloc] init];
        [appDelegate.drawerVC setCenterViewController:redVC withCloseAnimation:YES completion:nil];
        _index ++;
    }else{
        SWYellowViewController *yellowVC = [[SWYellowViewController alloc] init];
        [appDelegate.drawerVC setCenterViewController:yellowVC withCloseAnimation:YES completion:nil];
        _index ++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
