//
//  EHVideoGLView.h
//  EHMediaPlayer
//
//  Created by howell on 9/15/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHVideoFrame.h"

@interface EHVideoGLView : UIView

- (id) initWithFrame:(CGRect)frame videoFrameFormat:(EHVideoFrameFormat)videoFrameFormat;

- (void)render:(EHVideoFrame *)frame;

@end
