//
//  BaseModel.h
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/21.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSInteger code;

@end
