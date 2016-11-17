//
//  SYGifImageView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/12/22.
//  Copyright © 2015年 zhangshaoyu. All rights reserved.
//

#import "SYGifImageView.h"
#import "SYGifFrame.h"

@interface SYGifImageView ()

@property (nonatomic, strong) NSData *pointerData;
@property (nonatomic, strong) NSMutableData *bufferData;
@property (nonatomic, strong) NSMutableData *screenData;
@property (nonatomic, strong) NSMutableData *globalData;
@property (nonatomic, strong) NSMutableArray *framesArray;
@property (nonatomic, strong) NSMutableArray *gifFramesArray;

@property (nonatomic, assign) NSInteger sortedInt;
@property (nonatomic, assign) NSInteger colorSInt;
@property (nonatomic, assign) NSInteger colorCInt;
@property (nonatomic, assign) NSInteger colorFInt;
@property (nonatomic, assign) NSInteger pointerInt;

- (void)loadImageData;

+ (NSMutableArray *)getGifImageFrames:(NSData *)gifImageData;

- (void)decodeGIFImageWithImageData:(NSData *)GIFData;
- (void)GifImageReadExtensions;
- (void)GifImageReadDescriptor;

+ (BOOL)isGifImage:(NSData *)imageData;
- (BOOL)GIFGetBytes:(NSInteger)length;
- (BOOL)GIFSkipBytes:(NSInteger)length;

- (NSData *)getFrameAsDataAtIndex:(NSInteger)index;
- (UIImage *)getFrameAsImageAtIndex:(NSInteger)index;

@end

@implementation SYGifImageView

#pragma mark - 实例化

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    
    return self;
}

- (instancetype)initWithGIFFile:(NSString *)gifFilePath
{
    NSData *imageData = [NSData dataWithContentsOfFile:gifFilePath];
    id object = [self initWithGIFData:imageData];
    return object;
}

- (instancetype)initWithGIFData:(NSData *)gifImageData
{
    if (gifImageData.length < 4)
    {
        return nil;
    }
    
    BOOL isGifImage = [SYGifImageView isGifImage:gifImageData];
    if (!isGifImage)
    {
        UIImage *image = [UIImage imageWithData:gifImageData];
        id object = [super initWithImage:image];
        return object;
    }
    
    [self decodeGIFImageWithImageData:gifImageData];
    
    if (self.framesArray.count <= 0)
    {
        UIImage *image = [UIImage imageWithData:gifImageData];
        id object = [super initWithImage:image];
        return object;
    }
    
    self = [super init];
    if (self)
    {
        [self loadImageData];
    }
    
    return self;
}

- (void)dealloc
{
    if (self.bufferData != nil)
    {
        self.bufferData = nil;
    }
    if (self.screenData != nil)
    {
        self.screenData = nil;
    }
    if (self.globalData != nil)
    {
        self.globalData = nil;
    }
    self.framesArray = nil;
}

#pragma mark - methord

+ (BOOL)isGifImage:(NSData *)imageData
{
    const char * buf = (const char*)[imageData bytes];
    if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38)
    {
        return YES;
    }
    return NO;
}

+ (NSMutableArray *)getGifImageFrames:(NSData *)gifImageData
{
    SYGifImageView *gifImageView = [[SYGifImageView alloc] initWithGIFData:gifImageData];
    if (!gifImageView)
    {
        return nil;
    }
    
    NSMutableArray *gifFrames = gifImageView.gifFramesArray;
    return gifFrames;
}

- (void)setGIF_frames:(NSMutableArray *)gifFrames
{
    if (self.framesArray)
    {
        self.framesArray = nil;
    }
    self.framesArray = gifFrames;
    
    [self loadImageData];
}

