//
//  SWOrderInfoPhotoTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^photoCellClickedBlock)(NSInteger index);
@interface SWOrderInfoPhotoTableViewCell : UITableViewCell
@property(nonatomic, strong) NSMutableArray *photos;
@property(nonatomic, copy)photoCellClickedBlock photoCellClicked;
@end
