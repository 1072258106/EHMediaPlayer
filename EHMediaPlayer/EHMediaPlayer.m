//
//  EHMediaPlayer.m
//  EHMediaPlayer
//
//  Created by ender on 9/7/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHMediaPlayer.h"
#import "EHAudioFrame.h"
#import "EHDecoder.h"
#import "EHHowellDecoder.h"
#import "EHCodecSource.h"
#import "EHAudioManager.h"
#import "EHVideoFrame.h"
#import "EHPictureGrasp.h"
#import "EHCodecSourceFactory.h"
#import "EHDecoderFacotry.h"
#import "Covert2Picture.h"

NSString * const KVideoFrameRate = @"videoFrameRate";
NSString * const KCodecSourceInfo = @"codecSourceInfo";


@interface EHMediaPlayer ()<EHCodecSourceDelegate,EHDecoderDelegate> {
    NSTimer *_timer;
    NSMutableDictionary *_playerInfo;
    NSMutableDictionary *_codecSouceInfo;
    dispatch_queue_t _queue;
}

@property (nonatomic) NSObject<EHDecoder> *decoder;
@property (nonatomic) NSObject<EHCodecSource> *codecSource;
@property (nonatomic,strong) EHAudioManager * audioManager;
@property (nonatomic) NSMutableArray * videoFrames;
@property (nonatomic) NSMutableArray * audioFrames;
@property (nonatomic) EHVideoFrame * lastVideoFrames;

@end



@implementation EHMediaPlayer

#pragma mark - Public Methods
- (instancetype)initWithContentURL:(NSURL *)aURL {
    return [self initWithContentURL:aURL playInfo:nil];
}


- (instancetype)initWithContentURL:(NSURL *)aURL
                        playInfo:(NSMutableDictionary *)playerInfo {
    self = [super init];
    if (self) {
        _playerInfo = playerInfo;
        [self.codecSource initCodecSource];
        [self.decoder initDecoder];
        _queue = dispatch_queue_create("media_player", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)play {
    
    typeof (self) __weak weakSelf = self;
    
    
    dispatch_async(_queue, ^{
        EHMediaError error;
        
        error = [weakSelf.codecSource start];
        if (error != EHMediaErrorNone ) {
            if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayerError:)]) {
                [weakSelf.delegate mediaPlayerError:error];
            }
            return;
        }
        
        error = [weakSelf.decoder start];
        if (error != EHMediaErrorNone ) {
            if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayerError:)]) {
                [weakSelf.delegate mediaPlayerError:error];
            }
            return;
        }
        
        error = [weakSelf.audioManager start];
        if (error != EHMediaErrorNone ) {
            if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayerError:)]) {
                [weakSelf.delegate mediaPlayerError:error];
            }
            return;
        }
    });
    
    //使用NSTimer会retain self对象，导致self对象永远不会调用dealloc 来invailde Timer;
    //现在测试使用weakSelf
    int frameRate = _playerInfo[KVideoFrameRate]?[_playerInfo[KVideoFrameRate] intValue]:25;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / frameRate
                                              target:weakSelf
                                            selector:@selector(tick)
                                            userInfo:nil
                                             repeats:YES];    
}

- (void)stop {
    
    [_timer invalidate];
    typeof (self) __weak weakSelf = self;
    dispatch_async(_queue, ^{
        [weakSelf.audioManager stop];
        [weakSelf.decoder stop];
        [weakSelf.codecSource stop];
        [weakSelf.videoFrames removeAllObjects];
        [weakSelf.audioFrames removeAllObjects];
    });
}

- (void)pause {
    
    [_timer invalidate];
    typeof (self) __weak weakSelf = self;
    dispatch_async(_queue, ^{
        [weakSelf.codecSource stop];
        [weakSelf.decoder pause];
        [weakSelf.videoFrames removeAllObjects];
        [weakSelf.audioFrames removeAllObjects];
        [weakSelf.audioManager pause];
    });
}

- (void)setPlayerInfo:(NSMutableDictionary *)aPlayerInfo {
    _playerInfo = aPlayerInfo;
    [self.decoder setPlayerInfo:aPlayerInfo];
}

