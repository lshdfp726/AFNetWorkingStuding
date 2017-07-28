//
//  ColorHex.h
//  zheft
//
//  Created by lsh726 on 2017/5/5.
//  Copyright © 2017年 zheft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorHex : NSObject
+ (UIColor *)colorWithHexString:(NSString*)hex;
+ (UIColor *)colorWithHex:(uint) hex;
+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha;
@end
