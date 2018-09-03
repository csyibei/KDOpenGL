//
//  KDNewGLView.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/4.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDNewGLView.h"
#import <OpenGLES/ES3/glext.h>

@interface KDNewGLView()
{
    CAEAGLLayer *_glLayer;
    EAGLContext *_context;
}
@end

@implementation KDNewGLView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self kd_contextSet];
        [self kd_linkProgram];
        [self kd_createFrameAndRenderBuffer];
        [self kd_createViewPort];
        
        float vertices[] = {
            // 位置              // 颜色
            0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,   // 右下
            -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,   // 左下
            0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f    // 顶部
        };
        //使用VBO VAO
        GLuint VAO;
        glGenVertexArrays(1, &VAO);
        glBindVertexArray(VAO);
        
        GLuint VBO;
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        // 位置属性
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        // 颜色属性
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3* sizeof(float)));
        glEnableVertexAttribArray(1);
        
        
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);
        
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)kd_contextSet
{
    _glLayer = (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    _glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"set context failed");
    }
}

- (GLuint)kd_loadShader:(NSString *)fileName withType:(GLenum)type
{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"glsl"];
    NSError *loadError;
    NSString *shaderStr = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&loadError];
    if (loadError) {
        NSLog(@"load failed");
    }
    
    GLuint shader = glCreateShader(type);
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

- (void)kd_linkProgram
{
    GLuint vertexShader = [self kd_loadShader:@"KDVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self kd_loadShader:@"KDFragment" withType:GL_FRAGMENT_SHADER];
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
}

- (void)kd_createFrameAndRenderBuffer
{
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    GLuint renderBuffer;
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    
    GLint _backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    GLint _backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
}

- (void)kd_createViewPort
{
    GLint _backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    GLint _backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    //Viewport
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, _backingWidth, _backingHeight);
}








@end
