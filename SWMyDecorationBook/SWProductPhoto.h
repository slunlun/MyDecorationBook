//
//  SWProductPhoto.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SWProductItem.h"

@interface SWProductPhoto : NSObject
- (instancetype)initWithProductItem:(SWProductItem *)ownerProduct image:(UIImage *)photo;
@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, strong) NSDate *createTime;
@property(nonatomic, strong) SWProductItem *ownerProductItem;
@end
