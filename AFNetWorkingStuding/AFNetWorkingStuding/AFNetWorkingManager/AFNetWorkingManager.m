
//
//  AFNetWorkingManager.m
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/21.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "AFNetWorkingManager.h"

static NSString *BackgroundIdeify = @"lsh726";

@interface AFNetWorkingManager ()

@end

@implementation AFNetWorkingManager
+ (instancetype)netWorkingShare {
    static AFNetWorkingManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AFNetWorkingManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:BackgroundIdeify];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:config];
        _manager.requestSerializer.timeoutInterval = 60.0;
        _manager.requestSerializer.cachePolicy     = NSURLRequestReloadIgnoringLocalCacheData;
        [_manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json",@"application/json",@"text/javascript",@"image/gif", nil]];
    }
    return self;
}



//不需要进度条
- (void)requestMethod:(RequestMethod)method
                  url:(NSString *)url
               params:(NSDictionary *)params
              success:(SuccessBlock)success
              failure:(FaliureBlock)failure {
    [self requestMethod:method url:url params:params progress:nil success:success failure:failure];
}



//需要进度条
- (void)requestMethod:(RequestMethod)method
                  url:(NSString *)url
               params:(NSDictionary *)params
             progress:(void (^)(NSProgress * _Nonnull progress))progressBlock
              success:(SuccessBlock)success
              failure:(FaliureBlock)failure {
    __block __typeof__ (BaseModel *)model = nil;
    
    switch (method) {
        case 0: {
            [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                progressBlock(uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                model = responseObject[@"data"];
                
                success(task,model);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
                failure(task,error);
            }];
        }
            break;
            
        case 1: {
            [_manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                progressBlock(downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                success(task,model);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
                failure(task,error);
            }];
        }
            break;
        default:
            break;
    }
}


//下载
- (void)downLoadWithUrl:(NSString *_Nullable)url
               progress:(void (^_Nullable)(NSProgress * _Nonnull progress))progressBlock
                success:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))successBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];//af默认初始化相应结果为json ,根据不同的下载类型初始化相应的格式

     NSURLSessionDataTask *task = [_manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:progressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         successBlock(response,responseObject,error);
     }];
    [task resume];
    
}
@end
