//
//  EHOVLiveCodecSource.m
//  EHMediaPlayer
//
//  Created by howell on 10/22/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHOVLiveCodecSource.h"

NSString * const KEHOVLiveCodecSource = @"KEHOVLiveCodecSource";

@implementation EHOVLiveCodecSource

#pragma mark - Private Methods

void stream_fun_callback(LIVE_STREAM_HANDLE handle,
                         int stream_type,
                         const char* buf,
                         int len,
                         long userdata) {
    
    void *userDataBridgePtr = (void *)userdata;
    EHOVLiveCodecSource *codecSource = (__bridge EHOVLiveCodecSource *)userDataBridgePtr;
    
    if ([codecSource.delegate respondsToSelector:@selector(onCodecFrame:)]) {
        EHCodecFrame * codecFrame = [[EHCodecFrame alloc] init];
        codecFrame.length = len;
        codecFrame.data = [[NSData alloc] initWithBytes:buf length:len];
        [codecSource.delegate onCodecFrame: codecFrame];
    }
    
    //打印编码缓存还剩余的buf；
    //     int framenu,streamnu;
    //     hwplay_get_framenum_in_buf(handle,&framenu);
    //     hwplay_get_stream_buf_remain(handle,&streamnu);
    //     NSLog(@"frame = %d , stream = %d",framenu,streamnu/1024);
    
}

#pragma mark - Public Method
- (EHMediaError)start {
    EHMediaError mediaError = [super start];
    if (mediaError != EHMediaErrorNone) {
        return mediaError;
    }
    
    if ([_codecSourceInfo[KIsLiveStream] boolValue]) {
        // 连接实时流
        
        _streamHandle = hwnet_get_live_stream(_userHandle,
                                              [_codecSourceInfo[KSlot] intValue],
                                              [_codecSourceInfo[KIsSub] intValue],
                                              [_codecSourceInfo[KConnectMode] intValue],
                                              stream_fun_callback,
                                              (long)self);
        if (_streamHandle == -1) {
            return EHMediaErrorStartCodecSource;
        }
        
        
        memset(&_mediaHead, 0, sizeof(_mediaHead));
        if (!hwnet_get_live_stream_head(_streamHandle,
                                        (char *)&_mediaHead,
                                        1024,
                                        &_mediaHeadLength)) {
            return EHMediaErrorStartCodecSource;
        }
        
        
        [_codecSourceInfo setObject:[NSData dataWithBytes:&_mediaHead
                                                   length:sizeof(_mediaHead)]
                             forKey:KMediaHead];
    }
    
    return EHMediaErrorNone;
}

- (EHMediaError)stop {
    hwnet_close_live_stream(_streamHandle);
    hwnet_logout(_userHandle);
    hwnet_release();
    return EHMediaErrorNone;
}
@end
