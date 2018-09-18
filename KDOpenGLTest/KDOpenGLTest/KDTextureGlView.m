//
//  KDTextureGlView.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/5.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDTextureGlView.h"
#import "KDShaderLoad.h"
#import "KDProgramLink.h"
#import "KDGLContextAndBufferConfig.h"
#import "KDTextureHandle.h"

//#import <OpenGLES/ES3/glext.h>

@interface KDTextureGlView()
{
    CAEAGLLayer *_glLayer;
    EAGLContext *_context;
}
@end

@implementation KDTextureGlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self kd_contextSet];
        [self kd_createFrameAndRenderBuffer];
//        KDGLContextAndBufferConfig *config = [[KDGLContextAndBufferConfig alloc] initWithLayer:(CAEAGLLayer *)self.layer andContext:_context];
        GLuint program = [self kd_linkProgram];
        [self kd_createViewPort];

//        float vertexMessageArr[] = {
//            0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
//            0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
//            -0.5f, -0.5f, 0.0f,  0.0f, 0.0f, // bottom left
//            -0.5f,  0.5f, 0.0f,  0.0f, 1.0f  // top left
//        };
        
//        unsigned int indices[] = { // 注意索引从0开始!
//            0, 1, 3, // 第一个三角形
//            1, 2, 3  // 第二个三角形
//        };
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
        
//        unsigned int EBO;
//        glGenBuffers(1, &EBO);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

        // 位置属性
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
        glEnableVertexAttribArray(0);
        
        //Texture位置
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
        glEnableVertexAttribArray(1);
        
        glActiveTexture(GL_TEXTURE0);
        GLuint texture1 =  [self kd_creatTextureWithImageName:@"KDPicture1"];
        glBindTexture(GL_TEXTURE_2D, texture1);
//        GLuint texture0Uniform = glGetUniformLocation(program, "texturePic");
//        glUniform1i(texture0Uniform, 0);

        glActiveTexture(GL_TEXTURE1);
        GLuint texture2 =  [self kd_creatTextureWithImageName:@"KDPicture2"];
        glBindTexture(GL_TEXTURE_2D, texture2);
        GLuint texture1Uniform = glGetUniformLocation(program, "texturePic1");
        glUniform1i(texture1Uniform,1);
        
        //        glBindVertexArray(VAO);
        //        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);
        [_context presentRenderbuffer:GL_RENDERBUFFER];
        
    }
    return self;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (GLuint)kd_creatTextureWithImageName:(NSString *)imageName
{
    UIImage *image =  [UIImage imageNamed:@"KDPicture1"];
    NSData *data = UIImagePNGRepresentation(image);
    char *imageData = (char *)[data bytes];
    

    CGImageRef alpacaImage = [UIImage imageNamed:imageName].CGImage;
    if (!alpacaImage) {
        NSLog(@"Failed to load image");
    }
    
    size_t width = CGImageGetWidth(alpacaImage);
    size_t height = CGImageGetHeight(alpacaImage);
    GLubyte * alpacaData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    CGContextRef alpacaContext = CGBitmapContextCreate(alpacaData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(alpacaImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(alpacaContext, CGRectMake(0, 0, width, height), alpacaImage);
    CGContextRelease(alpacaContext);
    

    GLuint texture;
    glGenTextures(1, &(texture));
    glBindTexture(GL_TEXTURE_2D, texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    /*
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (float)width,
                 (float)heigh,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 alpacaImage);
     */
    //在这里浪费了很多时间 原因是将spriteData写成了上面的spriteImage
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (float)width,
                 (float)height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 alpacaData);
//    glGenerateMipmap(GL_TEXTURE_2D);
    free(alpacaData);

    
    return texture;
//    KDTextureHandle *handle = [[KDTextureHandle alloc] init];
//    return [handle kd_creatContextWithImageName:imageName];
}

- (void)kd_contextSet
{
    //这东西必须在当前的view的类中设置
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
//    [[KDShaderLoad shareInstance] loadShaderWithName:fileName andType:type];
}

- (GLuint)kd_linkProgram
{
//    NSDictionary *dic = @{@"KDTextureVertex":@"GL_VERTEX_SHADER",@"KDTextureFragment":@"GL_FRAGMENT_SHADER"};
//    return [KDProgramLink kd_programLinkWithShaderDic:dic];
    GLuint vertexShader = [self kd_loadShader:@"KDTextureVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self kd_loadShader:@"KDTextureFragment" withType:GL_FRAGMENT_SHADER];
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

- (void)kd_createFrameAndRenderBuffer
{
    _glLayer = (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    _glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
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
    CGFloat scale = [[UIScreen mainScreen] scale];
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