#pragma mark - Public Methods
- (UIImage *)imageGraspWithDstHeight:(int)height
                            dstWidth:(int)width {
    
    if (self.lastVideoFrames) {
        return [EHPictureGrasp imageWithFrame:self.lastVideoFrames
                                     dstWidth:width
                                    dstHeight:height
                                  frameFormat:EHVideoFrameFormatYUV];
    }
    return nil;
}




- (UIImage *)imageWithH264Buf:(char *)buf
                          len:(int)len
                    dstHeight:(int)dstHeight
                     dstWidth:(int)dstWidth {
    return [EHPictureGrasp imageWithH264Buf:buf
                                        len:len
                                  dstHeight:dstHeight
                                   dstWidth:dstWidth];
}


#pragma mark - Privite Methods
- (void)tick {
    if ([self.videoFrames count]) {
        //返回当前渲染帧的时间戳，用于播放回放视频时的进度条
        if ([self.delegate respondsToSelector:@selector(mediaPlayerDisplayedOneVideoFrameTimeStamp:)]) {
            NSNumber *timeStamp = [NSNumber numberWithLongLong:[((EHVideoFrame *)[self.videoFrames objectAtIndex:0]).timeStamp longLongValue]] ;
            [self.delegate mediaPlayerDisplayedOneVideoFrameTimeStamp:timeStamp];
        }
        
        [self.view render:self.videoFrames[0]];
        if (!self.lastVideoFrames) {
            self.lastVideoFrames = self.videoFrames[0]; // 保存第一帧的指针，用于截图
        }
        [self.videoFrames removeObjectAtIndex:0];
    }
}


#pragma mark - EHCodecSourceDelegate
- (void)onCodecFrame:(EHCodecFrame *)codecFrame {
    if ([self.codecFrameReciverDelegate respondsToSelector:@selector(mediaPlayerCodecSource:)]) {
        [self.codecFrameReciverDelegate mediaPlayerCodecSource:codecFrame];
    }
    [self.decoder decodeFrameAsync:YES frame:codecFrame];
}


#pragma mark - EHDecoderDelegate
- (void)decodedFrame:(EHMediaFrame*)frame {
    
    if (frame.type == EHMediaFrameTypeVideo) {
        [self.videoFrames addObject:frame];
    } else if (frame.type == EHMediaFrameTypeAudio) {
        [self.audioFrames addObject:frame];
    }
}


#pragma mark - Getter & Setter


- (NSObject *)decoder {
    
    if (!_decoder) {
        _decoder = [EHDecoderFacotry deocderWithPlayInfo:_playerInfo];
        _decoder.delegate = self;
    }
    return _decoder;
}

- (NSObject *)codecSource {
    
    if (!_codecSource) {
        _codecSource = [EHCodecSourceFactory codecSourceWithCodecInfo:_playerInfo[KCodecSourceInfo]];
        _codecSource.delegate = self;
    }
    return _codecSource;
}

- (EHAudioManager *)audioManager {
    
    if (!_audioManager) {
        AudioStreamBasicDescription audioDescription;
        audioDescription.mSampleRate = 8000;//采样率
        audioDescription.mFormatID = kAudioFormatLinearPCM;
        audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        audioDescription.mChannelsPerFrame = 1;///单声道
        audioDescription.mFramesPerPacket = 1;//每一个packet一侦数据
        audioDescription.mBitsPerChannel = 16;//每个采样点16bit量化,一帧数据对应每个channel数据16bit
        audioDescription.mBytesPerFrame = (audioDescription.mBitsPerChannel/8) * audioDescription.mChannelsPerFrame;
        audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame *1 ;
        _audioManager = [[EHAudioManager alloc] initWithAudioSpec:audioDescription
                                                      audioFrames:self.audioFrames];
    }
    return  _audioManager;
}

- (EHVideoGLView *)view {
    
    if (!_view) {
        _view = [[EHVideoGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                    videoFrameFormat:EHVideoFrameFormatYUV];
    }
    return _view;
}

- (NSMutableArray *)videoFrames {
    
    if (!_videoFrames) {
        _videoFrames = [NSMutableArray array];
    }
    return _videoFrames;
}

- (NSMutableArray *)audioFrames {
    
    if (!_audioFrames) {
        _audioFrames = [NSMutableArray array];
    }
    return _audioFrames;
}
@end
