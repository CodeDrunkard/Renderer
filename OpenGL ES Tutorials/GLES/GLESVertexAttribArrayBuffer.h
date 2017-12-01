//
//  GLESVertexAttribArrayBuffer.h
//  OpenGL ES
//
//  Created by JT Ma on 01/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    GLESVertexAttribPosition = GLKVertexAttribPosition,
    GLESVertexAttribNormal = GLKVertexAttribNormal,
    GLESVertexAttribColor = GLKVertexAttribColor,
    GLESVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    GLESVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
} GLESVertexAttrib;

@interface GLESVertexAttribArrayBuffer : NSObject

@property (nonatomic, readonly) GLuint name;
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly) GLsizei stride;

/**
 The method create a vertex attribute array buffer in the current OpenGL ES context
 for the thread upon which this method is called

 @param stride The stride of attribute array buffer
 @param count A number of vertices to copy
 @param dataPtr The address of attribute array buffer to copy
 @param usage Cache in GPU memory
 @return The object of GLESVertexAttribArrayBuffer
 */
- (instancetype)initWithAttribStride:(GLsizei)stride
                    numberOfVertices:(GLsizei)count
                               bytes:(const GLvoid *)dataPtr
                               usage:(GLenum)usage;

/**
 The method loads the data stored by the receiver

 @param stride The stride of attribute array buffer
 @param count A number of vertices to copy
 @param dataPtr The address of attribute array buffer to copy
 */
- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

/**
 A vertex atrribute array buffer must be prepared when your application wants to use the buffer to render any geometry.
 When your application prepares an buffer, some OpenGL ES state is altered to allow bind the buffer and configure pointers.

 @param index Identifies the attribute array to use
 @param count A number of cooordinates for attribute array
 @param offset The offset from start of each vertex to first coord for attribute array
 @param shouldEnable Enable vertex attribute array
 */
- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

/**
 Submits the drawing command identified by mode and instructs OpenGL ES
 to use count vertices from the buffer starting from the vertex at index first.
 
 @param mode The drawing mode
 @param first Start with first vertex in currently bound buffer
 @param count The number of vertices
 */
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

@end
