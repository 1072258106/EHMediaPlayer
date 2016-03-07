//
//  EHCodecSourceInfoKey.h
//  EHMediaPlayer
//
//  Created by howell on 10/21/15.
//  Copyright © 2015 ender. All rights reserved.
//

#ifndef EHCodecSourceInfoKey_h
#define EHCodecSourceInfoKey_h

#import <Foundation/Foundation.h>

//帧率
extern NSString * const KVideoFrameRate;

//codec source
extern NSString * const KCodecSourceInfo;

//codec source name
extern NSString * const KCodecSourceName;

//OV && HOWELL codec source type
extern NSString * const KEHOVPlaybackCodecSource;
extern NSString * const KEHOVLiveCodecSource;


//OV && HOWELL 协议相关
extern NSString * const KIP;
extern NSString * const KPort;
extern NSString * const KUser;
extern NSString * const KPassword;
extern NSString * const KSlot;
extern NSString * const KChannel;
extern NSString * const KIsLiveStream;
extern NSString * const KConnectMode;
extern NSString * const KMediaHead;
extern NSString * const KIsSub;
extern NSString * const KFileNo;
extern NSString * const KVODSecond;



#endif
