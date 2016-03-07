//
//  EHHowellStreamDecoder.m
//  EHMediaPlayer
//
//  Created by howell on 12/4/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHHowellStreamDecoder.h"
#import "EHCodecSourceInfoKey.h"
#import "stream_type.h"

NSString *const kEHP_HWStreamDecoder = @"HWStreamDecoder";
@implementation EHHowellStreamDecoder

- (EHMediaError)start {
    
    //open stream
    //初始化流头
    HW_MEDIAINFO media_head;
    NSData * meidaHeadData = (NSData *)self.codecSourceInfo[KMediaHead];
    //TODO:
    [meidaHeadData getBytes:&media_head length:sizeof(HW_MEDIAINFO)];
    //初始化分配流空间的参数
    RECT area;
    int bufLength = self.dataSourceType == EHDataSourceStream? 1024*1024:2*1024*1024;
    int openMode = self.dataSourceType == EHDataSourceStream? PLAY_LIVE:PLAY_FILE;
    openMode = PLAY_LIVE;
    
    _playHandle = hwplay_open_stream((char*)&media_head, sizeof(media_head), bufLength, openMode, area);
    if (_playHandle == -1) {
        return EHMediaErrorStartDecode;
    }
    
    if(!hwplay_register_yuv_callback_ex(_playHandle, YUVsource_callback, (long)self)){
        return EHMediaErrorStartDecode;
    }
    
    if(!hwplay_register_source_data_callback(_playHandle, source_callback_ex, (long)self)){
        return EHMediaErrorStartDecode;
    }
    
    if (!hwplay_play(_playHandle)){
        return EHMediaErrorStartDecode;
    }
    
    self.isDecoding = YES;
    
    return EHMediaErrorNone;
}

- (EHMediaError)pause {
    //流解码器pause 与 stop 逻辑相同
    self.isDecoding = NO;
    
    if (_playHandle != -1) {
        if (!hwplay_stop(_playHandle)) {
            return  EHMediaErrorStopDecode;
        }
        _playHandle = -1;
    }
    
    return EHMediaErrorNone;
}
@end
