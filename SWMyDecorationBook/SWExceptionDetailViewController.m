//
//  SWExceptionDetailViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/11/28.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWExceptionDetailViewController.h"

@interface SWExceptionDetailViewController ()

@end

@implementation SWExceptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *exceptPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception"];
    NSString *filePath = [exceptPath stringByAppendingPathComponent:self.fileName];
    UIWebView *exceptView = [[UIWebView alloc]init];
    exceptView.frame = self.view.frame;
    [self.view addSubview:exceptView];
    [self.view bringSubviewToFront:exceptView];
    [exceptView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
