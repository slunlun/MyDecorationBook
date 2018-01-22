//
//  SWProductPhotoStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWProductItem.h"

@interface SWProductPhotoStorage : NSObject
+ (void)insertPhotos:(NSArray *)photos toShoppingProduct:(SWProductItem *)product;
@end
