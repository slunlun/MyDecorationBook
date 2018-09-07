//
//  UIImage+SWImageExt.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/7.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "UIImage+SWImageExt.h"

@implementation UIImage (SWImageExt)
- (UIImage *)scaleImagetoSize:(CGSize)size {
    if (!CGSizeEqualToSize(self.size, size)) {
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }else {
        return self;
    }
}
@end
