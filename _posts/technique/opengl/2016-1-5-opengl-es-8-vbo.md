---
layout: post
title: "【C++ OpenGL ES 2.0编程笔记】8: 使用VBO和IBO绘制立方体"
category: OpenGL
tags: [opengl]
description: ""
---

**作者是现在对相关知识理解还不是很深入，后续会不断完善。因此文中内容仅供参考，具体的知识点请以OpenGL的官方文档为准**

# 前言

本文介绍了OpenGL ES 2.0 中的顶点缓冲对象(VBO: Vertex Buffer Object)和索引缓冲对象(IBO: Indice Buffer Object)的用法，

在之前的文章中图元的绘制没用使用VBO, 要绘制的顶点数据是以顶点数组的形式保存在客户端的内存中的，在每次调用`glDrawArrays`或者`glDrawElements`的时候，顶点数组都会被从客户端内存copy到显卡内存。

VBO的作用，就是把这份每次都要copy的顶点数组缓存在显卡的内存中，VBO使得我可以直接在显卡内存中分配并缓存顶点数据。这样就避免了每次调用draw的时候的copy操作，从而提高了渲染性能同时降低了内存带宽和设备的电量消耗。

IBO跟VBO的原理类似，只不过IBO是缓存了VBO绘制时候的Indices. 

根据OpenGL ES 2.0 "Golden Book"的建议，要想获得最好的性能，就要尽可能使用VBO和IBO来完成绘制任务。

下面以一个具体的例子来展示如何使用VBO和IBO完成一个正方体的绘制。

# 效果图

<!--more-->

图中这个绿色的正方体就是绘制的结果

![vbo_cube.gif](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/vbo_cube.gif)

# 实现

主要分三步：

1. 准备好顶点数据，顶点索引数据； 

2. 创建VBO和IBO，分别和顶点数据、顶点索引数据绑定；

3. 使用绑定后的VBO和IBO来完成绘制

## 1. 准备好顶点数据，顶点索引数据

### 正方体有八个顶点，定义如下：

绘制正方体主要是确定其八个顶点的坐标，如下图所示：

![cube_vertex.png](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/cube_vertex.png)

按编号从0~7以不同的颜色标识，下面定义出这8个顶点

