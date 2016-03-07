//
//  Covert2Picture.h
//  GLCameraRipple
//
//  Created by howell howell on 12-9-17.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Covert2Picture : NSObject

+ (UIImage *)imageWithYUVBuf:(char *)buf
                    linesize:(int)linesize
                   srcHeight:(int)sHeight
                    srcWidth:(int)sWidth
                   dstHeight:(int)dHeight
                    dstWidth:(int)dWidth;
@end
