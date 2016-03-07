//
//  EHPictureGrasp.h
//  EHMediaPlayer
//
//  Created by howell on 11/23/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EHVideoFrameYUV.h"

@interface EHPictureGrasp : NSObject
+ (UIImage *)imageWithFrame:(EHVideoFrame *)videoFrame
                   dstWidth:(int)width
                  dstHeight:(int)height
                frameFormat:(EHVideoFrameFormat)frameFromat;


/**
 *  将h264数据解码，返回UIImage
 *
 *  @param buf          一帧i帧h.264数据
 *  @param len          i帧h.264数据长度
 *  @param dstHeight    目标图片的高度
 *  @param dstWidth     目标图片的宽度
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithH264Buf:(char *)buf
                          len:(int)len
                    dstHeight:(int)dstHeight
                     dstWidth:(int)dstWidth;


+ (UIImage *)imageWithYUVBuf:(char* )buf
                    dstWidth:(int)width
                   dstHeight:(int)height;
@end
