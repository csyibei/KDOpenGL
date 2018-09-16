//
//  KDGLContextAndBufferConfig.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDGLContextAndBufferConfig.h"

@interface KDGLContextAndBufferConfig()
@property (nonatomic,readwrite,assign) GLuint frameBuffer;
@property (nonatomic,readwrite,assign) GLuint renderBuffer;
@end

@implementation KDGLContextAndBufferConfig
- (instancetype)initWithLayer:(CAEAGLLayer *)glLayer andContext:(EAGLContext *)context
{
    self = [super init];
    if (self) {
        glLayer.opaque = YES;
        glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithBool:YES],
                                       kEAGLDrawablePropertyRetainedBacking,
                                       kEAGLColorFormatRGBA8,
                                       kEAGLDrawablePropertyColorFormat,nil];
        
        GLuint frameBuffer;
        glGenFramebuffers(1, &frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
        
        GLuint renderBuffer;
        glGenRenderbuffers(1, &renderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    }
    return self;
}

@end
