//
//  KDGLContextAndBufferConfig.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDGLContextAndBufferConfig.h"

@interface KDGLContextAndBufferConfig()
@property (nonatomic,readwrite) EAGLContext *context;
@property (nonatomic,readwrite,assign) GLuint frameBuffer;
@property (nonatomic,readwrite,assign) GLuint renderBuffer;
@end

@implementation KDGLContextAndBufferConfig
- (instancetype)initWithLayer:(CAEAGLLayer *)glLayer
{
    self = [super init];
    if (self) {
        glLayer.opaque = YES;
        glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
        
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (![EAGLContext setCurrentContext:_context]) {
            NSLog(@"set context failed");
        }
        
        
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        
        glGenRenderbuffers(1, &_renderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
        
        GLint _backingWidth;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
        GLint _backingHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    }
    return self;
}

@end
