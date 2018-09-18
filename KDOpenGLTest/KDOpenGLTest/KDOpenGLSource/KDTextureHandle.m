//
//  KDTextureHandle.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/17.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "KDTextureHandle.h"
#import <UIKit/UIKit.h>

@implementation KDTextureHandle
- (GLuint)kd_creatContextWithImageName:(NSString *)imageName
{
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
    
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (float)width,
                 (float)height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 alpacaData);
    free(alpacaData);
    
    return texture;
}
@end
