//
//  AFNetWorkingManager.h
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/21.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


typedef NS_ENUM(NSInteger, RequestMethod) {
    POST,
    GET
};

typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nullable task, BaseModel * _Nullable model);
typedef void(^FaliureBlock)(NSURLSessionDataTask * _Nullable task, NSError   * _Nullable error);


@interface AFNetWorkingManager : NSObject
+ (instancetype _Nullable )netWorkingShare;

@property (nonatomic, strong) AFHTTPSessionManager * _Nullable manager;

//- (void)setDownloadTaskDidFinishDownloadingBlock:(nullable NSURL * _Nullable  (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location))block

//- (void)dowloadResult:()

//method
//不需要进度条
- (void)requestMethod:(RequestMethod)method
                  url:(NSString *_Nullable)url
               params:(NSDictionary *_Nullable)params
              success:(SuccessBlock _Nullable )success
              failure:(FaliureBlock _Nullable)failure;


//需要进度条
- (void)requestMethod:(RequestMethod)method
                  url:(NSString *_Nullable)url
               params:(NSDictionary *_Nullable)params
             progress:(void (^_Nullable)(NSProgress * _Nonnull))progressBlock
              success:(SuccessBlock _Nullable )success
              failure:(FaliureBlock _Nullable)failure;

//下载
- (void)downLoadWithUrl:(NSString *_Nullable)url
               progress:(void (^_Nullable)(NSProgress * _Nonnull progress))progressBlock
                success:(nullable void (^)(NSURLResponse * _Nullable response, id _Nullable responseObject,  NSError * _Nullable error))successBlock;

@end
