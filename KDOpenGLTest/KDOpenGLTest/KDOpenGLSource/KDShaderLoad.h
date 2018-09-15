//
//  KDShaderLoad.h
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/glext.h>

@interface KDShaderLoad : NSObject

+ (GLuint)kd_loadShaderWithName:(NSString *)shaderName andType:(GLenum)shaderType;

@end
