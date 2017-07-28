//
//  ColorToImageTools.h
//  zheft
//
//  Created by lsh726 on 2017/4/18.
//  Copyright © 2017年 zheft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorToImageTools : NSObject
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage*)createImageWithColor:(UIColor*)color rect:(CGRect)rect;
@end
