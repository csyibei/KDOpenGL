//
//  KDAnimationGLView.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/14.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDAnimationGLView.h"
#import "KDTextureHandle.h"
#import "KDGLContextAndBufferConfig.h"
#import "KDProgramLink.h"
#import "KDShaderLoad.h"
#import <GLKit/GLKit.h>

@implementation KDAnimationGLView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (![EAGLContext setCurrentContext:context]) {
            NSLog(@"context set failed");
        }
        
//        GLKMatrix4Translate(<#GLKMatrix4 matrix#>, <#float tx#>, <#float ty#>, <#float tz#>);
//        GLKMatrix4Scale(<#GLKMatrix4 matrix#>, <#float sx#>, <#float sy#>, <#float sz#>);
//        GLKMatrix4Rotate(<#GLKMatrix4 matrix#>, <#float radians#>, <#float x#>, <#float y#>, <#float z#>)
        
//        GLKMatrix4MakeTranslation(<#float tx#>, <#float ty#>, <#float tz#>)
//        GLKMatrix4MakeRotation(<#float radians#>, <#float x#>, <#float y#>, <#float z#>)
//        GLKMatrix4MakeScale(<#float sx#>, <#float sy#>, <#float sz#>)
        
//        GLKMatrix4MakeLookAt(<#float eyeX#>, <#float eyeY#>, <#float eyeZ#>, <#float centerX#>, <#float centerY#>, <#float centerZ#>, <#float upX#>, <#float upY#>, <#float upZ#>)
        
        KDGLContextAndBufferConfig *config = [[KDGLContextAndBufferConfig alloc] initWithLayer:(CAEAGLLayer *)self.layer andContext:context];
        
        KDProgramLink *link = [[KDProgramLink alloc] init];
        NSDictionary *shaderInfo = @{
                                     @"KDTextureVertex":@"GL_VERTEX_SHADER",
                                     @"KDTextureFragment":@"GL_FRAGMENT_SHADER"
                                     };
        [link kd_programLinkWithShaderDic:shaderInfo];
        
        KDTextureHandle *textureHandle = [[KDTextureHandle alloc] init];
        GLuint texture1 = [textureHandle kd_creatContextWithImageName:@"KDPicture1"];
        
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        glViewport([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        GLfloat attrArr[] =
        {
            0.5f, -0.5f, 0.0f,1.0f, 0.0f,
            -0.5f, 0.5f, 0.0f,0.0f, 1.0f,
            -0.5f, -0.5f, 0.0f,0.0f, 0.0f,
            0.5f, 0.5f, 0.0f,1.0f, 1.0f,
            -0.5f, 0.5f, 0.0f,0.0f, 1.0f,
            0.5f, -0.5f, 0.0f,1.0f, 0.0f,
        };
        
        GLuint VAO;
        glGenVertexArrays(1, &VAO);
        glBindVertexArray(VAO);
        
        GLuint VBO;
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
        
        // 位置属性
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        
        //Texture位置
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture1);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);
        [context presentRenderbuffer:GL_RENDERBUFFER];
        
    }
    return self;
}

@end
