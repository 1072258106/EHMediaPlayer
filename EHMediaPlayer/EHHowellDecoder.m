//
//  EHHowellDecoder.m
//  EHMediaPlayer
//
//  Created by howell on 9/8/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHHowellDecoder.h"
#import "play_def.h"
//这个OVkey文件加进来是否耦合？
#import "EHAudioFrame.h"


@interface EHHowellDecoder () {
    
    
}
@end

@implementation EHHowellDecoder 

@synthesize delegate        = _delegate;
@synthesize dataSourceType  = _dataSourceType;
@synthesize isDecoding      = _isDecoding;
@synthesize isPause         = _isPause;
@synthesize decocdeInfo     = _decocdeInfo;
@synthesize codecSourceInfo = _codecSourceInfo;

#pragma mark - Private Methods

static bool _isDecodingStatic;
void YUVsource_callback(PLAY_HANDLE handle,
                        const unsigned char* y,
                        const unsigned char* u,
                        const unsigned char* v,
                        int y_stride,
                        int uv_stride,
                        int width,
                        int height,
                        unsigned long long time,
                        long user) {
    
    if (_isDecodingStatic) {
        // userBridgePtr 是为了配合ARC void * 到 id * 的bridge转换。
        void *userBridgePtr = (void *)user;
        //TODO：此处回报内存错误
        EHHowellDecoder *decoder = (__bridge EHHowellDecoder *)userBridgePtr ;
        if ([decoder.delegate respondsToSelector:@selector(decodedFrame:)]) {
            EHVideoFrameYUV * videoFrameYUV = [EHVideoFrameYUV frameWithYBuf:y
                                                                        UBuf:u
                                                                        VBuf:v
                                                                       width:width
                                                                      height:height];
            videoFrameYUV.timeStamp = [NSNumber numberWithLongLong:time];
            [decoder.delegate decodedFrame:videoFrameYUV];
        }
    }
    
    
    //打印帧数
    //    static long last_t;
    //    long cur_t = [[NSDate date] timeIntervalSince1970];
    //    if(last_t != cur_t)
    //    {
    //        last_t = cur_t;
    //        NSLog(@"%d ",count);
    //        count = 0;
    //    }
    //    count ++;
}


void source_callback_ex(PLAY_HANDLE handle,
                        int type,
                        const char* buf,
                        int len,
                        unsigned long timestamp,
                        long sys_tm,
                        int w,
                        int h,
                        int framerate,
                        int au_sample,
                        int au_channel,
                        int au_bits,
                        long user)
{
    // userBridgePtr 是为了配合ARC void * 到 id * 的bridge转换。
    if (_isDecodingStatic && type == 0) {
        void *userBridgePtr = (void *)user;
        EHHowellDecoder *decoder = (__bridge EHHowellDecoder *)userBridgePtr ;
        if ([decoder.delegate respondsToSelector:@selector(decodedFrame:)]) {
            EHAudioFrame * audioFrame = [EHAudioFrame frameWithByte:buf
                                                             length:len];
            [decoder.delegate decodedFrame:audioFrame];
        }
    }
}

#pragma mark - Public Methods
+ (NSObject<EHDecoder> *)decoderWithPlayInfo:(NSMutableDictionary *)playInfo {
    NSObject<EHDecoder> *decoder = [[[self class] alloc] init];
    if (decoder) {
        decoder.decocdeInfo = playInfo[kEHP_DecoderInfo];
        decoder.codecSourceInfo = playInfo[KCodecSourceInfo];
        decoder.isPause = NO;
        _isDecodingStatic = YES;
    }
    return decoder;
}

- (EHMediaError)initDecoder {
    
    if(!hwplay_init(1, -1, -1)){
        return EHMediaErrorInitDecode;
    }
    return EHMediaErrorNone;
}



- (EHMediaError)stop {
    
    self.isDecoding = NO;
    _isDecodingStatic = self.isDecoding;
    if (_playHandle != -1) {
        if (!hwplay_stop(_playHandle)) {
            return  EHMediaErrorStopDecode;
        }
        _playHandle = -1;
    }
    
    return EHMediaErrorNone;
}

- (EHMediaError)setPlayerInfo:(NSMutableDictionary *)playInfo {
    self.decocdeInfo = playInfo[kEHP_DecoderInfo];
    self.codecSourceInfo = playInfo[KCodecSourceInfo];
    return EHMediaErrorNone;
}

- (EHMediaError)decodeFrameAsync:(BOOL)isAsync frame:(EHCodecFrame *)codecFrame {
    
    while(!hwplay_input_data(_playHandle, (char*)[codecFrame.data bytes], codecFrame.length)){
        printf("HowellDecoder: hwplay input data error\n");
        usleep(1000);
        if(_playHandle == -1){
            return EHMediaErrorDecodeInputData;
        }
    }
    return EHMediaErrorNone;
}

@end
