//
//  EHDecoder.h
//  EHMediaPlayer
//
//  Created by howell on 9/7/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#ifndef EHMediaPlayer_EHDecoder_h
#define EHMediaPlayer_EHDecoder_h

#import <Foundation/Foundation.h>
#import "EHMediaFrame.h"
#import "EHCodecFrame.h"

/**
 *  解码成功后的数据回送协议
 */
@protocol EHDecoderDelegate <NSObject>

- (void)decodedFrame:(EHMediaFrame*)frame;

@end

/**
 所有解码类都要实现这个接口
 */

@protocol EHDecoder <NSObject>

@required

+ (NSObject<EHDecoder> *)decoderWithPlayInfo:(NSDictionary *)playInfo;
- (EHMediaError)initDecoder;
- (EHMediaError)start;
- (EHMediaError)stop;
- (EHMediaError)pause;
- (EHMediaError)decodeFrameAsync:(BOOL)isAsync frame:(EHCodecFrame *)data;
- (EHMediaError)setPlayerInfo:(NSMutableDictionary *)aPlayerInfo;

@property (nonatomic)BOOL isDecoding;
@property (nonatomic)BOOL isPause;
@property (nonatomic)EHDataSourceType dataSourceType;

@optional

@property (nonatomic)NSMutableDictionary *decocdeInfo;
@property (nonatomic)NSMutableDictionary *codecSourceInfo;
@property (nonatomic,weak) id<EHDecoderDelegate> delegate;

@end
#endif
