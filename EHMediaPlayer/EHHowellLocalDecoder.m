//
//  EHHowellLocalDecoder.m
//  EHMediaPlayer
//
//  Created by howell on 12/4/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHHowellLocalDecoder.h"


NSString *const kEHP_HWLocalDecoder = @"EHP_HWLocalDecoder";
NSString *const kEHP_HWLocalDecoder_File_Pos = @"EHP_HWLocalDecoder_File_Pos";



@implementation EHHowellLocalDecoder

#pragma mark - Public Methods

- (EHMediaError)start {
    
    if (!self.isPause) {
        //重新打开
        _playHandle = hwplay_open_local_file([self.decocdeInfo[kEHP_LocalFileName] UTF8String]);
        if (_playHandle == -1) {
            return EHMediaErrorStartDecode;
        }
        
        if(!hwplay_register_yuv_callback_ex(_playHandle, YUVsource_callback, (long)self)){
            return EHMediaErrorStartDecode;
        }
        
        if(!hwplay_register_source_data_callback(_playHandle, source_callback_ex, (long)self)){
            return EHMediaErrorStartDecode;
        }
        
        if (!hwplay_play(_playHandle)){
            return EHMediaErrorStartDecode;
        }
    } else {
        //从暂停再播放。
        if (self.decocdeInfo[kEHP_LocalFilePos]) {
            int ret = hwplay_set_pos(_playHandle, [self.decocdeInfo[kEHP_LocalFilePos] intValue]);
            NSLog(@"ret %d",ret);
        }
        self.isPause = NO;
        hwplay_pause(_playHandle, self.isPause);
    }
    
    self.isDecoding = YES;
    
    return EHMediaErrorNone;
}

- (EHMediaError)pause {
    self.isDecoding = NO;
    self.isPause = YES;
    hwplay_pause(_playHandle, self.isPause);
    
    return EHMediaErrorNone;
}

@end
