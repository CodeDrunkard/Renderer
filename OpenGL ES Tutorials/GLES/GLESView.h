//
//  GLESView.h
//  OpenGL ES
//
//  Created by JT Ma on 01/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import <GLKit/GLKit.h>

@class GLESVertexAttribArrayBuffer;

@interface GLESView : GLKView

@property (strong, nonatomic) GLKBaseEffect * baseEffect;
@property (strong, nonatomic) GLESVertexAttribArrayBuffer * vertexBuffer;

@end
