//
//  SWProductCollectionViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 10/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductPhoto.h"
typedef void(^ProductPhotoCellDelBlock)(void);

@interface SWProductCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *productImage;
@property(nonatomic, strong) SWProductPhoto *model;
@property(nonatomic, assign) BOOL supportEdit;
@property(nonatomic, copy) ProductPhotoCellDelBlock actionBlock;
@end
