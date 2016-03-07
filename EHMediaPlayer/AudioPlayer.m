//
//  AudioPlayer.m
//  GLCameraRipple
//
//  Created by howell howell on 12-11-21.
//  Copyright (c) 2012年 Howell Electronic. All rights reserved.
//

#import "AudioPlayer.h"
#import "Queue.h"
#import <sys/time.h>

@implementation AudioPlayer{
    int DataLength;
    NSLock * nsdataLock;
    int count;
    AudioQueueBufferRef tmpAudioBuffer;
    FILE *file;
    BOOL hasStart;
}

@synthesize remainBufferCount = _remainBufferCount;
@synthesize isPause = _isPause;

-(id)init{
    if(self = [super init]){
        
        synlock = [[NSLock alloc] init];  
        nsdataLock = [[NSLock alloc]init];

        self.remainBufferCount = 0;
        hasStart = NO;
        self.isPause = NO;
        //填一帧空数据。
        memset(aacSlience, 0, 185);
        aacSlience[0] = 0x1;
        aacSlience[1] = 0x48;
        aacSlience[2] = 0x20;
        aacSlience[3] = 0x6;
        aacSlience[4] = 0xfa;
        aacSlience[5] = 0x50;
        aacSlience[184] = 0xe;
    }
    return self;
    
}

#pragma --音频类接口
-(void)audioPlayStart{    
    NSLog(@"audio play start");
    hasStart = YES;
    self.isPause = NO;
    OSStatus err;
    self.remainBufferCount = 4;
    AudioQueueStart(audioQueue, NULL);
    //aac
    inputPKTnum = 0;
    inputByteOffset = 0;
    //第一次记时
    _lastTime = [[NSDate date] timeIntervalSince1970];
}

-(void)audioPlayStop{
    self.remainBufferCount = 0;
    NSLog(@"audio play stop");
    //一个填方播放数据的队列，和队列计数。使用AudioQueueStop(,NO)的方式不能在每次退出的时候都正常清空播放缓存，所以现在用flush的方式。
    AudioQueueStop(audioQueue, YES);
    AudioQueueFlush(audioQueue);
    hasStart = NO;
    
}

-(void)disposeAudioQueue{
    if(audioQueue){
        AudioQueueDispose(audioQueue, YES);
        audioQueue = NULL;
    }
}

-(void)initAudio{
    ///设置音频参数
    //PCM设置参数
//    audioDescription.mSampleRate = 8000;//采样率
//	audioDescription.mFormatID = kAudioFormatLinearPCM;
//	audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
//    audioDescription.mChannelsPerFrame = 1;///单声道
//    audioDescription.mFramesPerPacket = 1;//每一个packet一侦数据
//    audioDescription.mBitsPerChannel = 16;//每个采样点16bit量化,一帧数据对应每个channel数据16bit   
//    audioDescription.mBytesPerFrame = (audioDescription.mBitsPerChannel/8) * audioDescription.mChannelsPerFrame;
//    audioDescription.mBytesPerPacket = audioDescription.mBytesPerFrame *1 ;
    
    //AAC设置参数
    audioDescription.mSampleRate = 8000;//采样率
	audioDescription.mFormatID = kAudioFormatMPEG4AAC;
	audioDescription.mFormatFlags = 0;
    audioDescription.mChannelsPerFrame = 1;//单声道
    audioDescription.mFramesPerPacket = 1024; //AAC必须强制填写1024
    audioDescription.mBitsPerChannel = 0;
    audioDescription.mBytesPerFrame = 0;
    audioDescription.mBytesPerPacket = 0;
    
    ///创建一个新的从audioqueue到硬件层的通道
    //AudioQueueNewOutput(&audioDescription, AudioPlayerAQInputCallback, (__bridge void*)self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &audioQueue);///使用当前线程播
    OSStatus err = AudioQueueNewOutput(&audioDescription, AudioPlayerAQInputCallback, (__bridge void*)self, nil, nil, 0, &audioQueue);//使用player的内部线程播，第一个nil选择用怎样的事件循环，nil使用队列的内部线程。结果保存到audioQueue.
	NSLog(@"AudioQueueNewOutput res %lu",err);
    //添加buffer区
    for(int i=0;i<QUEUE_BUFFER_SIZE;i++)
    {
        int result =  AudioQueueAllocateBuffer(audioQueue, MIN_SIZE_PER_FRAME, &audioQueueBuffers[i]);
        //创建buffer区，MIN_SIZE_PER_FRAME为每一侦所需要的最小的大小，该大小应该比每次往buffer里写的最大的一次还大
//		NSLog(@"AudioQueueAllocateBuffer i = %d,result = %d",i,result);
    }

}

