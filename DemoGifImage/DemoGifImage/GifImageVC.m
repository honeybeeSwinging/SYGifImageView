//
//  GifImageVC.m
//  DemoGifImage
//
//  Created by zhangshaoyu on 15/8/3.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "GifImageVC.h"
#import "SYGifImageView.h"

@interface GifImageVC ()

@end

@implementation GifImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Gif";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建视图

- (void)setUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
////    NSString *successfilePath = [[NSBundle mainBundle] pathForResource:@"success.gif" ofType:nil];
//    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"gif"];
//    SYGifImageView *gifImageView = [[SYGifImageView alloc] initWithGIFFile:imageFile];
//    gifImageView.frame = CGRectMake(10.0, 10.0, 100.0, 100.0);
//    [self.view addSubview:gifImageView];
    
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
    SYGifImageView *gifImageView00 = [[SYGifImageView alloc] initWithGIFData:imageData];
    gifImageView00.frame = CGRectMake(10.0, 10.0, 100.0, 100.0);
    [self.view addSubview:gifImageView00];
    
    SYGifImageView *gifImageView = [[SYGifImageView alloc] initWithFrame:CGRectMake(10.0, 150.0, 100.0, 100.0)];
    gifImageView.gifImageName = @"success.gif";
    [self.view addSubview:gifImageView];
}

@end
