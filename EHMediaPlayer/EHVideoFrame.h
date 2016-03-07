//
//  EHVideoFrame.h
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHMediaFrame.h"

@interface EHVideoFrame : EHMediaFrame

@property (nonatomic) EHVideoFrameFormat format;
@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger height;
@property (nonatomic) NSNumber *timeStamp;

@end
