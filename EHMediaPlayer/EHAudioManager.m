   //
//  AudioManage.m
//  EHMediaPlayer
//
//  Created by howell on 9/16/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHAudioManager.h"
#import "EHAudioFrame.h"
#import <AVFoundation/AVFoundation.h>


#define QUEUE_BUFFER_SIZE  8 //队列缓冲个数
#define MIN_SIZE_PER_FRAME 1010 //每侦最小数据长度

@interface EHAudioManager () {
    
    AudioQueueBufferRef _audioQueueBuffers[QUEUE_BUFFER_SIZE];//音频缓存
    AudioQueueRef _audioQueueRef;
    NSLock * _lock;
}

@property (nonatomic)BOOL isPause;
@property (nonatomic)BOOL isStop;
@end

@implementation EHAudioManager

#pragma mark - Private Methods
void AudioPlayerAQInputCallback(void *userData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    
    EHAudioManager * audioManage = (__bridge EHAudioManager *) userData;
    if (audioManage.isStop || ![audioManage.audioFrames count]) {
        memset(inBuffer->mAudioData, 0, 1010);
    } else if (audioManage.isPause) {
        memset(inBuffer->mAudioData, 0, 1010);
    } else {
        if ([audioManage.audioFrames count] == 1) {
            memset(inBuffer->mAudioData, 0, 1010);
        } else {
            EHAudioFrame * audioFrame = audioManage.audioFrames[0];
            [audioManage.audioFrames removeObjectAtIndex:0];
            memcpy(inBuffer->mAudioData, [audioFrame.samples bytes], [audioFrame.samples length]);
        }
        
    }
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

#pragma mark - Public Methods
- (instancetype)initWithAudioSpec:(AudioStreamBasicDescription)streamDescription
                      audioFrames:(NSMutableArray *)aAudioFrames {

    self = [super init];
    if (self) {
        self.audioFrames = aAudioFrames;
      
        
        OSStatus status = AudioQueueNewOutput(&streamDescription,
                                              AudioPlayerAQInputCallback,
                                              (__bridge void *) self,
                                              NULL,
                                              kCFRunLoopCommonModes,
                                              0,
                                              &_audioQueueRef);
        
        if (status != noErr && !_audioQueueRef) {
            NSLog(@"AudioQueue: AudioQueueNewOutput failed (%d)\n", (int)status);
        }
        
        
        //添加buffer区
        for (NSInteger i=0; i<QUEUE_BUFFER_SIZE; i++) {
            //创建buffer区，MIN_SIZE_PER_FRAME为每一侦所需要的最小的大小，该大小应该比每次往buffer里写的最大的一次还大
            OSStatus status = AudioQueueAllocateBuffer(_audioQueueRef, MIN_SIZE_PER_FRAME, &_audioQueueBuffers[i]);
            if (status != noErr) {
                NSLog(@"AudioQueue: AudioQueueAllocateBuffer failed (%d)\n", (int)status);
            }
            //一定要在初始时指定，mAudioDataByteSize，否则不会进入回调。
            _audioQueueBuffers[i]->mAudioDataByteSize = MIN_SIZE_PER_FRAME;
            AudioQueueEnqueueBuffer(_audioQueueRef,  _audioQueueBuffers[i], 0, NULL);
        }
    }
    return self;
}


- (EHMediaError)start {
    
    @synchronized(_lock) {
        self.isPause = NO;
        self.isStop = NO;
        
        NSError *error = nil;
        if (NO == [[AVAudioSession sharedInstance] setActive:YES error:&error]) {
            NSLog(@"AudioQueue: AVAudioSession.setActive(YES) failed: %@\n", error ? [error localizedDescription] : @"nil");
        }
        
        OSStatus status = AudioQueueStart(_audioQueueRef, NULL);
        if (status != noErr) {
            NSLog(@"AudioQueue: AudioQueueStart failed (%d)\n", (int)status);
        }
    }
    return EHMediaErrorNone;
}


- (EHMediaError)pause {
    
    @synchronized(_lock) {
        self.isPause = YES;
        
        OSStatus status = AudioQueuePause(_audioQueueRef);
        if (status != noErr)
            NSLog(@"AudioQueue: AudioQueuePause failed (%d)\n", (int)status);
    }
    return EHMediaErrorNone;
}

- (EHMediaError)stop {
    NSLog(@"before stop audio manager");

    @synchronized(_lock) {
        NSLog(@"stop audio manager");
        self.isStop = YES;
        OSStatus status = AudioQueueStop(_audioQueueRef, YES);
        if (status != noErr) {
            NSLog(@"AudioQueue: AudioQueueStop failed (%d)\n", (int)status);
        }
        AudioQueueFlush(_audioQueueRef);
        AudioQueueDispose(_audioQueueRef, NO);
    }
    return EHMediaErrorNone;
}
@end
