//
//  GLESView.m
//  OpenGL ES
//
//  Created by JT Ma on 01/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import "GLESView.h"
#import "GLESContext.h"
#import "GLESVertexAttribArrayBuffer.h"

@interface GLESView ()

@end

@implementation GLESView

/**
 This data type is used to store information for each vertex
 */
typedef struct {
    GLKVector3  positionCoords;
} SceneVertex;

/**
 Define vertex data for a triangle to use in example
 */
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}, // upper left corner
};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame context:(nonnull EAGLContext *)context {
    self = [super initWithFrame:frame context:context];
    if (self) {
        self.context = context;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self setupContext];
    [self setupEffect];
    [self setupBuffer];
}

- (void)dealloc {
    [self destoryBuffer];
}

- (void)setupContext {
    // Create an OpenGL ES 2.0 context and provide it to the view
    if (! self.context) {
        self.context = [[GLESContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    
    // Make the new context current
    [GLESContext setCurrentContext:self.context];
}

- (void)setupEffect {
    // Create a base effect that provides standard OpenGL ES 2.0
    // Shading Language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
}

- (void)setupBuffer {
    // Set the background color stored in the current context
    ((GLESContext *)self.context).clearColor = GLKVector4Make(0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[GLESVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                                                            bytes:vertices
                                                                            usage:GL_STATIC_DRAW];
}

- (void)draw {
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    [(GLESContext *)self.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:sizeof(vertices) / sizeof(SceneVertex)
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}

- (void)destoryBuffer {
    // Make the view's context current
    [GLESContext setCurrentContext:self.context];
    
    // Delete buffers that aren't needed when view is unloaded
    self.vertexBuffer = nil;
    
    [GLESContext setCurrentContext:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self draw];
}

@end
