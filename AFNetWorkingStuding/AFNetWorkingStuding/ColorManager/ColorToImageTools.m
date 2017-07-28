//
//  ColorToImageTools.m
//  zheft
//
//  Created by lsh726 on 2017/4/18.
//  Copyright © 2017年 zheft. All rights reserved.
//

#import "ColorToImageTools.h"

@implementation ColorToImageTools

+ (UIImage*)createImageWithColor:(UIColor*)color {
    return [self createImageWithColor:color rect:CGRectMake(0, 0, 1.0, 1.0)];
}


+ (UIImage*)createImageWithColor:(UIColor*)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
