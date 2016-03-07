//
//  EHOVPlaybackCodecSource.m
//  EHMediaPlayer
//
//  Created by howell on 10/22/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHOVPlaybackCodecSource.h"

NSString * const KEHOVPlaybackCodecSource = @"EHOVPlaybackCodecSource";
NSString * const KFileNo = @"FileNo";
NSString * const KVODSecond = @"VODSecond";
static BOOL _isPlaying;

@implementation EHOVPlaybackCodecSource

static void on_udp_file_stream_fun(UDP_FILE_STREAM_HANDLE handle,
                            const char* buf,
                            int len,
                            long userdata) {
    if (_isPlaying) {
        void *userDataBridgePtr = (void *)userdata;
        EHOVPlaybackCodecSource *codecSource = (__bridge EHOVPlaybackCodecSource *)userDataBridgePtr;
        
        if ([codecSource.delegate respondsToSelector:@selector(onCodecFrame:)]) {
            EHCodecFrame * codecFrame = [[EHCodecFrame alloc] init];
            codecFrame.length = len;
            codecFrame.data = [[NSData alloc] initWithBytes:buf length:len];
            [codecSource.delegate onCodecFrame: codecFrame];
        }
    }
    //打印编码缓存还剩余的buf；
    //     int framenu,streamnu;
    //     hwplay_get_framenum_in_buf(handle,&framenu);
    //     hwplay_get_stream_buf_remain(handle,&streamnu);
    //     NSLog(@"frame = %d , stream = %d",framenu,streamnu/1024);
}

#pragma mark - Public Methods
- (EHMediaError)start {
    
    EHMediaError mediaError = [super start];
    if (mediaError != EHMediaErrorNone) {
        return mediaError;
    }
    
    typedef struct {
        uint32_t fileno; // 文件序号/标识符,用于表示唯一的录像资源
        SYSTEMTIME created; // 录像资源创建时间
        uint32_t total_seconds; // 录像资源总时间
        uint32_t total_frames; // 录像资源总帧数
        uint32_t vod_seconds; // 点播偏移秒数
        uint32_t reserved; // 保留
        uint32_t fileno2; // 为了兼容客户端 hwnet_get_file_detail(),由于该接口没有把结构体的值全给调用者，而是调用了部分成员变量，fileno无法获取到，这里使用fileno2,借用tRecFile.type的空间传入。
    } NetRecFileItem;
    
    NetRecFileItem item;
    memset(&item,0,sizeof(item));
    item.fileno = [_codecSourceInfo[KFileNo] intValue];
    item.fileno2 = item.fileno;
    if (_codecSourceInfo[KVODSecond]) {
        item.vod_seconds = [_codecSourceInfo[KVODSecond] intValue];
    }
    
    rec_file_t *file_info = (rec_file_t *)&item;
    
    _streamHandle = hwnet_get_udp_file_stream(_userHandle,
                                              [_codecSourceInfo[KSlot] intValue],
                                              [_codecSourceInfo[KIsSub] intValue],
                                              file_info,
                                              on_udp_file_stream_fun,
                                              (int32_t)self);
    
    if (_streamHandle == -1) {
        return EHMediaErrorStartCodecSource;
    }
    
    memset(&_mediaHead, 0, sizeof(_mediaHead));
    _mediaHead.media_fourcc = HW_MEDIA_TAG;
    _mediaHead.au_channel = 1;
    _mediaHead.au_sample = 8;
    _mediaHead.au_bits = 16;
    _mediaHead.adec_code = ADEC_ADPCM_WAV;
    _mediaHead.vdec_code = VDEC_H264;
    
    [_codecSourceInfo setObject:[NSData dataWithBytes:&_mediaHead
                                               length:sizeof(_mediaHead)]
                         forKey:KMediaHead];
    
    _isPlaying = YES;
    return EHMediaErrorNone;
}

- (EHMediaError)stop {
    _isPlaying = NO;
    EHMediaError error = EHMediaErrorNone;
    if (!hwnet_close_udp_file_stream(_streamHandle)) {
        error = EHMediaErrorStopCodecSource;
    }
    
    hwnet_logout(_userHandle);
    return error;
}

@end
