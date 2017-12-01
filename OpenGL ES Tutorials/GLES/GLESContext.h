//
//  GLESContext.h
//  OpenGL ES
//
//  Created by JT Ma on 01/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import <GLKit/GLKit.h>

@interface GLESContext : EAGLContext {
    GLKVector4 clearColor;
}

@property (nonatomic, assign, readwrite) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dfactor;

@end
