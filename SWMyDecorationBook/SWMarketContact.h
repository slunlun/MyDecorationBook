//
//  SWMarketContact.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMarketContact : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *telNum;
@property(nonatomic, assign, getter=isDefaultContact) BOOL defaultContact;
@end
