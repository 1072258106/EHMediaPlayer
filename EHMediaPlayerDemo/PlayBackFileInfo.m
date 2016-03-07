//
//  PlayBackFileInfo.m
//  EHMediaPlayer
//
//  Created by howell on 9/29/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "PlayBackFileInfo.h"
#import "PlayBackFileCache+OV.h"

@interface PlayBackFileInfo ()

typedef struct {
    int slot;
    SYSTEMTIME beg;
    SYSTEMTIME end;
    int type;/*0-normal 1-normal file 2-mot file*/
} tRecFile;

typedef struct {
    uint32_t fileno; // 文件序号/标识符,用于表示唯一的录像资源
    SYSTEMTIME created; // 录像资源创建时间
    uint32_t total_seconds; // 录像资源总时间
    uint32_t total_frames; // 录像资源总帧数
    uint32_t vod_seconds; // 点播偏移秒数
    uint32_t reserved[1]; // 保留
    uint32_t fileno2;
} NetRecFileItem;

@end

@implementation PlayBackFileInfo

+ (instancetype)playbackplaybackInfoWithBiginTime:(SYSTEMTIME)aBeginTime
                                  endTime:(SYSTEMTIME)aEndTime
                                     type:(int)aType {
    PlayBackFileInfo * playBackFileInfo = [[[self class] alloc] init];
    if (playBackFileInfo) {
        tRecFile recFile = {
            .slot = 1,
            .beg = aBeginTime,
            .end = aEndTime,
            .type = aType
        };
        NetRecFileItem netRecFileItem;
        memcpy(&netRecFileItem, &recFile, sizeof(tRecFile));
        
        playBackFileInfo.fileNO = netRecFileItem.fileno2;
        playBackFileInfo.createTime = netRecFileItem.created;
        playBackFileInfo.totalFrames = netRecFileItem.total_frames;
        playBackFileInfo.totalSeconds = netRecFileItem.total_seconds;
        playBackFileInfo.vodSeconds = netRecFileItem.vod_seconds;
    }
    return playBackFileInfo;
}


+ (instancetype)playbackplaybackInfoWithBiginTime:(PlayBackFileCache *)playbackFileCache {
    PlayBackFileInfo * playBackFileInfo = [[[self class] alloc] init];
    if (playBackFileInfo) {
        playBackFileInfo.fileNO = playbackFileCache.i
        playBackFileInfo.createTime = netRecFileItem.created;
        playBackFileInfo.totalFrames = netRecFileItem.total_frames;
        playBackFileInfo.totalSeconds = netRecFileItem.total_seconds;
        playBackFileInfo.vodSeconds = netRecFileItem.vod_seconds;
    }
    return playBackFileInfo;
}
@end
