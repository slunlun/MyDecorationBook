//
//  SWYellowViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWYellowViewController.h"
#import "SWBlueViewController.h"


#import "AppDelegate.h"
@interface SWYellowViewController ()
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) UIButton *changeButton;
@end

@implementation SWYellowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 180, 180)];
    [changeButton setTitle:@"Change View" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:changeButton];

    _changeButton = changeButton;
}

- (void)changeButtonClicked:(UIButton *)button
{
     AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    UIView *rootView = _changeButton;
    while (rootView.superview) {
        rootView = rootView.superview;
    }
    
//    [rootView insertSubview:_changeButton aboveSubview:appDelegate.drawerVC.view];
//    _changeButton.frame = CGRectMake(CGRectGetMidX(_changeButton.superview.frame), CGRectGetMidY(_changeButton.superview.frame), _changeButton.frame.size.width, _changeButton.frame.size.height);
    return;
   
  
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
