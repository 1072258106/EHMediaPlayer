//
//  AudioPlayer.h
//  GLCameraRipple
//
//  Created by howell howell on 12-11-21.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 48 //队列缓冲个数
#define EVERY_READ_LENGTH 1000 //每次从文件读取的长度
#define MIN_SIZE_PER_FRAME 256 //每侦最小数据长度
#define MAXPACKET 1 //网络数据收多少个包，作为一个音频包填入队列。
#define AACSPEED 6 //aac每秒消耗8 个 185byte 数据包

@interface AudioPlayer : NSObject{
    AudioStreamBasicDescription audioDescription;///音频参数
    AudioQueueRef audioQueue;//音频播放队列
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE];//音频缓存
    AudioStreamPacketDescription packetDes[MAXPACKET]; //用于编码率的音频队列描述
    NSLock *synlock;//同步audio
    Byte pcmDataBuffer[400];//pcm的读文件数据区
    int inputPKTnum;
    int inputByteOffset;
    Byte aacSlience[185];
    long _curTime;
    long _lastTime;
}
-(void)initAudio;
-(void)audioPlayStart;
-(void)audioPlayStop;
-(void)disposeAudioQueue;
-(BOOL)inputPCMData:(char*)buf :(int)Length;
-(BOOL)inputAACData:(Byte*)buf :(int)Length isOffset:(BOOL)isOffset;
@property (atomic)int remainBufferCount;
@property (atomic)BOOL isPause;
@end
