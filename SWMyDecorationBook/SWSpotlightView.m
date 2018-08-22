//
//  SWSpotlightView.m
//  SWSpotLightView
//
//  Created by Eren on 2018/8/15.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWSpotlightView.h"
#define VIEW_ALPHA 0.6
@interface SWSpotlightView()
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, strong) UILabel *spolightLab;
@end

@implementation SWSpotlightView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
         [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:VIEW_ALPHA]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)backgroundTapped:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(spotlightViewDidTapped:)]) {
        [self.delegate spotlightViewDidTapped:self];
    }
}


- (void)updateSpotlightView {
    //label
    UIFont *ft = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize sz =[self.spotlightText boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ft} context:nil].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width / 2 - sz.width/2),
                                                               floorf(self.frame.size.height / 2 - sz.height/2),
                                                               floorf(sz.width),
                                                               floorf(sz.height +10
                                                                      ))];
    [label setTextColor:[UIColor whiteColor]];
    
    
    
    [label setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin
                                | UIViewAutoresizingFlexibleRightMargin
                                | UIViewAutoresizingFlexibleLeftMargin
                                | UIViewAutoresizingFlexibleBottomMargin
                                )];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:ft];
    [label setAdjustsFontSizeToFitWidth:true];
    [label setText:self.spotlightText];
    [label setNumberOfLines:0];
    [_spolightLab removeFromSuperview];
    _spolightLab = label;
    [self addSubview:_spolightLab];
    if(!CGPointEqualToPoint(self.spolightPoint, CGPointZero)) {
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (CGPointEqualToPoint(self.spolightPoint, CGPointZero)) {
        return;
    }
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //在上下文中创建一个背景图
    CGImageRef backgroundImage = CGBitmapContextCreateImage(context);
    //将当前context压入堆栈，保存现在的context状态
    CGContextSaveGState(context);
    //翻转上下文(由于图像遮罩时使用的CG坐标，和context坐标正好相反，因此要先翻转context，画出mask位置后，再翻转回来context,然后在CG坐标中生成的mask图片，才可以正确的摆放到context中)
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色分量的数组
    CGFloat white[4] = {1.0,1.0,1.0,1.0};
    // 创建终点颜色分量的数组
    CGFloat black[4] = {0.0,0.0,0.0,VIEW_ALPHA};
    CGFloat components[8] = {
        white[0],white[1],white[2],white[3],
        black[0],black[1],black[2],black[3],
    };
    // 起点和终点颜色位置
    CGFloat colorLocations[2] = {0.25,0.5};
    //创建渐变梯度CGGradientRef
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorspace, components, colorLocations, 2);
    
    //创建一个径向渐变
    CGContextDrawRadialGradient(context, gradientRef, self.spolightPoint, 0.0f, self.spolightPoint, self.spolightRadius, 0);
    //释放渐变对象
    CGGradientRelease(gradientRef);
    
    //恢复到之前的context
    CGContextRestoreGState(context);
    
    // maskImage是一个径向渐变的聚光灯图片
    CGImageRef maskImage = CGBitmapContextCreateImage(context);

    // 根据聚光灯图片生成聚光灯遮罩（色值为1.0表示透明，0.0表示完全不透明）
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                        CGImageGetHeight(maskImage),
                                        CGImageGetBitsPerComponent(maskImage),
                                        CGImageGetBitsPerPixel(maskImage),
                                        CGImageGetBytesPerRow(maskImage),
                                        CGImageGetDataProvider(maskImage),
                                        NULL,
                                        FALSE);
    
    // 用聚光灯遮罩处理原始背景图，得到镂空的原始背景图 masked
    CGImageRef masked = CGImageCreateWithMask(backgroundImage, mask);
    CGImageRelease(backgroundImage);
    // 清空之前绘制的渐变颜色
    CGContextClearRect(context, rect);
    // 清空后，仅仅将masked图片加入到context上
    CGContextDrawImage(context, rect, masked);

    CGImageRelease(maskImage);
    CGImageRelease(mask);
    CGImageRelease(masked);
}


@end
