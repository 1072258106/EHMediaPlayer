//
//  EHAudioFrame.h
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHMediaFrame.h"

@interface EHAudioFrame : EHMediaFrame

+ (instancetype)frameWithByte:(const char*) audioBuf
                       length:(NSInteger)length;

@property (nonatomic) NSData *samples;

@end
