//
//  PlayBackFileInfo.h
//  EHMediaPlayer
//
//  Created by howell on 9/29/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "net_sdk.h"

@interface PlayBackFileInfo : NSObject

+ (instancetype)playbackInfoWithBiginTime:(SYSTEMTIME)beginTime
                          endTime:(SYSTEMTIME)endTime
                             type:(int)type;

@property (nonatomic) uint32_t fileNO;       // 文件序号/标识符,用于表示唯一的录像资源
@property (nonatomic) SYSTEMTIME createTime; // 录像资源创建时间
@property (nonatomic) uint32_t totalSeconds; // 录像资源总时间
@property (nonatomic) uint32_t totalFrames;  // 录像资源总帧数
@property (nonatomic) uint32_t vodSeconds;   // 点播偏移秒数

@end
