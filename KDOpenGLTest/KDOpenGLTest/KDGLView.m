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

// attribute vec3 aPos1;
 
// attribute vec3 aPos;
 layout (location = 0) in vec3 aPos
 void main()
 {
     gl_Position = vec4(aPos.x,aPos.y,aPos.z,1.0);
 }
);

NSString *const fragmentShaderString = SHADER_STRING
(
 void main()
 {
     gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
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
        
        //context init
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
        
        //program init and link
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
        
        glUseProgram(shaderProgram);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
//        glGetAttribLocation(shaderProgram, "aPos");
        
        
        //frameBuffer and renderBuffer
        GLuint frameBuffer;
        glGenFramebuffers(1, &frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
        
        GLuint renderBuffer;
        glGenRenderbuffers(1, &renderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:glLayer];
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
        
        GLint _backingWidth;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
        GLint _backingHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
        
        //Viewport
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        glViewport(0, 0, _backingWidth, _backingHeight);
        
        //framebuffer  renderbuffer viewport一定需要在传vbo前创建
        
        //将数据传到shader
        GLfloat vertexArr[] = {
            -0.5f, -0.5f, 0.0f,
            0.5f, -0.5f, 0.0f,
            0.0f,  0.5f, 0.0f
        };
        
        //使用VBO VAO
        GLuint VAO;
        glGenVertexArrays(1, &VAO);
        glBindVertexArray(VAO);
        
        GLuint VBO;
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexArr), vertexArr, GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
        glEnableVertexAttribArray(0);


        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);
        
        //使用VBO IBO
//        const GLfloat vertices[] = {
//            0.5f, 0.5f, 0.0f,   // 右上角
//            0.5f, -0.5f, 0.0f,  // 右下角
//            -0.5f, -0.5f, 0.0f, // 左下角
//            -0.5f, 0.5f, 0.0f   // 左上角
//        };
//
//        const GLubyte indices[] = {
//            0,1,3,   // 绘制第一个三角形
//            1,2,3    // 绘制第二个三角形
//        };
//
//        // 创建一个渲染缓冲区对象
//        GLuint vertexBuffer;
//
//        // 使用glGenBuffers()生成新缓存对象并指定缓存对象标识符ID
//        glGenBuffers(1, &vertexBuffer);
//
//        // 绑定vertexBuffer到GL_ARRAY_BUFFER目标
//        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
//
//        // 为VBO申请空间，初始化并传递数据
//        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
//
//        GLuint indexBuffer;
//        glGenBuffers(1, &indexBuffer);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
//        // 使用VBO时，最后一个参数0为要获取参数在GL_ARRAY_BUFFER中的偏移量
//        // 使用glVertexAttribPointer函数告诉OpenGL该如何解析顶点数据
//        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
//        glEnableVertexAttribArray(0);
//        //    glDrawArrays(GL_TRIANGLES, 0, 4);
//        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
        

        [context presentRenderbuffer:GL_RENDERBUFFER];
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
