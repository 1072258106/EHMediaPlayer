//
//  EHAudioFrame.m
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHAudioFrame.h"

@implementation EHAudioFrame

+ (instancetype)frameWithByte:(const char*) audioBuf
                       length:(NSInteger)length {
    
    EHAudioFrame * audioFrame = [[[self class] alloc] init];
    if (audioFrame) {
        audioFrame.type = EHMediaFrameTypeAudio;
        audioFrame.samples = [NSData dataWithBytes:audioBuf length:length];
    }
    return audioFrame;
}

@end