-(BOOL)inputPCMData:(Byte*)buf :(int)Length{
    //    NSLog(@"remain buffer %d",self.remainBufferCount);
    if(hasStart){
        //缓冲区填满，扔帧
        if (self.remainBufferCount >= QUEUE_BUFFER_SIZE) {
            return  NO;
        }
        
        tmpAudioBuffer = [self switchQueuqBuffer:tmpAudioBuffer];
        Byte * audiodata = (Byte*)tmpAudioBuffer->mAudioData;
        tmpAudioBuffer->mAudioDataByteSize = Length;
        for(int i = 0;i<Length;i++){
            if (audiodata) {
                audiodata[i] = buf[i];
            }
            
        }
        OSStatus err = AudioQueueEnqueueBuffer(audioQueue, tmpAudioBuffer, 0, NULL);
        self.remainBufferCount++;
        
        NSLog(@"remain buffer %d,len %d,err %ld",self.remainBufferCount,Length,err);
        if(self.remainBufferCount <= 10 && !self.isPause){
            NSLog(@"pause");
            AudioQueuePause(audioQueue);
            self.isPause = YES;
        }
        
        if(self.remainBufferCount > 10 && self.isPause){
            NSLog(@"Restart");
            err = AudioQueueStart(audioQueue,NULL);
            NSLog(@"audio start result %lu",err);
            self.isPause = NO;
        }
    }
    return YES;
}


-(BOOL)inputAACData:(Byte*)buf :(int)Length isOffset:(BOOL)isOffset{
    
    if(hasStart){
        //音视频同步矫正，一秒收包大于12个，刷新音频队列
        if (self.remainBufferCount >= 11) {
            [self audioPlayStop];
            [self audioPlayStart];
            NSLog(@"restart ~~~~~~");
        }
        
        if (inputPKTnum == 0) {
            tmpAudioBuffer = [self switchQueuqBuffer:tmpAudioBuffer];
        }
        memcpy(tmpAudioBuffer->mAudioData + inputByteOffset, buf, Length);
        
        packetDes[inputPKTnum].mDataByteSize = Length;
        packetDes[inputPKTnum].mStartOffset = inputByteOffset;
        packetDes[inputPKTnum].mVariableFramesInPacket = 0;
        inputByteOffset += Length;
        inputPKTnum += 1;
        
        if (inputPKTnum == MAXPACKET) {
            self.remainBufferCount++;
            tmpAudioBuffer->mAudioDataByteSize = inputByteOffset + Length;
            AudioQueueEnqueueBuffer(audioQueue, tmpAudioBuffer, MAXPACKET, packetDes);
            inputPKTnum = 0;
            inputByteOffset = 0;
        }
        
        _curTime = [[NSDate date] timeIntervalSince1970];
        if(_lastTime != _curTime)
        {
            _lastTime  = _curTime;
            //统计每秒的帧率，低于8帧pause
            if (self.remainBufferCount <= 5 && !self.isPause) {
                AudioQueuePause(audioQueue);
                self.isPause = YES;
                NSLog(@"pause ~~");
            } else if (isOffset && self.remainBufferCount < 8) {
                //回放时候视频不扔帧，所以音频要保证8帧数据每秒，不够的数据就填空数据。
                for (int i = 0 ; i < ( 8 - self.remainBufferCount); i++) {
                    NSLog(@"input one empty audio packet");
                    tmpAudioBuffer = [self switchQueuqBuffer:tmpAudioBuffer];
                    memcpy(tmpAudioBuffer->mAudioData, aacSlience, 185);
                    packetDes[0].mDataByteSize = 185;
                    packetDes[0].mStartOffset = 0;
                    packetDes[0].mVariableFramesInPacket = 0;
                    tmpAudioBuffer->mAudioDataByteSize = 185;
                    AudioQueueEnqueueBuffer(audioQueue, tmpAudioBuffer, 1, packetDes);
                }
            }
//            NSLog(@"recive buffer %d",self.remainBufferCount);
            self.remainBufferCount = 0;
        }
        
        if (self.remainBufferCount > 0 && self.isPause) {
            AudioQueueStart(audioQueue, NULL);
            self.isPause = NO;
            NSLog(@"start ~~");
        }
    }
    return YES;
}

#pragma -- 内部函数


static void AudioPlayerAQInputCallback(void *input, AudioQueueRef outQ, AudioQueueBufferRef outQB)
{
    
}

-(AudioStreamPacketDescription *)swithPacketDes:(AudioStreamPacketDescription *) qPacketDes
{
    for(int i = 0; i< (QUEUE_BUFFER_SIZE - 1); i++) {
        if (qPacketDes == &packetDes[i] ) {
            return &packetDes[i +1];
        }
    }
    return &packetDes[0];
}

-(AudioQueueBufferRef)switchQueuqBuffer:(AudioQueueBufferRef) qbuf{
    
    for(int i = 0;i<(QUEUE_BUFFER_SIZE-1);i++){
        if(qbuf == audioQueueBuffers[i]){
            return audioQueueBuffers[i+1];
        }
    }
    return audioQueueBuffers[0];
    
}
@end
