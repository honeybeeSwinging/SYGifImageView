# SYGifImageView
gif动态图片

##使用示例

~~~ javascript

// 导入头文件
#import "SYGifImageView.h"

// 1
NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"gif"];
NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
SYGifImageView *gifImageView00 = [[SYGifImageView alloc] initWithGIFData:imageData];
gifImageView00.frame = CGRectMake(10.0, 10.0, 100.0, 100.0);
[self.view addSubview:gifImageView00];
    
// 2
SYGifImageView *gifImageView = [[SYGifImageView alloc] initWithFrame:CGRectMake(10.0, 150.0, 100.0, 100.0)];
gifImageView.gifImageName = @"success.gif";
[self.view addSubview:gifImageView];

~~~

![gifImage.gif](./gifImage.gif)