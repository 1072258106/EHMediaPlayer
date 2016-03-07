//
//  EHCodecSource.h
//  EHMediaPlayer
//
//  Created by howell on 9/9/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#ifndef EHMediaPlayer_EHCodecSource_h
#define EHMediaPlayer_EHCodecSource_h

#import <Foundation/Foundation.h>
#import "EHMediaFrame.h"
#import "EHCodecFrame.h"
#import "EHCodecSourceInfoKey.h"


/**
 编码数据回调Delegate
 */
@protocol EHCodecSourceDelegate <NSObject>

- (void)onCodecFrame:(EHCodecFrame *)codecFrame;
@end

/**
 编码数据源接口定义。
 */
@protocol EHCodecSource <NSObject>

@required
+ (NSObject<EHCodecSource> *)codecSourceWithCodecSourceInfo:(NSMutableDictionary *)aCodecSourceInfo;
- (EHMediaError)initCodecSource;
- (EHMediaError)start;
- (EHMediaError)stop;

@optional
- (EHMediaError)pause;
- (EHMediaError)resume;
- (void)setParam:(NSDictionary *)param;

@property (nonatomic,weak) id<EHCodecSourceDelegate> delegate;
@property (nonatomic) NSMutableDictionary *codecSourceInfo;
@end

#endif
