//
//  EHVideoFrameYUV.h
//  EHMediaPlayer
//
//  Created by howell on 9/14/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHVideoFrame.h"

@interface EHVideoFrameYUV : EHVideoFrame

@property (nonatomic) NSData *luma;
@property (nonatomic) NSData *chromaB;
@property (nonatomic) NSData *chromaR;

@end
