//
//  KDGLView.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/3.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDGLView.h"
#import <OpenGLES/ES3/glext.h>


#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const vertexShaderString = SHADER_STRING
(
 attribute vec3 aPos;
 void main()
 {
     gl_Position = vec4(aPos.x,aPos.y,aPos.z,1.0);
 }
);

NSString *const fragmentShaderString = SHADER_STRING
(
 void main()
 {
     gl_FragColor = vec4(1.0, 0.5, 0.2, 1.0);
 }
);

@implementation KDGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        CAEAGLLayer *glLayer = (CAEAGLLayer *)self.layer;
        glLayer.opaque = YES;
        glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        if (![EAGLContext setCurrentContext:context]) {
            NSLog(@"set context failed");
        }
        
        //vertex shader init and compile
        GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        if (vertexShader == 0 || vertexShader == GL_INVALID_ENUM) {
            NSLog(@"create shader failed");
        }
        const GLchar *vertexStr = (GLchar *)vertexShaderString.UTF8String;
        glShaderSource(vertexShader, 1, &vertexStr, NULL);
        glCompileShader(vertexShader);
        
        GLint status;
        glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &status);
        char infoLog[1024];
        if (status == GL_FALSE) {
            glGetShaderInfoLog(vertexShader, 1024, NULL, infoLog);
            NSLog(@"complie shader failed");
            NSLog(@"%s",infoLog);
        }
        
        //fragment shader init and compile
        GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        if (fragmentShader == 0 || fragmentShader == GL_INVALID_ENUM) {
            NSLog(@"create shader failed");
        }
        const GLchar *fragmentStr = (GLchar *)fragmentShaderString.UTF8String;
        glShaderSource(fragmentShader, 1, &fragmentStr, NULL);
        glCompileShader(fragmentShader);
        
        GLint fragmentStatus;
        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &fragmentStatus);
        char fragmentInfoLog[1024];
        if (fragmentStatus == GL_FALSE) {
            glGetShaderInfoLog(fragmentShader, 1024, NULL, fragmentInfoLog);
            NSLog(@"complie shader failed");
            NSLog(@"%s",fragmentInfoLog);
        }
        
        //program init
        unsigned int shaderProgram;
        shaderProgram = glCreateProgram();
        
        GLint linkStatus;
        glAttachShader(shaderProgram, vertexShader);
        glAttachShader(shaderProgram, fragmentShader);
        glLinkProgram(shaderProgram);
        glGetProgramiv(shaderProgram, GL_LINK_STATUS, &linkStatus);
        char linkInfoLog[1024];
        if (linkStatus == GL_FALSE) {
            glGetProgramInfoLog(shaderProgram,1024, NULL,linkInfoLog);
            NSLog(@"program link failed");
            NSLog(@"%s",linkInfoLog);
        }
        
        
        glViewport(0, 0, 100, 100);
        glClearColor(1.0, 0.5, 0.2, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        glUseProgram(shaderProgram);
        glDeleteShader(vertexShader);
        
        
        GLfloat vertexArr[] = {
            -0.5f, -0.5f, 0.0f,
            0.5f, -0.5f, 0.0f,
            0.0f,  0.5f, 0.0f
        };
        
        unsigned int VBO;
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexArr), vertexArr, GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (void *)0);
        glEnableVertexAttribArray(0);
        
        unsigned int VAO;
        glGenVertexArrays(1, &VAO);
        
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
