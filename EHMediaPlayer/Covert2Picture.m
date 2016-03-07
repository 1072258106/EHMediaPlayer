//
//  Covert2Picture.m
//  GLCameraRipple
//
//  Created by howell howell on 12-9-17.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import "Covert2Picture.h"
#import "libswscale/swscale.h"
#import "libavformat/avformat.h"

@implementation Covert2Picture

+ (UIImage *)imageWithYUVBuf:(char *)buf
                    linesize:(int)linesize
                   srcHeight:(int)sHeight
                    srcWidth:(int)sWidth
                   dstHeight:(int)dHeight
                    dstWidth:(int)dWidth

{
    AVPicture picture = [Covert2Picture AVPictureWithYUVBuf:buf
                                                   linesize:linesize
                                                  srcHeight:sHeight
                                                   srcwidth:sWidth
                                                  dstHeight:dHeight
                                                   dstWidth:dWidth];
    UIImage *image = [Covert2Picture imageWithAVPicture:picture
                                                  width:dWidth
                                                 height:dHeight];
    return image;
}



+ (AVPicture)AVPictureWithYUVBuf:(char*)buf
                     linesize:(int)linesize
                    srcHeight:(int)sHeight
                     srcwidth:(int)sWidth
                    dstHeight:(int)dHeight
                     dstWidth:(int)dWidth
{
    AVPicture picture;
    char *data[8];
    data[0] = buf;
    data[1] = buf+sHeight*sWidth;
    data[2] = buf+sHeight*sWidth*5/4;
    avpicture_alloc(&picture, PIX_FMT_RGB24, dWidth, dHeight);
    int yuvLineSize[8]={sWidth,sWidth/2,sWidth/2,0,0,0,0,0};
 
    struct SwsContext *img_convert_ctx = sws_getContext(sWidth,sHeight,PIX_FMT_YUV420P,dWidth,dHeight,PIX_FMT_RGB24,SWS_BILINEAR,NULL,NULL,NULL);
    
    if(img_convert_ctx != 0){
        sws_scale(img_convert_ctx, data, yuvLineSize, 0, sHeight, picture.data, picture.linesize);
    }
    sws_freeContext(img_convert_ctx);
    return picture;
}


+ (UIImage *)imageWithAVPicture:(AVPicture)pict
                          width:(int)width
                         height:(int)height
{
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
	CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef cgImage = CGImageCreate(width, 
									   height, 
									   8, 
									   24, 
									   pict.linesize[0], 
									   colorSpace, 
									   bitmapInfo, 
									   provider, 
									   NULL, 
									   NO, 
									   kCGRenderingIntentDefault);
	CGColorSpaceRelease(colorSpace);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	CGDataProviderRelease(provider);
	CFRelease(data);
	return image;
}


    
@end
