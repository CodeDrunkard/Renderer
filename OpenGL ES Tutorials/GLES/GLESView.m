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

@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end

@implementation GLESView

/**
 This data type is used to store information for each vertex
 */
typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;

/**
 Define vertex data for a triangle to use in example
 */
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
    {{ 0.5f,  0.5f, 0.0f}, {1.0f, 1.0f}},
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
    [self setupTexture];
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

- (void)setupTexture {
    CGImageRef imageRef0 = [[UIImage imageNamed:@"sky.jpeg"] CGImage];
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0
                                                                options:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                                                                 error:NULL];
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"hedy.png"] CGImage];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1
                                                                options:[NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil]
                                                                 error:NULL];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)draw {
    // Clear back frame buffer (erase previous drawing)
    [(GLESContext *)self.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
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
