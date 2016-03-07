//
//  EHHowellDecoder.h
//  EHMediaPlayer
//
//  Created by howell on 9/8/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHDecoder.h"
#import "EHDecoderKey.h"
#import "EHHowellDecoderKey.h"
#import "EHCodecSourceInfoKey.h"
#import "EHVideoFrameYUV+HowellDecoder.h"
#import "play_def.h"


@interface EHHowellDecoder : NSObject <EHDecoder> {
    int _playHandle;
}

void YUVsource_callback(PLAY_HANDLE handle,
                        const unsigned char* y,
                        const unsigned char* u,
                        const unsigned char* v,
                        int y_stride,
                        int uv_stride,
                        int width,
                        int height,
                        unsigned long long time,
                        long user);

void source_callback_ex(PLAY_HANDLE handle,int type,const char* buf,int len,unsigned long timestamp,long sys_tm,int w,int h,int framerate,int au_sample,int au_channel,int au_bits,long user);
@end
