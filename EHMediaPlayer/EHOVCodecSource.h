//
//  EHOVCodecSource.h
//  EHMediaPlayer
//
//  Created by howell on 9/10/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHCodecSource.h"
#include "net_sdk.h"
#import "stream_type.h"
#import "EHCodecSourceInfoKey.h"



@interface EHOVCodecSource : NSObject <EHCodecSource> {
    
    NSMutableDictionary *_codecSourceInfo;
    USER_HANDLE         _userHandle;
    LIVE_STREAM_HANDLE  _streamHandle;
    HW_MEDIAINFO        _mediaHead;
    int                 _mediaHeadLength;
}


@end
