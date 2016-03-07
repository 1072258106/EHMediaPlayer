//
//  EHVideoFrameYUV+HowellDecoder.m
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHVideoFrameYUV+HowellDecoder.h"

@implementation EHVideoFrameYUV (HowellDecoder)

+ (instancetype)frameWithYBuf:(const unsigned char*) yBuf
                         UBuf:(const unsigned char*) uBuf
                         VBuf:(const unsigned char*) vBuf
                        width:(int) width
                       height:(int) height {
    
    EHVideoFrameYUV * videoFrameYUV = [[EHVideoFrameYUV alloc] init];
    if (videoFrameYUV) {
        videoFrameYUV.luma = [NSData dataWithBytes:yBuf length:width * height];
        videoFrameYUV.chromaB = [NSData dataWithBytes:uBuf length:width * height / 4];
        videoFrameYUV.chromaR = [NSData dataWithBytes:vBuf length:width * height / 4];
        videoFrameYUV.width = width;
        videoFrameYUV.height = height;
        videoFrameYUV.type = EHMediaFrameTypeVideo;
    }
    
    return videoFrameYUV;
}


@end