{% highlight c++ %}
// x,y,z,  u,v,   r,g,b,a
Vertex cubeVertex[] =
{
    { -1.0f, -1.0f,  1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 0
    {  1.0f, -1.0f,  1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 1
    {  1.0f,  1.0f,  1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 2
    { -1.0f,  1.0f,  1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 3
    { -1.0f, -1.0f, -1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 4
    { -1.0f,  1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 5
    {  1.0f,  1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 6
    {  1.0f, -1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 7
};

// 根据上面图中的顶点标号，可以很容易确定三角形绘制的顶点索引.
// 正方体共6个面，如下编号为0~5， 每个面是个四边形，由两个三角形组成
// 比如第0个面，由 0,1,2 这个三角形和 0,2,3 这个三角形组成。其他面依次类推 
GLubyte cubeIndices[] =
{
    0, 1, 2, 0, 2, 3, // Quad 0
    4, 5, 6, 4, 6, 7, // Quad 1
    5, 3, 2, 5, 2, 6, // Quad 2
    4, 7, 1, 4, 1, 0, // Quad 3
    7, 6, 2, 7, 2, 1, // Quad 4
    4, 0, 3, 4, 3, 5  // Quad 5
};
{% endhighlight %}

## 2. 创建VBO和IBO，分别和顶点数据、顶点索引数据绑定

上面定义好了两个数组，接下来分别把顶点数组和索引数据绑定到VBO和IBO。

{% highlight c++ %}

unsigned int    _vbo;
unsigned int    _ibo;


// ======== 创建并绑定VBO

glGenBuffers(1, &_vbo); //创建VBO，1代表创建一个， 传入的_vbo是一个unsigned int，仅保存一个VBO.
glBindBuffer(GL_ARRAY_BUFFER, _vbo);    // 绑定新创建的VBO
glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertex), cubeVertex, GL_STATIC_DRAW); // 传数据, 具体参数说明后面给出
glBindBuffer(GL_ARRAY_BUFFER, 0); // 解除当前绑定的VBO

// ========= 创建并绑定IBO

glGenBuffers(1, &_ibo); // 同VBO
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo); // 同VBO，仅仅是第一个参数不一样
glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof( cubeIndices ), cubeIndices, GL_STATIC_DRAW); // 同VBO
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
{% endhighlight %}

## 3. 使用绑定后的VBO和IBO来完成绘制

万事俱备，现在开始绘制：

{% highlight c++ %}
glBindTexture(GL_TEXTURE_2D, _textureCube);         // 立方体的纹理，忽略
glUniformMatrix4fv(_mvp, 1, false, mvpDog.data());  // 投影矩阵，忽略

// ========== 使用 VBO和IBO进行绘制
glBindBuffer(GL_ARRAY_BUFFER, _vbo);                // 绑定之前创建好的VBO
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);        // 绑定之前创建好的IBO

int offset = 0;                                     // 从_vbo中取数据要使用偏移量来指定位置
// x,y,z 在数组的开头，因此偏移量是0.
glVertexAttribPointer(_position, 3, GL_FLOAT, false, sizeof(Vertex), reinterpret_cast<void*>(offset));

offset += 3 * sizeof(float); // 纹理坐标在x,y,z之后，因此要加上3个float的偏移量
glVertexAttribPointer(_uv, 2, GL_FLOAT, false, sizeof(Vertex), reinterpret_cast<void*>(offset));

glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, 0); // 使用_ibo指定的36个索引来绘制。 

glBindBuffer(GL_ARRAY_BUFFER, 0);           // 使用完要解除VBO绑定
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);   // 使用完要解除IBO绑定
{% endhighlight %}

# 完整的源代码和Shader

**VboScene.h**

{% highlight c++ %}
#pragma  once

#include "gl_include.h"
#include "ELShaderProgram.h"
#include <string>
#include <vector>

NS_BEGIN(elloop);
NS_BEGIN(vbo_scene);

class FirstCamera
{
public:
    FirstCamera()
        : _moveSpeed(5)
        , _eye(0, 10, 0)
        , _look(0.5, -0.4, -0.5)
        , _up(0, 1, 0)
        , _right(1, 0, 0)
    {
    }
    CELL::float3    _eye;
    CELL::float3    _look;
    CELL::float3    _up;
    CELL::float3    _right;
    float           _moveSpeed;

    void updateCamera(float dt)
    {
        using namespace CELL;
        float3 tempLook = _look;
        float3 direction = _look - _eye;
        direction = normalize(direction);
        unsigned char keys[300];
        GetKeyboardState(keys);
        if (keys[VK_UP] & 0x80) 
        {
            _eye  -= direction * (-_moveSpeed) * dt;
            _look -= direction * (-_moveSpeed) * dt;
        }

        if (keys[VK_DOWN] & 0x80)
        {
            _eye += direction * (-_moveSpeed) * dt;
            _look += direction * (-_moveSpeed) * dt;
        }

        if (keys[VK_LEFT] & 0x80)
        {
            _eye -= _right * _moveSpeed * dt;
            _look -= _right * _moveSpeed * dt;
        }

        if (keys[VK_RIGHT] & 0x80)
        {
            _eye += _right * _moveSpeed * dt;
            _look += _right * _moveSpeed * dt;
        }
    }
};


class VboScene : public ShaderProgram
{
public:
    struct Vertex
    {
        float x, y, z;
        float u, v;
        float r, g, b, a;
    };

    static VboScene*            create();
    void                        begin()     override;
    void                        end()       override;
    void                        render()    override;

    uniform                     _mvp;
    uniform                     _textureBg;
    attribute                   _position;
    attribute                   _uv;

    unsigned int                _textureBgId;
    unsigned int                _textureCube;

    unsigned int                _vbo;
    unsigned int                _ibo;

    FirstCamera                 _camera;

protected:

    bool                        init();
    VboScene()
        : _mvp(-1)
        , _textureBg(-1)
        , _textureBgId(0)
        , _position(-1)
        , _uv(-1)
        , _textureCube(0)
        , _vbo(0)
        , _ibo(0)
    {
        _vsFileName = "shaders/3D_projection_vs.glsl";
        _fsFileName = "shaders/3D_projection_fs.glsl";
    }
    ~VboScene()
    {
        glDeleteTextures(1, &_textureBgId);
        glDeleteTextures(1, &_textureCube);
    }
    unsigned int loadMipMap(const std::vector<std::string> &fileNames);
    unsigned int loadTexture(const std::string &fileName );
};


NS_END(vbo_scene);
NS_END(elloop);
{% endhighlight %}

**VboScene.cpp**

{% highlight c++ %}
#include "scenes/VboScene.h"
#include "app_control/ELDirector.h"
#include "math/ELGeometry.h"
#include "include/freeImage/FreeImage.h"

NS_BEGIN(elloop);
NS_BEGIN(vbo_scene);

void VboScene::begin()
{
    glUseProgram(_programId);
    glEnableVertexAttribArray(_position);
    glEnableVertexAttribArray(_uv);
}

void VboScene::end()
{
    glDisableVertexAttribArray(_uv);
    glDisableVertexAttribArray(_position);
    glUseProgram(0);
}

bool VboScene::init()
{
    _valid = ShaderProgram::initWithFile(_vsFileName, _fsFileName);
    if ( _valid )
    {
        _position       = glGetAttribLocation(_programId, "_position");
        _uv             = glGetAttribLocation(_programId, "_uv");
        _textureBg      = glGetUniformLocation(_programId, "_textureBg");
        _mvp            = glGetUniformLocation(_programId, "_mvp");
    }

    std::vector<std::string> fileNames =
    {
        "images/p32x32.bmp",
        "images/p16x16.bmp",
        "images/p8x8.bmp",
        "images/p4x4.bmp",
        "images/p2X2.bmp",
        "images/p1x1.bmp"
    };

    _textureBgId = loadMipMap(fileNames);
    _textureCube = loadTexture("images/1.jpg");

    _camera._eye = CELL::float3(1, 1, 1);
    _camera._look = CELL::float3(0.5f, -0.4f, -5.5f);
    _camera._up = CELL::float3(0.0f, 1.0f, 0.0f);
    _camera._right = CELL::float3(1.0f, 0.0f, 0.0f);

    
    Vertex cubeVertex[] =
    {
        { -1.0f, -1.0f,  1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 0
        {  1.0f, -1.0f,  1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 1
        {  1.0f,  1.0f,  1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 2
        { -1.0f,  1.0f,  1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 3
        { -1.0f, -1.0f, -1.0f,  0.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 4
        { -1.0f,  1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 5
        {  1.0f,  1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 6
        {  1.0f, -1.0f, -1.0f,  1.0f, 1.0f,     1.0f, 1.0f, 1.0f, 1.0f }, // 7
    };

    GLubyte cubeIndices[] =
    {
        0, 1, 2, 0, 2, 3, // Quad 0
        4, 5, 6, 4, 6, 7, // Quad 1
        5, 3, 2, 5, 2, 6, // Quad 2
        4, 7, 1, 4, 1, 0, // Quad 3
        7, 6, 2, 7, 2, 1, // Quad 4
        4, 0, 3, 4, 3, 5  // Quad 5
    };

    // create vertex buffer object.
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertex), cubeVertex, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glGenBuffers(1, &_ibo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof( cubeIndices ), cubeIndices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    // or
    /* glBufferData(GL_ARRAY_BUFFER, sizeof vertexes, 0, GL_STATIC_DRAW);
     glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof vertexes, vertexes);*/

    return _valid;
}

VboScene* VboScene::create()
{
    auto * self = new VboScene();
    if ( self && self->init() )
    {
        self->autorelease();
        return self;
    }
    return nullptr;
}

unsigned int VboScene::loadMipMap(const std::vector<std::string> &fileNames)
{
    unsigned int textureId = 0;

    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    size_t nums = fileNames.size();
    for (size_t i=0; i<nums; ++i) 
    {
        FREE_IMAGE_FORMAT format = FreeImage_GetFileType(fileNames[i].c_str(), 0);

        FIBITMAP *bitmap = FreeImage_Load(format, fileNames[i].c_str(), 0);

        bitmap = FreeImage_ConvertTo24Bits(bitmap);

        BYTE *pixels = FreeImage_GetBits(bitmap);

        int width = FreeImage_GetWidth(bitmap);
        int height = FreeImage_GetHeight(bitmap);

        for (size_t j = 0; j < width*height * 3; j += 3)
        {
            BYTE temp = pixels[j];
            pixels[j] = pixels[j + 2];
            pixels[j + 2] = temp;
        }

        glTexImage2D(GL_TEXTURE_2D, i, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);

        FreeImage_Unload(bitmap);
    }
   
    return textureId;
}

void VboScene::render()
{
    using namespace CELL;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    auto director = Director::getInstance();
    Size s = director->getFrameSize();
    float width = s._width;
    float height = s._height;

    glViewport(0, 0, width, height);

    _camera.updateCamera(0.016);

    
    float gSize = 100;
    float gPos = -5;
    float repeat = 100;

    Vertex ground[] = 
    {
        { -gSize, gPos, -gSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { gSize, gPos, -gSize,  repeat, 0.0f,   1.0f, 1.0f, 1.0f, 1.0f },
        { gSize, gPos, gSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },

        { -gSize, gPos, -gSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { gSize, gPos, gSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },
        { -gSize, gPos, gSize,  0.0f, repeat,   1.0f, 1.0f, 1.0f, 1.0f },
    };

    begin();

    matrix4 matWorld(1);
    matrix4 matView = lookAt(_camera._eye, _camera._look, _camera._up);
    matrix4 matProj = perspective(45.0f, width / height, 0.1f, 100.f);
    matrix4 mvp = matProj * matView * matWorld;

    // draw ground.
    glUniform1i(_textureBg, 0);
    glBindTexture(GL_TEXTURE_2D, _textureBgId);
    glUniformMatrix4fv(_mvp, 1, false, mvp.data());
    glVertexAttribPointer(_position, 3, GL_FLOAT, false, sizeof(Vertex), &ground[0].x);
    glVertexAttribPointer(_uv, 2, GL_FLOAT, false, sizeof(Vertex), &ground[0].u);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(ground) / sizeof (ground[0]));



    // draw cube, 
    matrix4 matTrans;
    matTrans.translate(0, 0, -1);
    matrix4 mvpDog = matProj * matView * matTrans;

    glBindTexture(GL_TEXTURE_2D, _textureCube);
    glUniformMatrix4fv(_mvp, 1, false, mvpDog.data());

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);

    int offset = 0;
    glVertexAttribPointer(_position, 3, GL_FLOAT, false, sizeof(Vertex), reinterpret_cast<void*>(offset));

    offset += 3 * sizeof(float); // u,v is after x,y,z three floats.
    glVertexAttribPointer(_uv, 2, GL_FLOAT, false, sizeof(Vertex), reinterpret_cast<void*>(offset));

    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, 0); // use ibo.

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    end();
}

unsigned int VboScene::loadTexture(const std::string &fileName)
{
    unsigned int textureId = 0;

    FREE_IMAGE_FORMAT format = FreeImage_GetFileType(fileName.c_str(), 0);

    FIBITMAP *bitmap = FreeImage_Load(format, fileName.c_str(), 0);

    int width = FreeImage_GetWidth(bitmap);
    int height = FreeImage_GetHeight(bitmap);

    BYTE *pixels = FreeImage_GetBits(bitmap);

    int pixelFormat = GL_RGB;
    if (FIF_PNG == format)
    {
        bitmap = FreeImage_ConvertTo32Bits(bitmap);
        pixelFormat = GL_RGBA;
        for (size_t i = 0; i < width*height * 4; i += 4)
        {
            BYTE temp = pixels[i];
            pixels[i] = pixels[i + 2];
            pixels[i + 2] = temp;
        }
    }
    else
    {
        bitmap = FreeImage_ConvertTo24Bits(bitmap);
        for (size_t i = 0; i < width*height * 3; i += 3)
        {
            BYTE temp = pixels[i];
            pixels[i] = pixels[i + 2];
            pixels[i + 2] = temp;
        }
    }

    glGenTextures(1, &textureId);

    glBindTexture(GL_TEXTURE_2D, textureId);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    glTexImage2D(GL_TEXTURE_2D, 0, pixelFormat, width, height, 0, pixelFormat, GL_UNSIGNED_BYTE, pixels);

    FreeImage_Unload(bitmap);

    return textureId;
}

NS_END(vbo_scene);
NS_END(elloop);
{% endhighlight %}

**顶点shader: 3D_projection_vs.glsl**

{% highlight c++ %}
precision lowp float;

attribute   vec3    _position;
uniform     mat4    _mvp;

attribute   vec2    _uv;
varying     vec2    _outUv;

void main() 
{
    vec4 pos    = vec4(_position.x, _position.y, _position.z, 1);
    gl_Position = _mvp * pos;
    _outUv      = _uv;
}
{% endhighlight %}

**片段shader: 3D_projection_fs.glsl**

{% highlight c++ %}

precision lowp float;

varying     vec2        _outUv;
uniform     sampler2D   _textureBg;


void main() 
{
    vec4    bgColor    = texture2D(_textureBg, _outUv);
    gl_FragColor       = bgColor;
}
{% endhighlight %}

# 源码下载

- [OpenGL-ES-2.0-cpp](https://github.com/elloop/OpenGL-ES-2.0-cpp)

如果源码对您有帮助，请帮忙在github上给我点个Star, 感谢 :)

# 参考

本文侧重实战，api的使用细节请参考下面第二个链接，那里有各种OpenGL的API说明。

- [The OpenGL ES 2.0 programming guide / Aaftab Munshi, Dan Ginsburg, Dave Shreiner (2008)](http://book.douban.com/subject/3175883/) 

- [glBindBuffer](http://docs.gl/es2/glBindBuffer)

- 推荐一个入门的[OpenGL ES 视频](http://edu.csdn.net/course/detail/958)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

