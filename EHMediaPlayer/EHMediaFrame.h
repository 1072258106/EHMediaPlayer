//
//  EHVideoFrame.h
//  EHMediaPlayer
//
//  Created by howell on 9/8/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef NS_ENUM(NSInteger, EHMediaError) {
    EHMediaErrorNone = 0,
    EHMediaErrorOpenFile,
    EHMediaErrorStreamInfoNotFound,
    EHMediaErrorStreamNotFound,
    EHMediaErrorCodecNotFound,
    EHMediaErrorOpenCodec,
    EHMediaErrorAllocateFrame,
    EHMediaErrorSetupScaler,
    EHMediaErrorReSampler,
    EHMediaErrorUnsupported,
    EHMediaErrorInitDecode,
    EHMediaErrorStartDecode,
    EHMediaErrorStopDecode,
    EHMediaErrorDecodeInputData,
    EHMediaErrorInitCodecSource,
    EHMediaErrorStartCodecSource,
    EHMediaErrorStopCodecSource
};

typedef NS_ENUM(NSInteger, EHMediaFrameType) {
    EHMediaFrameTypeAudio,
    EHMediaFrameTypeVideo,
    EHMediaFrameTypeArtwork,
    EHMediaFrameTypeSubtitle,
};

typedef NS_ENUM(NSInteger, EHVideoFrameFormat) {
    EHVideoFrameFormatRGB,
    EHVideoFrameFormatYUV,
};

typedef NS_ENUM(NSInteger, EHDataSourceType) {
    EHDataSourceFile = 0,
    EHDataSourceStream,
};


/**
 *  解码数据实体类
 */
@interface EHMediaFrame : NSObject
@property (nonatomic) EHMediaFrameType type;
@property (readonly, nonatomic) CGFloat position;
@property (readonly, nonatomic) CGFloat duration;
@end




@interface EHArtworkFrame : EHMediaFrame
@property (readonly, nonatomic, strong) NSData *picture;
//- (UIImage *) asImage;
@end

@interface EHSubtitleFrame : EHMediaFrame
@property (readonly, nonatomic) NSString *text;
@end
