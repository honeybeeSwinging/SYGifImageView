//
//  SYGifImageView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/12/22.
//  Copyright © 2015年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYGifFrame;

@interface SYGifImageView : UIImageView

/// 实例化，图片名称地址
- (instancetype)initWithGIFFile:(NSString *)gifFilePath;

/// 实例化，图片二进制数据
- (instancetype)initWithGIFData:(NSData *)gifImageData;

/// 设置gif图片
@property (nonatomic, strong) NSString *gifImageName;

@end
