//
//  ViewController.m
//  AFNetWorkingStuding
//
//  Created by fns on 2017/7/19.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "ViewController.h"
#import "AFNetWorkingManager.h"
#import "LshProgress.h"
#import "Masonry.h"

#define URL @"http://112.17.14.29/cache/xiazai.xmindchina.cn/trail/xmind-8-macosx.dmg?ich_args2=404-25135011034723_e6d1daf1cbd24cd28867efe1bb262bc3_10001002_9c89642cdec5f0d9943a518939a83798_9c951eca64b92bbb9d22af197ba82f05"

@interface ViewController ()
@property (nonatomic, strong) LshProgress *lshProgress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.view setBackgroundColor:[UIColor colorWithRed:37.0/255.0 green:53.0/255.0 blue:80.0/255.0 alpha:1.0]];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];

    _lshProgress = [[LshProgress alloc] initWithQuene:dispatch_get_main_queue()];
    [_lshProgress setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:_lshProgress];
    [_lshProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(200);
        make.bottom.equalTo(self.view).offset(-20.0);
    }];
    
}


- (void)create {
    [[AFNetWorkingManager netWorkingShare] downLoadWithUrl:URL progress:^(NSProgress * _Nonnull progress) {
        CGFloat percent = (CGFloat)progress.completedUnitCount/(CGFloat)progress.totalUnitCount;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_lshProgress sertProgress:percent];
//        });
        NSLog(@"%f",percent);
    } success:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self saveData:responseObject];
    }];
}


- (void)saveData:(id)responseObject {
    if (![responseObject isKindOfClass:[UIImage class]]) {
        return;
    }
    
    UIImage *sourceImage = [self scaleImage:(UIImage *)responseObject toSize:CGSizeMake(320, 480)];
    NSString *destionPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"image"];
    if ([UIImageJPEGRepresentation(sourceImage, 0.5) writeToFile:destionPath atomically:YES]) {
        NSLog(@"文件写入成功");
    }
}


//调整图片大小
- (UIImage *)scaleImage:(UIImage *)sourceImage toSize:(CGSize)size {
    CGFloat sourceWidth  = sourceImage.size.width;
    CGFloat sourceHeight = sourceImage.size.height;
    if (sourceWidth/sourceHeight > size.width/size.height) {
         UIGraphicsBeginImageContext(sourceImage.size);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    return scaleImage;
}


- (BOOL)shouldAutorotate{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
