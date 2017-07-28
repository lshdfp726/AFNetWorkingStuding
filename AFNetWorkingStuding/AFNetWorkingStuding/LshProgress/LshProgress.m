//
//  LshProgress.m
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/24.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "LshProgress.h"
#import "ColorHex.h"

#define SQUAREWIDTH (self.frame.size.width - (MARGELEFT + MARGELEFTRIGHT) - (self.LengthArray.count - 1) * SQUARESPACE)/self.LengthArray.count   //方块宽度

#define BASEPOINTY self.frame.size.height - 25.0 //最下面的基础点
#define SQUAREHEIGHTOFFSET 70.0 //方块高度控制偏移量 ，越大 ，方块"矮小"
#define SQUAREHEIGHT  (BASEPOINTY - SQUAREHEIGHTOFFSET) //方块高度

#define MARGELEFT 60.0  //距离父视图左边
#define MARGELEFTRIGHT 20.0 //距离父视图右边
#define SQUARESPACE 25.0 //方块间距


#define CENTERPOINT_X self.bounds.size.width/2
#define CENTERPOINT_Y self.bounds.size.height/2
#define CENTERPOINT   CGPointMake(CENTERPOINT_X, CENTERPOINT_Y)
#define RADIUS        self.frame.size.width/2 - MARGELEFT

@interface LshProgress ()
@property (nonatomic, strong) dispatch_queue_t lshQueue;//所在线程
@property (nonatomic, assign) CGFloat percent;//当前进度百分比

@end

@implementation LshProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/


- (instancetype)initWithQuene:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.lshQueue = queue;//默认在主线程，尽量使用主线程！更新UI
        self.LengthArray = @[@(0.0),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(1.0)];//数值越小，位置越高，因为iOS 坐标系是反的！
        self.lineArray   = @[@(0.0),@(0.5),@(0.6),@(0.2),@(0.4),@(0.6),@(1.0)];//最后一位数组占位，数值越小，位置越高，因为iOS 坐标系是反的！
        self.bottomArray = @[@"1000",@"100",@"100",@"100",@"100",@"100",@"100"];
    }
    return self;
}

#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        self.LengthArray = @[@(0.0),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(1.0)];//数值越小，位置越高，因为iOS 坐标系是反的！
        self.lineArray   = @[@(0.0),@(0.5),@(0.6),@(0.2),@(0.4),@(0.6),@(1.0)];//最后一位数组占位，数值越小，位置越高，因为iOS 坐标系是反的！
        self.bottomArray = @[@"1000",@"100",@"100",@"100",@"100",@"100",@"100"];
        
    }
    return self;
}


//绘制UI
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //上部售额、订单量UI
    [self drawTopUI:context];
    
    //中间两条线和 元／笔
    [self drawLine:context];

    //绘制UI
    [self drawUI:context];
    
    //画底部坐标
    [self drawBottomCoordinate];
    
}


#pragma mark 上部 售额、订单量UI
- (void)drawTopUI:(CGContextRef)context {
    //销售额方框
    CGRect saleRect = CGRectMake(self.frame.size.width/2 - 65.0 - 20.0 - 14.0, self.frame.size.height * 39/350, 20.0, 8.0);
    UIBezierPath *salePath = [UIBezierPath bezierPathWithRect:saleRect];
    salePath.lineWidth = 1.0;
    salePath.lineJoinStyle = kCGLineCapRound;
    [self prepGradient:context path:salePath.CGPath colors:@[(__bridge id)[ColorHex colorWithHexString:@"0x97c7fc"].CGColor,(__bridge id)[ColorHex colorWithHexString:@"0x65a0e1"].CGColor]];
    
    NSString *saleStr = @"销售额";
    CGRect sale = CGRectMake(self.frame.size.width/2 - 65.0, saleRect.origin.y - (22 - 8.0)/2, 55.0, 22.0);//以view的X中点为基准点，像两边约束UI
    [saleStr drawInRect:sale withAttributes:@{NSFontAttributeName           :[UIFont systemFontOfSize:16.0],
                                              NSForegroundColorAttributeName:[ColorHex colorWithHexString:@"0x333333"]}];
    
    
    //订单量方框
    CGRect orderRect = CGRectMake(self.frame.size.width/2 + 10.0, saleRect.origin.y + 3.0, 16.0,2.0);
    UIBezierPath *orderPath = [UIBezierPath bezierPathWithRect:orderRect];
    orderPath.lineWidth     = 1.0;
    orderPath.lineJoinStyle = kCGLineCapRound;
    [self prepGradient:context path:orderPath.CGPath colors:@[(__bridge id)[ColorHex colorWithHexString:@"0xf8e81c"].CGColor]];
    
    NSString *orderStr = @"订单量";
    CGRect order = CGRectMake(orderRect.origin.x + orderRect.size.width + 14.0, orderRect.origin.y - (22.0 -2)/2, 55.0, 22.0);
    [orderStr drawInRect:order withAttributes:@{NSFontAttributeName           :[UIFont systemFontOfSize:16.0],
                                                NSForegroundColorAttributeName:[ColorHex colorWithHexString:@"0x333333"]}];
}


