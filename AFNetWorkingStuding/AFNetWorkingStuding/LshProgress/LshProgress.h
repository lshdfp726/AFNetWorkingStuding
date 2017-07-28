//
//  LshProgress.h
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/24.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProgressType) {
    CirCle, //圈
    squareness //矩形
};


@interface LshProgress : UIView

- (instancetype)initWithQuene:(dispatch_queue_t)queue;


//- (void)sertProgress:(CGFloat)percent;

@property (nonatomic, copy) NSArray *LengthArray;//纵轴长度数据源
@property (nonatomic, copy) NSArray *lineArray;//折线数据源
@property (nonatomic, copy) NSArray *bottomArray;//底部坐标数据源
@end
