//
//  SYGifFrame.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/12/22.
//  Copyright © 2015年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYGifFrame : NSObject

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic, assign) double delay;
@property (nonatomic, assign) int disposalMethod;
@property (nonatomic, assign) CGRect area;

@end
