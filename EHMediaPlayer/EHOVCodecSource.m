//
//  EHOVCodecSource.m
//  EHMediaPlayer
//
//  Created by howell on 9/10/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import "EHOVCodecSource.h"



NSString * const KEHOVCodecSource = @"KEHOVCodecSource";


NSString * const KIP = @"IP";
NSString * const KPort = @"Port";
NSString * const KUser = @"User";
NSString * const KPassword = @"Password";
NSString * const KSlot = @"Slot";
NSString * const KIsSub = @"IsSub";
NSString * const KIsLiveStream = @"IsLiveStream";
NSString * const KConnectMode = @"ConnectMode";
NSString * const KMediaHead = @"MdieaHead";

@interface EHOVCodecSource () 


@end

@implementation EHOVCodecSource

//对于protocol中声明的property，default synthesis是不会作用的。所以，所有实现了这个protocol的类都需要自定义或者用@synthesize语句合成accessor方法和实例变量。
@synthesize delegate = _delegate;
@synthesize codecSourceInfo = _codecSourceInfo;



#pragma mark - Public Methods

+ (NSObject<EHCodecSource> *)codecSourceWithCodecSourceInfo:(NSMutableDictionary *)aCodecSourceInfo{
    NSObject<EHCodecSource> * codecSource = [[[self class] alloc] init];
    if (codecSource) {
        codecSource.codecSourceInfo = aCodecSourceInfo;
    }
    return codecSource;
}

- (EHMediaError)initCodecSource {
    hwnet_init(5888);
    return EHMediaErrorNone;
}

- (EHMediaError)start {
    _userHandle = -1;
    _streamHandle = -1;
    
    _userHandle = hwnet_login([_codecSourceInfo[KIP] UTF8String],
                              [_codecSourceInfo[KPort] intValue],
                              [_codecSourceInfo[KUser] UTF8String],
                              [_codecSourceInfo[KPassword] UTF8String]);
    if (_userHandle == -1) {
        NSLog(@"hwnet_login error");
        return EHMediaErrorInitCodecSource;
    }

    return EHMediaErrorNone;
}

- (EHMediaError)stop {
   return EHMediaErrorNone;
}

@end
