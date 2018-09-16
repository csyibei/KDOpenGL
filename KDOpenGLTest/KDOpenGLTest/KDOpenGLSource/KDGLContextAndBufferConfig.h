//
//  KDGLContextAndBufferConfig.h
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/15.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/glext.h>
#import <UIKit/UIKit.h>


@interface KDGLContextAndBufferConfig : NSObject
@property (nonatomic,readonly,assign) GLuint frameBuffer;
@property (nonatomic,readonly,assign) GLuint renderBuffer;

- (instancetype)initWithLayer:(CAEAGLLayer *)glLayer andContext:(EAGLContext *)context;

@end
