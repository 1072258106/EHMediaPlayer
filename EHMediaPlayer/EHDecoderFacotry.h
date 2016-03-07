//
//  EHDecoderFacotry.h
//  EHMediaPlayer
//
//  Created by howell on 12/4/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHDecoderKey.h"
#import "EHHowellStreamDecoder.h"
#import "EHHowellLocalDecoder.h"

@interface EHDecoderFacotry : NSObject

+ (NSObject<EHDecoder> *)deocderWithPlayInfo:(NSMutableDictionary *)playInfo;
@end
