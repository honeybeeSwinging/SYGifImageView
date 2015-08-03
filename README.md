# GifImage
gif动态图片

##使用示例

~~~ javascript
// 1
NSString *successfilePath = [[NSBundle mainBundle] pathForResource:@"success.gif" ofType:nil];
SCGIFImageView *successgifImageView = [[SCGIFImageView alloc] initWithGIFFile:successfilePath];
successgifImageView.frame = CGRectMake(10.0, 10.0, successgifImageView.image.size.width, successgifImageView.image.size.height);
[self.view addSubview:successgifImageView];
    
UIView *currentView = successgifImageView;
    
// 2
NSString *failfilePath = [[NSBundle mainBundle] pathForResource:@"fail.gif" ofType:nil];
SCGIFImageView *failgifImageView = [[SCGIFImageView alloc] initWithGIFFile:failfilePath];
failgifImageView.frame = CGRectMake(currentView.frame.origin.x, currentView.frame.origin.y + currentView.frame.size.height + 10.0, 200.0, 200.0);
failgifImageView.contentMode = UIViewContentModeScaleAspectFit;
[self.view addSubview:failgifImageView];
~~~
