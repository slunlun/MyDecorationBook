//
//  SWProductItem.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWProductItem : NSObject
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, assign) double price;
@property(nonatomic, assign, getter=isChoosed) BOOL choosed;
@property(nonatomic, strong) NSString *productPictures;
@end
