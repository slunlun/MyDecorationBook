//
//  SWPieChat.m
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWPieChat.h"
@interface SWPieChatSegment()
@property(nonatomic, assign) CGFloat centerAngle;
@property(nonatomic, strong) CAShapeLayer *segmentLayer;
@end

@implementation SWPieChatSegment
- (instancetype)initWithValue:(CGFloat)value title:(NSString *)title color:(UIColor *)color {
    if (self = [super init]) {
        _segmentValue = value;
        _segmentTitle = title;
        _segmentColor = color;
    }
    return self;
}
@end


@interface SWPieChat()<CAAnimationDelegate>
@property(nonatomic, strong) NSArray<SWPieChatSegment *> *proportions;
@property(nonatomic, strong) CALayer *bkLayer;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat totalCount;
@end


@implementation SWPieChat

- (void)drawRect:(CGRect)rect {
    // 绘制圆环背景
    CGFloat sideLength = MIN(self.bounds.size.width, self.bounds.size.height);
    CGRect outRect = CGRectMake(5, 5, sideLength - 10, sideLength - 10);
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *outPath = [UIBezierPath bezierPathWithOvalInRect:outRect];
    [path appendPath:outPath];
    [[UIColor lightGrayColor] set];
    [path fill];
    
    // 根据proportions填充饼图
    CGFloat startAngle = -M_PI_2;
    CGFloat totalAngel = 2 * M_PI;
    CGFloat radius = (sideLength - 25)/2;
    CGPoint pieCenter = CGPointMake(CGRectGetMidX(outRect), CGRectGetMidY(outRect));
    self.pieCenter = pieCenter;
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:startAngle endAngle:totalAngel clockwise:YES];
    [backgroundLayerPath closePath];
    CAShapeLayer *bkLayer = [[CAShapeLayer alloc] init];
    bkLayer.path = backgroundLayerPath.CGPath;
    bkLayer.fillColor = [UIColor greenColor].CGColor;
    bkLayer.position = pieCenter;
    [self.layer addSublayer:bkLayer];
    self.bkLayer = bkLayer;
    
   
    for (SWPieChatSegment *segment in self.proportions) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addArcWithCenter:CGPointZero radius:radius startAngle:startAngle endAngle:startAngle + segment.segmentRatio * totalAngel clockwise:YES];
        [path closePath];
        CAShapeLayer *newLayer = [[CAShapeLayer alloc] init];
        newLayer.fillColor = segment.segmentColor.CGColor;
        newLayer.path = path.CGPath;
        [bkLayer addSublayer:newLayer];
        
        segment.segmentLayer = newLayer;
        segment.centerAngle = startAngle + (segment.segmentRatio * totalAngel)/2;
        startAngle += segment.segmentRatio * totalAngel;
    }
    
    

    // 添加总额的圆圈
    CALayer *countBackgourLayer = [CALayer layer];
    countBackgourLayer.bounds = CGRectMake(0, 0, 120, 120);
    countBackgourLayer.cornerRadius = 60;
    countBackgourLayer.masksToBounds = YES;
    countBackgourLayer.position = pieCenter;
    countBackgourLayer.backgroundColor = [UIColor blackColor].CGColor;
    countBackgourLayer.opacity = 0.2f;
    
    
    CATextLayer *countTextLayer = [CATextLayer layer];
    countTextLayer.bounds = CGRectMake(0, 0, 100, 36);
    countTextLayer.position = pieCenter;
    countTextLayer.contentsScale = [UIScreen mainScreen].scale;
    NSString *totalValueStr = [NSString stringWithFormat:@"%.2f", self.totalCount];
    countTextLayer.string = [NSString stringWithFormat:@"总计\n%@", totalValueStr];
    countTextLayer.fontSize = 15;
    countTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    countTextLayer.alignmentMode = kCAAlignmentCenter;
    [self.layer addSublayer:countBackgourLayer];
    [self.layer addSublayer:countTextLayer];
   
    
    // 添加边缘半透明的圆环
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithArcCenter:pieCenter radius:radius - 4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *ringLayer = [CAShapeLayer layer];
    ringLayer.path = ringPath.CGPath;
    ringLayer.strokeColor = [UIColor whiteColor].CGColor;
    ringLayer.fillColor = [UIColor clearColor].CGColor;
    ringLayer.lineWidth = 8;
    ringLayer.opacity = 0.2f;
    [self.layer addSublayer:ringLayer];
    
    
    //  逐步显示动画
    // 添加mask layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = backgroundLayerPath.CGPath;
    maskLayer.strokeEnd = 0;
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.lineWidth =  2*radius;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    bkLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0f;
    animation.fromValue = @0;
    animation.toValue = @1;
    // 自动还原
    animation.autoreverses = NO;
    // 结束后是否移除
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    // 让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:@"strokeEnd" forKey:@"AnimationKey"];
    [maskLayer addAnimation:animation forKey:@"strokeEnd"];
    
}
#pragma mark - Public interface / Update UI
- (void)updateProportions:(NSArray<SWPieChatSegment *>*)proportions {
    self.proportions = proportions;
    
    for (SWPieChatSegment *segment in proportions) {
        self.totalCount += segment.segmentValue;
    }
    
    for (SWPieChatSegment *segment in proportions) {
        segment.segmentRatio = segment.segmentValue / self.totalCount;
    }
    
    if (self.proportions) {
        [self setNeedsDisplay];
    }
}

