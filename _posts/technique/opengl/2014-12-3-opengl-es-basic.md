---
layout: post
title: "[OpenGL ES 2.0学习]-1 基本概念"
category: OpenGL
tags: [OpenGL ES 2.0]
description: ""
---

## [OpenGL ES 2.0 Reference Card](https://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf)

## Shader Program
### 两种shader脚本
- glsl: short name for OpenGL Shader Language, is a high-level shading language based on the syntax of the C programming language. It was created by the OpenGL ARB (OpenGL Architecture Review Board) to give developers more direct control of the graphics pipeline without having to use ARB assembly language or hardware-specific languages.

- hlsl: Hihg Level Shader Language, from Microfost against OpenGL


### shader脚本文件的后缀名
- vertex shader: .glsl, .vs(in OpenGL Shader Builder)
- fragment shader: .glsl, .fs(in OpenGL Shader Builder)
- geometry shader: .glsl, .gs(in OpenGL Shader Builder)


## 两种投影
- 正交投影, 2D
- 透视投影, 3D

# 下面的总结是《opengl es 2.0 实践指南》上代码总结，现在已经不参考那本书了，因为用java写opengl程序感觉太别扭.
## 第一个ES2.0程序

---

## 学到的东西

```java
ByteOrder bOrder = vertexData.order();
if (bOrder == ByteOrder.BIG_ENDIAN) {
    // is big endian
} else {
    // ByteOrder.LITTLE_ENDIAN
}

// use native order
byteBuffer.order(ByteOrder.nativeOrder())

```

## 遇到的问题：
- q1. `java.lang.IllegalArgumentException: Must use a native order direct Buffer`

use allocateDirect instead of allocate.

```java
float[] tableVerticesWithTriangles = {
    // first triangle.
    -0.5f, -0.5f, 0.5f, 0.5f, -0.5f, 0.5f,

    // second triangle.
    -0.5f, -0.5f, 0.5f, -0.5f, 0.5f, 0.5f,

    // middle line
    -0.5f, 0f, 0.5f, 0f,

    // two points
    0f, -0.25f, 0f, 0.25f 
};
FloatBuffer vertexData = ByteBuffer.allocate(tableVerticesWithTriangles.length * BYTES_PER_FLOAT).order(ByteOrder.nativeOrder()).asFloatBuffer();
// ... when pass the vertexData to OpenGL memory:
vertexData.position(0);
// crash here: "java.lang.IllegalArgumentException: Must use a native order direct Buffer"
glVertexAttribPointer(aPostionLocation, POSITION_COMPONENT_COUNT, GL_FLOAT, false, 0, vertexData); 
```

```java
// this is ok. use allocateDirect. 
// The vertBuff buffer needs to be direct so that it isn't moved around in memory. [from StackOverflow](http://stackoverflow.com/questions/11012669/opengl-es-rendereing-error)
// You need to use the allocateDirect(int) method from the ByteBuffer class.
vertexData = ByteBuffer.allocateDirect(tableVerticesWithTriangles.length * BYTES_PER_FLOAT).order(ByteOrder.nativeOrder()).asFloatBuffer();
```

