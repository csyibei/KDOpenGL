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
{
    GLuint _linkProgram;
    EAGLContext *_context;
    GLuint _VAO;
}

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
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (![EAGLContext setCurrentContext:_context]) {
            NSLog(@"context set failed");
        }
        
//        GLKMatrix4MakeLookAt(<#float eyeX#>, <#float eyeY#>, <#float eyeZ#>, <#float centerX#>, <#float centerY#>, <#float centerZ#>, <#float upX#>, <#float upY#>, <#float upZ#>)
        
        KDGLContextAndBufferConfig *config = [[KDGLContextAndBufferConfig alloc] initWithLayer:(CAEAGLLayer *)self.layer andContext:_context];
        
        KDProgramLink *link = [[KDProgramLink alloc] init];
        NSDictionary *shaderInfo = @{
                                     @"KDTextureVertex":@"GL_VERTEX_SHADER",
                                     @"KDTextureFragment":@"GL_FRAGMENT_SHADER"
                                     };
        _linkProgram = [link kd_programLinkWithShaderDic:shaderInfo];
        
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
        

        glGenVertexArrays(1, &_VAO);
        glBindVertexArray(_VAO);
        
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
        
        GLKMatrix4 translationMatrix = GLKMatrix4Identity;
        GLfloat *m = translationMatrix.m;
        int matrix = glGetUniformLocation(_linkProgram, "matrix");
        glUniformMatrix4fv(matrix, 1, GL_FALSE, m);
        
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    }
    return self;
}

- (void)kd_changeWithChangeType:(KDGLChangeType)changeType changeValue:(CGFloat)changeValue
{
    glBindVertexArray(_VAO);
    glClear(GL_COLOR_BUFFER_BIT);
    GLKMatrix4 translationMatrix;
    switch (changeType) {
        case KDGLChangeTypeTranslation:
            translationMatrix = GLKMatrix4MakeTranslation(changeValue, 0.0, 0.0);
            break;
        case KDGLChangeTypeScales:
            translationMatrix = GLKMatrix4MakeScale(changeValue, changeValue, 0.0);
            break;
        case KDGLChangeTypeRotation:
            translationMatrix = GLKMatrix4MakeZRotation(changeValue);
            break;
        default:
            break;
    }
    GLfloat *m = translationMatrix.m;
    int matrix = glGetUniformLocation(_linkProgram, "matrix");
    glUniformMatrix4fv(matrix, 1, GL_FALSE, m);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArray(0);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
