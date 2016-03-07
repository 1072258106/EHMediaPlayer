//
//  EHVideoFrameYUV+HowellDecoder.h
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHVideoFrameYUV.h"

@interface EHVideoFrameYUV (HowellDecoder)

+ (instancetype)frameWithYBuf:(const unsigned char*) yBuf
                         UBuf:(const unsigned char*) uBuf
                         VBuf:(const unsigned char*) vBuf
                        width:(int) width
                       height:(int) height;
@end
