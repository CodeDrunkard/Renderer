//
//  GLESVertexAttribArrayBuffer.m
//  OpenGL ES
//
//  Created by JT Ma on 01/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import "GLESVertexAttribArrayBuffer.h"

@interface GLESVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLuint name;
@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizei stride;

@end

@implementation GLESVertexAttribArrayBuffer

- (instancetype)initWithAttribStride:(GLsizei)stride
                    numberOfVertices:(GLsizei)count
                               bytes:(const GLvoid *)dataPtr
                               usage:(GLenum)usage {
    NSParameterAssert(0 < stride);
    NSAssert((0 < count && NULL != dataPtr) ||
             (0 == count && NULL == dataPtr),
             @"data must not be NULL or count > 0");
    
    self = [super init];
    if (self) {
        self.stride = stride;
        self.bufferSizeBytes = self.stride * count;
        glGenBuffers(1, &_name);
        glBindBuffer(GL_ARRAY_BUFFER, self.name);
        glBufferData(GL_ARRAY_BUFFER,
                     self.bufferSizeBytes,
                     dataPtr,
                     usage);
        
        NSAssert(0 != self.name, @"Failed to generate name");
    }
    return self;
}

- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr {
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != self.name, @"Invalid name");
    
    self.stride = stride;
    self.bufferSizeBytes = stride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    glBufferData(GL_ARRAY_BUFFER,
                 self.bufferSizeBytes,
                 dataPtr,
                 GL_DYNAMIC_DRAW);
}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable {
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != self.name, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    
    if(shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(index,
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          self.stride,
                          NULL + offset);
    
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count {
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride),
             @"Attempt to draw more vertex data than available.");
    
    glDrawArrays(mode, first, count);
}

- (void)dealloc {
    if (0 != self.name) {
        glDeleteBuffers(1, &_name);
        self.name = 0;
    }
}

@end