#pragma mark - 底部坐标
- (void)drawBottomCoordinate {
    [[ColorHex colorWithHexString:@"0xe1e1e1"] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2.0;
    [path moveToPoint:CGPointMake(MARGELEFT, BASEPOINTY + 5.0)];
    [path addLineToPoint:CGPointMake(MARGELEFT + (self.bottomArray.count -1) * (SQUAREWIDTH + SQUARESPACE) + SQUAREWIDTH, BASEPOINTY + 5.0)];
    [path stroke];

    [self.bottomArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *content = (NSString *)obj;
        NSDictionary *attribute = @{NSFontAttributeName            :[UIFont systemFontOfSize:18],
                                    NSForegroundColorAttributeName :[UIColor blackColor]};
        CGRect contentRect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        [content drawInRect:CGRectMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE), BASEPOINTY + 7.0, contentRect.size.width, contentRect.size.height) withAttributes:attribute];
    }];
}


- (void)prepGradient:(CGContextRef)context path:(CGPathRef)path colors:(NSArray *)colors {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.2,1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors ,locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint start = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint end   = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


#pragma mark - 中间两条线和单位
- (void)drawLine:(CGContextRef)context {
    [[ColorHex colorWithHexString:@"0xf5f5f5"] setStroke];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 1.0;
    
    //第一条线
    [linePath moveToPoint:CGPointMake(0, SQUAREHEIGHT /3 + SQUAREHEIGHTOFFSET)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, SQUAREHEIGHT /3 + SQUAREHEIGHTOFFSET)];
    
    //第二条线
    [linePath moveToPoint:CGPointMake(0, SQUAREHEIGHT * 2/3 + SQUAREHEIGHTOFFSET)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, SQUAREHEIGHT * 2/3 + SQUAREHEIGHTOFFSET)];
    [linePath stroke];
    
    NSString *firstLeftUnitUp = @"2000元";
    CGRect firstRectUp = CGRectMake(0,  SQUAREHEIGHT /3 + SQUAREHEIGHTOFFSET - 30, 50.0, 17.0);
    [firstLeftUnitUp drawInRect:firstRectUp withAttributes:@{NSFontAttributeName            :[UIFont systemFontOfSize:12.0],
                                                      NSForegroundColorAttributeName :[ColorHex colorWithHexString:@"0x333333"]}];
    
    NSString *firstLeftUnitDown = @"100笔";
    CGRect firstRectDown = CGRectMake(0, SQUAREHEIGHT /3 + SQUAREHEIGHTOFFSET - 16.0, 50.0, 17.0);
    [firstLeftUnitDown drawInRect:firstRectDown withAttributes:@{NSFontAttributeName            :[UIFont systemFontOfSize:12.0],
                                                                 NSForegroundColorAttributeName :[ColorHex colorWithHexString:@"0x333333"]}];
    
    
    NSString *secondLeftUnitUp = @"1000元";
    CGRect secondRectUp  = CGRectMake(0, SQUAREHEIGHT * 2/3 + SQUAREHEIGHTOFFSET - 30.0, 50.0, 17.0);
    [secondLeftUnitUp drawInRect:secondRectUp withAttributes:@{NSFontAttributeName            :[UIFont systemFontOfSize:12.0],
                                                                NSForegroundColorAttributeName :[ColorHex colorWithHexString:@"0x333333"]}];
    
    NSString *secondLeftUnitDown = @"50笔";
    CGRect secondRectDown = CGRectMake(0, SQUAREHEIGHT * 2/3 + SQUAREHEIGHTOFFSET - 16.0, 50.0, 17.0);
    [secondLeftUnitDown drawInRect:secondRectDown withAttributes:@{NSFontAttributeName            :[UIFont systemFontOfSize:12.0],
                                                                 NSForegroundColorAttributeName :[ColorHex colorWithHexString:@"0x333333"]}];
}


