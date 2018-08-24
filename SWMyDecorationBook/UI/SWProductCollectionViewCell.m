//
//  SWProductCollectionViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 10/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductCollectionViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
@interface SWProductCollectionViewCell()
@property(nonatomic, strong) UIButton *delBtn;
@end

@implementation SWProductCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common
- (void)commonInit {
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _productImage = [[UIImageView alloc] init];
    _productImage.contentMode = UIViewContentModeScaleAspectFit;
    _productImage.userInteractionEnabled = NO;
    
    //_productImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _delBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_delBtn];
    [_delBtn setImage:[UIImage imageNamed:@"DelCross"] forState:UIControlStateNormal];
    _delBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.backgroundColor = SW_WARN_RED;
    _delBtn.clipsToBounds = YES;
    _delBtn.layer.cornerRadius = 10;
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.centerX.equalTo(_productImage.mas_right).offset(-11);
        make.centerY.equalTo(_productImage.mas_top).offset(12);
    }];
    _delBtn.hidden = YES;
    
}

#pragma mark - Set/Get/Init
- (void)setModel:(UIImage *)model {
    _model = model;
    self.productImage.image = _model;
}

- (void)setSupportEdit:(BOOL)supportEdit {
    _supportEdit = supportEdit;
    if (supportEdit) {
        [self setUpDelBtn];
    }else {
        self.delBtn.hidden = YES;
    }
}

- (void)setUpDelBtn {
    self.delBtn.hidden = NO;
}

#pragma -mark UI response
- (void)delBtnClicked:(UIButton *)btn {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