- (void)loadImageData
{
    // Add all subframes to the animation
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.framesArray count]; i++)
    {
        UIImage *image = [self getFrameAsImageAtIndex:i];
        [array addObject: image];
    }
    
    NSMutableArray *overlayArray = [[NSMutableArray alloc] init];
    UIImage *firstImage = [array objectAtIndex:0];
    CGSize size = firstImage.size;
    CGRect rect = CGRectZero;
    rect.size = size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    int i = 0;
    SYGifFrame *lastFrame = nil;
    for (UIImage *image in array)
    {
        // Get Frame
        SYGifFrame *frame = [self.framesArray objectAtIndex:i];
        
        // Initialize Flag
        UIImage *previousCanvas = nil;
        
        // Save Context
        CGContextSaveGState(ctx);
        // Change CTM
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextTranslateCTM(ctx, 0.0, -size.height);
        
        // Check if lastFrame exists
        CGRect clipRect;
        
        // Disposal Method (Operations before draw frame)
        switch (frame.disposalMethod)
        {
            case 1:
            {
                // Do not dispose (draw over context)
                // Create Rect (y inverted) to clipping
                clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                // Clip Context
                CGContextClipToRect(ctx, clipRect);
            }
                break;
            case 2:
            {
                // Restore to background the rect when the actual frame will go to be drawed
                // Create Rect (y inverted) to clipping
                clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                // Clip Context
                CGContextClipToRect(ctx, clipRect);
            }
                break;
            case 3:
            {
                // Restore to Previous
                // Get Canvas
                previousCanvas = UIGraphicsGetImageFromCurrentImageContext();
                
                // Create Rect (y inverted) to clipping
                clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                // Clip Context
                CGContextClipToRect(ctx, clipRect);
            }
                break;
        }
        
        // Draw Actual Frame
        CGContextDrawImage(ctx, rect, image.CGImage);
        // Restore State
        CGContextRestoreGState(ctx);
        
        //delay must larger than 0, the minimum delay in firefox is 10.
        if (frame.delay <= 0)
        {
            frame.delay = 10;
        }
        [overlayArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
        
        // Set Last Frame
        lastFrame = frame;
        
        // Disposal Method (Operations afte draw frame)
        switch (frame.disposalMethod)
        {
            case 2:
            {
                // Restore to background color the zone of the actual frame
                // Save Context
                CGContextSaveGState(ctx);
                // Change CTM
                CGContextScaleCTM(ctx, 1.0, -1.0);
                CGContextTranslateCTM(ctx, 0.0, -size.height);
                // Clear Context
                CGContextClearRect(ctx, clipRect);
                // Restore Context
                CGContextRestoreGState(ctx);
            }
                break;
            case 3:
            {
                // Restore to Previous Canvas
                // Save Context
                CGContextSaveGState(ctx);
                // Change CTM
                CGContextScaleCTM(ctx, 1.0, -1.0);
                CGContextTranslateCTM(ctx, 0.0, -size.height);
                // Clear Context
                CGContextClearRect(ctx, lastFrame.area);
                // Draw previous frame
                CGContextDrawImage(ctx, rect, previousCanvas.CGImage);
                // Restore State
                CGContextRestoreGState(ctx);
            }
                break;
        }
        
        // Increment counter
        i++;
    }
    UIGraphicsEndImageContext();
    
    UIImage *image = overlayArray[0];
    [self setImage:image];
    [self setAnimationImages:overlayArray];
    
    overlayArray = nil;
    array = nil;
    
    // Count up the total delay, since Cocoa doesn't do per frame delays.
    double total = 0;
    for (SYGifFrame *frame in self.framesArray)
    {
        total += frame.delay;
    }
    
    // GIFs store the delays as 1/100th of a second,
    // UIImageViews want it in seconds.
    [self setAnimationDuration:total / 100];
    
    // Repeat infinite
    [self setAnimationRepeatCount:0];
    
    [self startAnimating];
}

