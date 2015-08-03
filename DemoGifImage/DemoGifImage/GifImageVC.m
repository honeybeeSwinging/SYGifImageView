//
//  GifImageVC.m
//  DemoGifImage
//
//  Created by zhangshaoyu on 15/8/3.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "GifImageVC.h"
#import "SCGIFImageView.h"

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
    
    NSString *successfilePath = [[NSBundle mainBundle] pathForResource:@"success.gif" ofType:nil];
    SCGIFImageView *successgifImageView = [[SCGIFImageView alloc] initWithGIFFile:successfilePath];
    successgifImageView.frame = CGRectMake(10.0, 10.0, successgifImageView.image.size.width, successgifImageView.image.size.height);
    [self.view addSubview:successgifImageView];
    
    UIView *currentView = successgifImageView;
    
    NSString *failfilePath = [[NSBundle mainBundle] pathForResource:@"fail.gif" ofType:nil];
    SCGIFImageView *failgifImageView = [[SCGIFImageView alloc] initWithGIFFile:failfilePath];
    failgifImageView.frame = CGRectMake(currentView.frame.origin.x, currentView.frame.origin.y + currentView.frame.size.height + 10.0, 200.0, 200.0);
    failgifImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:failgifImageView];
}

@end
