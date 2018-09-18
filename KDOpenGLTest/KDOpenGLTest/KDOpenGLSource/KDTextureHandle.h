//
//  KDTextureHandle.h
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/17.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/glext.h>

@interface KDTextureHandle : NSObject
- (GLuint)kd_creatContextWithImageName:(NSString *)imageName;
@end
