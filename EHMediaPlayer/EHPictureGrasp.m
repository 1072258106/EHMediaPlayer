//
//  EHPictureGrasp.m
//  EHMediaPlayer
//
//  Created by howell on 11/23/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHPictureGrasp.h"
#import "Covert2Picture.h"

@implementation EHPictureGrasp
+ (UIImage *)imageWithFrame:(EHVideoFrame *)videoFrame
                   dstWidth:(int)width
                  dstHeight:(int)height
                frameFormat:(EHVideoFrameFormat)frameFromat {
    
    if (videoFrame) {
        if (frameFromat == EHVideoFrameFormatYUV) {
            EHVideoFrameYUV *videoFrameYUV = (EHVideoFrameYUV *)videoFrame;
            NSMutableData * yuvData = [NSMutableData dataWithData:videoFrameYUV.luma];
            [yuvData appendData:videoFrameYUV.chromaB];
            [yuvData appendData:videoFrameYUV.chromaR];
            char * yuvBuf = (char *)[yuvData bytes];
            
            
           
            
            return [Covert2Picture imageWithYUVBuf:yuvBuf
                                          linesize:videoFrameYUV.width
                                         srcHeight:videoFrameYUV.height
                                          srcWidth:videoFrameYUV.width
                                         dstHeight:height
                                          dstWidth:width];
        }
    }
    return nil;
}



#import "play_def.h"
// 解码一帧的算法是基于ffmpeg，利用hwplay库实现
+ (UIImage *)imageWithH264Buf:(char *)buf
                          len:(int)len
                    dstHeight:(int)dstHeight
                     dstWidth:(int)dstWidth {
    
    unsigned char *YUVBuf = malloc(1280 * 720 * 3/2); //开辟1080P大小的buf
    memset(YUVBuf, 0, 1280 * 720 * 3/2);
    int srcLineSize,srcWidth,srcHeight;
    hwplay_get_YUV_Buf_with_ESStream(buf, &YUVBuf, len, &srcLineSize, &srcWidth, &srcHeight);
    UIImage * image = [Covert2Picture imageWithYUVBuf:(char *)YUVBuf
                                   linesize:srcWidth
                                  srcHeight:srcHeight
                                   srcWidth:srcWidth
                                  dstHeight:dstHeight
                                   dstWidth:dstWidth];
    free(YUVBuf);
    return image;
}

@end
