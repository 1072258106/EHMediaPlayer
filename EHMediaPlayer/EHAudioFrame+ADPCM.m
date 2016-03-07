//
//  EHAudioFrame+ADPCM.m
//  EHMediaPlayer
//
//  Created by howell on 9/17/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHAudioFrame+ADPCM.h"
#import "adpcm.h"

@implementation EHAudioFrame (ADPCM)

static Adpcm_State adpmcState;
+ (instancetype)frameWithByte:(const char*) audioBuf
                       length:(NSInteger)length {
    
    EHAudioFrame * audioFrame = [[self class] frameWithByte:audioBuf length:length];
    NSData * pcmData = [NSData data];
    adpcm_decoder((char *)[audioFrame.samples bytes],
                  (short *)[pcmData bytes],
                  [audioFrame.samples length],
                  &adpmcState);
    return audioFrame;
}


@end
