//
//  AudioManager.h
//  EHMediaPlayer
//
//  Created by howell on 9/16/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "EHMediaFrame.h"

@interface EHAudioManager : NSObject

- (instancetype)initWithAudioSpec:(AudioStreamBasicDescription)streamDescription
                      audioFrames:(NSMutableArray *)aAudioFrames;

- (EHMediaError)start;
- (EHMediaError)pause;
- (EHMediaError)flush;
- (EHMediaError)stop;
- (EHMediaError)close;

@property (atomic)NSMutableArray * audioFrames;


@end
