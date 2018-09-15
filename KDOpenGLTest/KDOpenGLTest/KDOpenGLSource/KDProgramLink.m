//
//  KDProgramLink.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDProgramLink.h"
#import "KDShaderLoad.h"

@implementation KDProgramLink

+(GLuint)kd_programLinkWithShaderDic:(NSDictionary *)shaderDic
{
    GLuint vertexShader = 0;
    GLuint fragmentShader = 0;
    for (NSString *key in shaderDic) {
        if ([shaderDic[key] isEqualToString:@"GL_VERTEX_SHADER"]) {
            vertexShader = [KDShaderLoad kd_loadShaderWithName:key andType:GL_VERTEX_SHADER];
        }else if ([shaderDic[key] isEqualToString:@"GL_FRAGMENT_SHADER"]){
            fragmentShader = [KDShaderLoad kd_loadShaderWithName:key andType:GL_FRAGMENT_SHADER];
        }else{
            NSLog(@"this type of shader no need");
        }
    }
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);

    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    GLchar linkInfoLog[1024];
    if (linkSuccess == GL_FALSE) {
        glGetShaderInfoLog(programHandle,1024, NULL,linkInfoLog);
        NSLog(@"%s", linkInfoLog);
    }

    // 调用 glUseProgram绑定程序对象 让OpenGL ES真正执行你的program进行渲染
    glUseProgram(programHandle);
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}

@end
