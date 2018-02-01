//
//  SWShoppingItemPhotoCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photoCellClickedBlock)(NSInteger index);
typedef void(^takeNewPhotoCellClickedAction)();
typedef void(^delPhotoAction)(NSInteger index);
@interface SWShoppingItemPhotoCell : UITableViewCell
@property(nonatomic, strong) NSMutableArray *photos;
@property(nonatomic, copy)photoCellClickedBlock photoCellClicked;
@property(nonatomic, copy)takeNewPhotoCellClickedAction takeNewPhoto;
@property(nonatomic, copy)delPhotoAction delPhoto;
@end
