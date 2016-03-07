//
//  EHCodecSourceFactory.h
//  EHMediaPlayer
//
//  Created by howell on 10/21/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHCodecSource.h"
#import "EHOVCodecSource.h"
#import "EHOVPlayBackCodecSource.h"
#import "EHOVLiveCodecSource.h"

@interface EHCodecSourceFactory : NSObject

+ (NSObject<EHCodecSource> *)codecSourceWithCodecInfo:(NSDictionary *)codecSourceInfo;
@end