- (void)decodeGIFImageWithImageData:(NSData *)GIFData
{
    self.pointerData = GIFData;
    
    if (self.bufferData != nil)
    {
        self.bufferData = nil;
    }
    if (self.screenData != nil)
    {
        self.screenData = nil;
    }
    if (self.globalData != nil)
    {
        self.globalData = nil;
    }
    self.framesArray = nil;
    
    self.bufferData = [[NSMutableData alloc] init];
    self.screenData = [[NSMutableData alloc] init];
    self.globalData = [[NSMutableData alloc] init];
    self.framesArray = [[NSMutableArray alloc] init];
    
    // Reset file counters to 0
    self.pointerInt = 0;
    
    [self GIFSkipBytes:6]; // GIF89a, throw away
    [self GIFGetBytes:7]; // Logical Screen Descriptor
    
    // Deep copy
    [self.screenData setData:self.bufferData];
    
    // Copy the read bytes into a local buffer on the stack
    // For easy byte access in the following lines.
    int length = (int)[self.bufferData length];
    unsigned char aBuffer[length];
    [self.bufferData getBytes:aBuffer length:length];
    
    if (aBuffer[4] & 0x80)
    {
        self.colorFInt = 1;
    }
    else
    {
        self.colorFInt = 0;
    }
    if (aBuffer[4] & 0x08)
    {
        self.sortedInt = 1;
    }
    else
    {
        self.sortedInt = 0;
    }
    self.colorCInt = (aBuffer[4] & 0x07);
    self.colorSInt = 2 << self.colorCInt;
    
    if (self.colorFInt == 1)
    {
        [self GIFGetBytes: (3 * self.colorSInt)];
        
        // Deep copy
        [self.globalData setData:self.bufferData];
    }
    
    unsigned char bBuffer[1];
    while ([self GIFGetBytes:1] == YES)
    {
        [self.bufferData getBytes:bBuffer length:1];
        
        if (bBuffer[0] == 0x3B)
        {
            // This is the end
            break;
        }
        
        switch (bBuffer[0])
        {
            case 0x21:
            {
                // Graphic Control Extension (#n of n)
                [self GifImageReadExtensions];
            }
                break;
            case 0x2C:
            {
                // Image Descriptor (#n of n)
                [self GifImageReadDescriptor];
            }
                break;
        }
    }
    
    // clean up stuff
    self.bufferData = nil;
    self.screenData = nil;
    self.globalData = nil;
}

- (void)GifImageReadExtensions
{
    // 21! But we still could have an Application Extension,
    // so we want to check for the full signature.
    unsigned char cur[1], prev[1];
    [self GIFGetBytes:1];
    [self.bufferData getBytes:cur length:1];
    
    while (cur[0] != 0x00)
    {
        // TODO: Known bug, the sequence F9 04 could occur in the Application Extension, we
        // should check whether this combo follows directly after the 21.
        if (cur[0] == 0x04 && prev[0] == 0xF9)
        {
            [self GIFGetBytes:5];
            
            SYGifFrame *frame = [[SYGifFrame alloc] init];
            
            unsigned char buffer[5];
            [self.bufferData getBytes:buffer length:5];
            frame.disposalMethod = ((buffer[0] & 0x1c) >> 2);
            //NSLog(@"flags=%x, dm=%x", (int)(buffer[0]), frame.disposalMethod);
            
            // We save the delays for easy access.
            frame.delay = (buffer[1] | buffer[2] << 8);
            
            unsigned char board[8];
            board[0] = 0x21;
            board[1] = 0xF9;
            board[2] = 0x04;
            
            for (int i = 3, a = 0; a < 5; i++, a++)
            {
                board[i] = buffer[a];
            }
            
            frame.header = [NSData dataWithBytes:board length:8];
            
            [self.framesArray addObject:frame];

            frame = nil;
            
            break;
        }
        
        prev[0] = cur[0];
        [self GIFGetBytes:1];
        [self.bufferData getBytes:cur length:1];
    }
}

