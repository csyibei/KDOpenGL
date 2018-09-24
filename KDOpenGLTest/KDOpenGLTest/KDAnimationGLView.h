//
//  KDAnimationGLView.h
//  KDOpenGLTest
//
//  Created by csyibei on 2018/9/14.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KDGLChangeType) {
    KDGLChangeTypeTranslation,
    KDGLChangeTypeScales,
    KDGLChangeTypeRotation,
};

@interface KDAnimationGLView : UIView
- (void)kd_changeWithChangeType:(KDGLChangeType)changeType changeValue:(CGFloat)changeValue;
@end
