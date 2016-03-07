//
//  EHCodecSourceFactory.m
//  EHMediaPlayer
//
//  Created by howell on 10/21/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHCodecSourceFactory.h"
#import "EHCodecSourceInfoKey.h"
#import "EHCodecSourceFactory.h"

NSString * const KCodecSourceName = @"KCodecSourceName";
@implementation EHCodecSourceFactory

+ (NSObject<EHCodecSource> *)codecSourceWithCodecInfo:(NSMutableDictionary *)codecSourceInfo {
    if ([codecSourceInfo[KCodecSourceName] isEqualToString:KEHOVLiveCodecSource]) {
        return  [EHOVLiveCodecSource codecSourceWithCodecSourceInfo:codecSourceInfo];
    } else if ([codecSourceInfo[KCodecSourceName] isEqualToString:KEHOVPlaybackCodecSource]) {
        return [EHOVPlaybackCodecSource codecSourceWithCodecSourceInfo:codecSourceInfo];
    } else {
        return nil;
    }
}
@end
