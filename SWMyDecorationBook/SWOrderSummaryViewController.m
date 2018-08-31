//
//  SWOrderSummaryViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/31.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderSummaryViewController.h"
#import "Masonry.h"
#import "SWCommonUtils.h"

@interface SWOrderSummaryViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) NSURL *filePath;
@property (strong, nonatomic) UIWebView *fileContentWebView;
@end

@implementation SWOrderSummaryViewController

- (instancetype)initWithSummayFilePath:(NSURL *)filePath {
    if (self = [super init]) {
        _filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"家装清单";
    [self commonInit];
    
    NSString* mimetype = [SWCommonUtils getMiMeType:_filePath.path];
    NSData *plain = [NSData dataWithContentsOfURL:_filePath];
    [self.fileContentWebView loadData:plain MIMEType:mimetype textEncodingName:@"UTF-8" baseURL:_filePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CommonInit
- (void)commonInit {
    _fileContentWebView = [[UIWebView alloc] init];
    _fileContentWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    _fileContentWebView.scalesPageToFit = YES;
    _fileContentWebView.opaque = NO;
    _fileContentWebView.backgroundColor = [UIColor whiteColor];
    _fileContentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_fileContentWebView];
    
    self.fileContentWebView.scrollView.maximumZoomScale = 20;
    self.fileContentWebView.scrollView.minimumZoomScale = 0.1;
}


@end
