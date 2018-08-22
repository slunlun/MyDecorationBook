//
//  SWUserTutorialManager.m
//  SWSpotLightView
//
//  Created by Eren on 2018/8/22.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWUserTutorialManager.h"
#import "SWSpotlightView.h"

@implementation SWTutorialNode
- (instancetype)initWithPoint:(CGPoint)point radius:(CGFloat)radius text:(NSString *)text {
    if (self = [super init]) {
        _tutorialText = text;
        _spotlightPoint = point;
        _spotlightRadius = radius;
    }
    return self;
}
@end

@interface SWUserTutorialManager()<SWSpotlightViewDelegate>
@property(nonatomic, strong) SWSpotlightView *spotlightView;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) NSArray *nodes;
@end

@implementation SWUserTutorialManager
+ (instancetype)sharedInstance {
    dispatch_once_t onceToken = 0;
    static SWUserTutorialManager *singleInstance = nil;
    dispatch_once(&onceToken, ^{
        singleInstance = [[SWUserTutorialManager alloc] init];
    });
    return singleInstance;
}

- (void)setUpTutorialViewWithNodes:(NSArray<SWTutorialNode *> *)tutorialNodes inView:(UIView *)view {
    // clear up
    [_spotlightView removeFromSuperview];
    _nodes = nil;
    _index = 0;
    
    // reset new spotlightview
    _nodes = tutorialNodes;
    _spotlightView = [[SWSpotlightView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _spotlightView.delegate = self;
    
    SWTutorialNode *node = _nodes[_index++];
    _spotlightView.spolightPoint = node.spotlightPoint;
    _spotlightView.spolightRadius = node.spotlightRadius;
    _spotlightView.spotlightText = node.tutorialText;
    [view addSubview:_spotlightView];
    [_spotlightView updateSpotlightView];
}



#pragma mark - SWSpotlightViewDelegate
- (void)spotlightViewDidTapped:(SWSpotlightView *)spotlightView {
    if (_index > _nodes.count - 1) {
        [_spotlightView removeFromSuperview];
        _nodes = nil;
        _index = 0;
        
    }else {
        SWTutorialNode *node = _nodes[_index++];
        _spotlightView.spolightPoint = node.spotlightPoint;
        _spotlightView.spolightRadius = node.spotlightRadius;
        _spotlightView.spotlightText = node.tutorialText;
        [_spotlightView updateSpotlightView];
    }
}

@end
