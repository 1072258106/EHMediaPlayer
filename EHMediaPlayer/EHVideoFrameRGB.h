//
//  EHVideoFrameRGB.h
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHVideoFrame.h"

@interface EHVideoFrameRGB : EHVideoFrame

@property (nonatomic) NSUInteger linesize;
@property (nonatomic) NSData *rgb;
//- (UIImage *) asImage;
@end
