//
//  KDProgramLink.h
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/glext.h>

@interface KDProgramLink : NSObject

+ (GLuint)kd_programLinkWithShaderDic:(NSDictionary *)shaderDic;

@end