#pragma mark - Gesture Recognizer
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   
       UITouch *touch = [touches anyObject];
    
        NSUInteger toucheNum = [[event allTouches] count];//有几个手指触摸屏幕
        if ( toucheNum > 1 ) {
            return;//多个手指不执行旋转
        }
        
        //_view，你想旋转的视图
        if (![touch.view isEqual:self]) {
            return;
        }
        
        /**
         CGRectGetHeight 返回控件本身的高度
         CGRectGetMinY 返回控件顶部的坐标
         CGRectGetMaxY 返回控件底部的坐标
         CGRectGetMinX 返回控件左边的坐标
         CGRectGetMaxX 返回控件右边的坐标
         CGRectGetMidX 表示得到一个frame中心点的X坐标
         CGRectGetMidY 表示得到一个frame中心点的Y坐标
         */
        
        CGPoint center = self.pieCenter;
        CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
        CGPoint previousPoint = [touch previousLocationInView:touch.view];//上一个坐标
        
        /**
         求得每次手指移动变化的角度
         atan2f 是求反正切函数 参考:http://blog.csdn.net/chinabinlang/article/details/6802686
         */
        CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x) - atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
   
        self.bkLayer.affineTransform = CGAffineTransformRotate(self.bkLayer.affineTransform, angle);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {

    CGAffineTransform layerTransform = CGAffineTransformInvert(self.bkLayer.affineTransform);
    // 根据当前的变换矩阵，反向变换 testPoint，使得testPoint仍然在初始坐标系下的(0, 20)点
    CGPoint testPoint = CGPointApplyAffineTransform(CGPointMake(0, 20), layerTransform);
    for (SWPieChatSegment *segment in  self.proportions) {
        if (CGPathContainsPoint(segment.segmentLayer.path, nil, testPoint, false)) {
            CGFloat slideAngel = M_PI_2 - segment.centerAngle;
            self.bkLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, slideAngel);
        
            if ([self.delegate respondsToSelector:@selector(pieChat:didSelectSegment:)]) {
                [self.delegate pieChat:self didSelectSegment:segment];
            }
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"strokeEnd"]) {
            // 移除动画
            self.bkLayer.mask = nil;
            [self.bkLayer removeAnimationForKey:@"strokeEnd"];
            
            // 将重心旋转到比例最大的segment
            SWPieChatSegment *maxRatioSegment = self.proportions.firstObject;
            for (SWPieChatSegment *segment in self.proportions) {
                if (maxRatioSegment.segmentRatio < segment.segmentRatio) {
                    maxRatioSegment = segment;
                }
            }
            // 这里延迟执行一下，不然会有残影
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGFloat slideAngel = M_PI_2 - maxRatioSegment.centerAngle;
                self.bkLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, slideAngel);
                
                // 通知deleaget 完成了显示
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(pieChatDidShow:defaultSegment:)]) {
                        [self.delegate pieChatDidShow:self defaultSegment:maxRatioSegment];
                    }
                }
            });
          
        }
    }
}

@end
