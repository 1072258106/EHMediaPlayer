//
//  EHCodecFrame.h
//  EHMediaPlayer
//
//  Created by howell on 9/8/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#ifndef EHMediaPlayer_EHCodecFrame_h
#define EHMediaPlayer_EHCodecFrame_h

#import <Foundation/Foundation.h>

/**
 *  编码数据实体类
 */
@interface EHCodecFrame : NSObject

@property (nonatomic) NSUInteger length;
@property (nonatomic) NSData * data;

@end
#endif
