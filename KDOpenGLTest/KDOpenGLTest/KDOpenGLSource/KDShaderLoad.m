//
//  KDShaderLoad.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDShaderLoad.h"

@implementation KDShaderLoad

+ (GLuint)kd_loadShaderWithName:(NSString *)shaderName andType:(GLenum)shaderType
{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *loadError;
    NSString *shaderStr = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&loadError];
    if (loadError) {
        NSLog(@"load failed");
    }
    
    GLuint shader = glCreateShader(shaderType);
    if (shader == 0) {
        NSLog(@"creat shader failed");
    }
    
    const GLchar *shaderCStr = (GLchar *)shaderStr.UTF8String;
    glShaderSource(shader, 1, &shaderCStr, NULL);
    
    glCompileShader(shader);
    
    GLint compile;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compile);
    GLchar compileInfoLog[256];
    if (compile == GL_FALSE) {
        glGetShaderInfoLog(shader,1024, NULL,compileInfoLog);
        NSLog(@"%s", compileInfoLog);
    }
    
    return shader;
}

@end