#pragma mark - 图表UI
- (void)drawUI:(CGContextRef)context {
    [[UIColor redColor] setStroke];
    [[UIColor blueColor] setFill];
    //方块贝塞尔曲线
    UIBezierPath *path = [UIBezierPath  bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    [self.LengthArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat ratio = [obj floatValue];
        [path moveToPoint:CGPointMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE) , BASEPOINTY)]; //起始点
        [path addLineToPoint:CGPointMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE), SQUAREHEIGHT * ratio + SQUAREHEIGHTOFFSET)];//第一条上去的线
        [path addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH + idx * (SQUAREWIDTH + SQUARESPACE), SQUAREHEIGHT * ratio + SQUAREHEIGHTOFFSET)];//第二条横线线
        [path addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH + idx * (SQUAREWIDTH + SQUARESPACE), BASEPOINTY)];//第三条下来的线
        [self prepGradient:context  path:path.CGPath colors:@[(__bridge id)[ColorHex colorWithHexString:@"0x97c7fc"].CGColor,(__bridge id)[ColorHex colorWithHexString:@"0x65a0e1"].CGColor]];
    }];
    

    //设置折线的颜色
    [[UIColor yellowColor] set];
    //折线曲线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 1.0;
    [self.lineArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat lineRadio = 0;
        lineRadio = [self.lineArray[idx] floatValue];//折线所占比例
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        circlePath.lineWidth = 1.0;
        //画圆圈
        [circlePath addArcWithCenter:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + idx * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT * lineRadio + SQUAREHEIGHTOFFSET ) radius:2.0 startAngle:0 endAngle:M_PI * 2 clockwise:0];
        [circlePath stroke];
        [circlePath fill];
        
        //折线
        [linePath moveToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + idx * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT * lineRadio + SQUAREHEIGHTOFFSET )];//第N个方块的x中点位置
        if (idx < self.lineArray.count - 1) {//下一个方块的中点
            [linePath addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + (idx + 1) * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT *  [self.lineArray[idx + 1] floatValue] + SQUAREHEIGHTOFFSET)];
        }
    }];
    [linePath stroke];
    [linePath fill];

}


/**
 根据二次贝萨尔曲线拐点计算公式推到，Pc = (1-t)*(1-t)*P0 + 2*t(1-t)*P1 + t*t*P2
 t是0-1 之间任意值，P0 是起始点，P2 是终点 ， Pc 是Po 和P2曲线上任意一点，P1 就是我们要的拐点，为了计算方便，而且图形漂亮
 令 t = 0.5   Pc 就是圆弧上的中点， 可以根据半径加弧度推算出来
 最终 P1 = 2Pc - 1/2*(P0+P1)
 对应的二位坐标系上的P1(x,y) = P1(2Pcx - 1/2*(P0x + P1x),2Pcy - 1/2*(P0y + P1y))
 */
//- (CGPoint)calculateBreakPoint:(CGFloat)radius pointStart:(CGPoint)startP pointEnd:(CGPoint)endP angle:(CGFloat)angle {
//    CGPoint breakPoint = CGPointZero;//拐点
//    CGPoint centerP = CGPointMake(radius * cos(angle/2), radius * sin(angle/2));//去弧度的中心点
//    breakPoint = CGPointMake((centerP.x - startP.x)/2, 2 * centerP.y - 0.5 * (startP.y + endP.y));
//    return breakPoint;
//}


- (void)cricle {
    [[UIColor redColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    path.miterLimit = 10.0;
    path.flatness = 10.0;
    path.usesEvenOddFillRule = YES;
    [path moveToPoint:CENTERPOINT];
    if (self.percent > 0) {
        [path addArcWithCenter:CENTERPOINT radius:CENTERPOINT_X startAngle:0 endAngle:M_PI * 2 * self.percent clockwise:YES];
    }
    [path closePath];
    [path stroke];
    [path fill];
}

//设置进度
- (void)sertProgress:(CGFloat)percent {
    dispatch_async(self.lshQueue, ^{
        self.percent = percent;
        [self setNeedsDisplay];//绘制调用
    });
}


@end
