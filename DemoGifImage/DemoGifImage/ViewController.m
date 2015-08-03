//
//  ViewController.m
//  DemoGifImage
//
//  Created by zhangshaoyu on 15/8/3.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "GifImageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Gif图片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Gif" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick:(UIBarButtonItem *)button
{
    GifImageVC *gifImageVC = [[GifImageVC alloc] init];
    [self.navigationController pushViewController:gifImageVC animated:YES];
}

@end