- (void)GifImageReadDescriptor
{
    [self GIFGetBytes:9];
    
    // Deep copy
    NSMutableData *GIF_screenTmp = [NSMutableData dataWithData:self.bufferData];
    
    unsigned char aBuffer[9];
    [self.bufferData getBytes:aBuffer length:9];
    
    CGRect rect;
    rect.origin.x = (((int)aBuffer[1] << 8) | aBuffer[0]);
    rect.origin.y = (((int)aBuffer[3] << 8) | aBuffer[2]);
    rect.size.width = (((int)aBuffer[5] << 8) | aBuffer[4]);
    rect.size.height = (((int)aBuffer[7] << 8) | aBuffer[6]);
    
    SYGifFrame *frame = [self.framesArray lastObject];
    frame.area = rect;
    
    if (aBuffer[8] & 0x80)
    {
        self.colorFInt = 1;
    }
    else
    {
        self.colorFInt = 0;
    }
    
    unsigned char GIF_code = self.colorCInt, GIF_sort = self.sortedInt;
    
    if (self.colorFInt == 1)
    {
        GIF_code = (aBuffer[8] & 0x07);
        
        if (aBuffer[8] & 0x20)
        {
            GIF_sort = 1;
        }
        else
        {
            GIF_sort = 0;
        }
    }
    
    int GIF_size = (2 << GIF_code);
    
    size_t blength = [self.screenData length];
    unsigned char bBuffer[blength];
    [self.screenData getBytes:bBuffer length:blength];
    
    bBuffer[4] = (bBuffer[4] & 0x70);
    bBuffer[4] = (bBuffer[4] | 0x80);
    bBuffer[4] = (bBuffer[4] | GIF_code);
    
    if (GIF_sort)
    {
        bBuffer[4] |= 0x08;
    }
    
    NSString *dataString = @"GIF89a";
    NSData *dataGif = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *GIF_string = [NSMutableData dataWithData:dataGif];
    [self.screenData setData:[NSData dataWithBytes:bBuffer length:blength]];
    [GIF_string appendData:self.screenData];
    
    if (self.colorFInt == 1)
    {
        [self GIFGetBytes:(3 * GIF_size)];
        [GIF_string appendData:self.bufferData];
    }
    else
    {
        [GIF_string appendData:self.globalData];
    }
    
    // Add Graphic Control Extension Frame (for transparancy)
    [GIF_string appendData:frame.header];
    
    char endC = 0x2c;
    [GIF_string appendBytes:&endC length:sizeof(endC)];
    
    size_t clength = [GIF_screenTmp length];
    unsigned char cBuffer[clength];
    [GIF_screenTmp getBytes:cBuffer length:clength];
    
    cBuffer[8] &= 0x40;
    
    [GIF_screenTmp setData:[NSData dataWithBytes:cBuffer length:clength]];
    
    [GIF_string appendData: GIF_screenTmp];
    [self GIFGetBytes:1];
    [GIF_string appendData:self.bufferData];
    
    while (true)
    {
        [self GIFGetBytes:1];
        [GIF_string appendData:self.bufferData];
        
        unsigned char dBuffer[1];
        [self.bufferData getBytes:dBuffer length:1];
        
        long currentByte = (long)dBuffer[0];
        
        if (currentByte != 0x00)
        {
            [self GIFGetBytes:(int)currentByte];
            [GIF_string appendData:self.bufferData];
        }
        else
        {
            break;
        }
    }
    
    endC = 0x3b;
    [GIF_string appendBytes:&endC length:sizeof(endC)];
    
    // save the frame into the array of frames
    frame.data = GIF_string;
}

- (BOOL)GIFGetBytes:(NSInteger)length
{
    if (self.bufferData != nil)
    {
        // Release old buffer
        self.bufferData = nil;
    }
    
    if ((NSInteger)[self.pointerData length] >= (self.pointerInt + length)) // Don't read across the edge of the file..
    {
        self.bufferData = (NSMutableData *)[self.pointerData subdataWithRange:NSMakeRange(self.pointerInt, length)];
        self.pointerInt += length;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)GIFSkipBytes:(NSInteger)length
{
    if ((NSInteger)[self.pointerData length] >= (self.pointerInt + length))
    {
        self.pointerInt += length;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSData *)getFrameAsDataAtIndex:(NSInteger)index
{
    if (index < (NSInteger)[self.framesArray count])
    {
        return ((SYGifFrame *)[self.framesArray objectAtIndex:index]).data;
    }
    else
    {
        return nil;
    }
}

- (UIImage *)getFrameAsImageAtIndex:(NSInteger)index
{
    NSData *frameData = [self getFrameAsDataAtIndex:index];
    UIImage *image = nil;
    
    if (frameData != nil)
    {
        image = [UIImage imageWithData:frameData];
    }
    
    return image;
}

#pragma mark - setter

- (void)setGifImageName:(NSString *)gifImageName
{
    _gifImageName = gifImageName;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_gifImageName ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if (imageData.length < 4)
    {
        return ;
    }
    
    BOOL isGifImage = [SYGifImageView isGifImage:imageData];
    if (!isGifImage)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        self.image = image;
        
        return ;
    }
    
    [self decodeGIFImageWithImageData:imageData];
    
    if (self.framesArray.count <= 0)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        self.image = image;
        return ;
    }
    
    [self loadImageData];
}

@end
