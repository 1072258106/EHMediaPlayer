//
//  EHDecoderFacotry.m
//  EHMediaPlayer
//
//  Created by howell on 12/4/15.
//  Copyright © 2015 ender. All rights reserved.
//

#import "EHDecoderFacotry.h"

NSString * const kEHP_DecoderInfo = @"EHP_DecoderInfo";
NSString * const kEHP_DecoderName = @"EHP_DecoderName";
NSString * const kEHP_LocalFileName = @"EHP_LocalFileName";
NSString * const kEHP_LocalFilePos = @"EHP_LocalFilePos";

@implementation EHDecoderFacotry

+ (NSObject<EHDecoder> *)deocderWithPlayInfo:(NSMutableDictionary *)playInfo {
    NSObject<EHDecoder> *decoder = nil;
    NSMutableDictionary *decoderInfo = playInfo[kEHP_DecoderInfo];
    if ([decoderInfo[kEHP_DecoderName] isEqualToString:kEHP_HWLocalDecoder]) {
       decoder = [EHHowellLocalDecoder decoderWithPlayInfo:playInfo];
    } else if ([decoderInfo[kEHP_DecoderName] isEqualToString:kEHP_HWStreamDecoder]) {
        decoder = [EHHowellStreamDecoder decoderWithPlayInfo:playInfo];
    } else {
        decoder = [EHHowellLocalDecoder decoderWithPlayInfo:playInfo];
    }
    return decoder;
}
@end
