//
//  EHMediaPlayer.h
//  EHMediaPlayer
//
//  Created by ender on 9/7/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EHMediaFrame.h"
#import "EHVideoGLView.h"
#import "EHCodecSourceInfoKey.h"
#import "EHDecoderKey.h"
#import "EHCodecFrame.h"

/**
 *  用于告知使用者，显示了一帧视频数据。
 */
@protocol EHMediaPlayerDelegate <NSObject>
@optional
- (void)mediaPlayerDisplayedOneVideoFrameTimeStamp:(NSNumber *)timeStamp;
- (void)mediaPlayerError:(EHMediaError)error;
@end

@protocol EHMediaPlayerCodecFrameReceiverDelegate <NSObject>

- (void)mediaPlayerCodecSource:(EHCodecFrame *)codecFrame;
@end

@interface EHMediaPlayer : NSObject
- (instancetype)initWithContentURL:(NSURL *)aURL;
- (instancetype)initWithContentURL:(NSURL *)aURL
                        playInfo:(NSMutableDictionary *)playerInfo;


- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPlayerInfo:(NSMutableDictionary *)aPlayerInfo;

/**
 *  附加功能
 */

/**
 *  抓取当前显示的画面
 *
 *  @param height 抓图高度
 *  @param width  抓图宽度
 *
 *  @return UIImage
 */
- (UIImage *)imageGraspWithDstHeight:(int)height
                            dstWidth:(int)width;

/**
 *  从外部传入的一帧YUV数据生成UIImage
 *
 *  @param buf       h264数据
 *  @param len       h264数据长度
 *  @param dstHeight 目标高度
 *  @param dstWidth  目标宽度
 *
 *  @return UIImage
 */
- (UIImage *)imageWithH264Buf:(char *)buf
                          len:(int)len
                    dstHeight:(int)dstHeight
                     dstWidth:(int)dstWidth;

@property (nonatomic)EHVideoGLView *view;
@property (nonatomic, weak)id<EHMediaPlayerDelegate> delegate;
@property (nonatomic, weak)id<EHMediaPlayerCodecFrameReceiverDelegate> codecFrameReciverDelegate;
@end
