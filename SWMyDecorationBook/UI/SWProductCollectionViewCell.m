//
//  SWProductCollectionViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 10/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductCollectionViewCell.h"
#import "Masonry.h"

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
    _productImage.userInteractionEnabled = NO;
    _productImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Set/Get/Init
- (void)setModel:(UIImage *)model {
    _model = model;
    self.productImage.image = _model;
}
@end
