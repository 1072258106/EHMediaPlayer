//
//  EHVideoGLRenderer.h
//  EHMediaPlayer
//
//  Created by howell on 9/15/15.
//  Copyright (c) 2015 ender. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHVideoFrame.h"
#import <OpenGLES/ES2/gl.h>


/**
 *  序列化着色代码为NSString字符串
 */

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)



/**
 *  EHVideoGLRenderer 协议
 */
@protocol EHVideoGLRenderer <NSObject>

- (BOOL)isValid;
- (NSString *)fragmentShader;
- (NSString *)vertexShader;
- (void)resolveUniforms: (GLuint) program;
- (void)setFrame: (EHVideoFrame *) frame;
- (BOOL)prepareRender;
@end
