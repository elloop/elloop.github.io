---
layout: post
title: "【OpenGL ES 2.0编程笔记】5: mipmap"
category: OpenGL
tags: [opengl]
description: ""
---

**作者是现在对相关知识理解还不是很深入，后续会不断完善。因此文中内容仅供参考，具体的知识点请以OpenGL的官方文档为准**

# 前言

本文介绍了OpenGL ES 2.0 中常用的多级纹理贴图技术，mipmap, 给出了一个使用mipmap的3D场景示例。

>在三维计算机图形的贴图渲染中有一个常用的技术被称为Mipmapping。为了加快渲染速度和减少图像锯齿，贴图被处理成由一系列被预先计算和优化过的图片组成的文件,这样的贴图被称为 MIP map 或者 mipmap。这个技术在三维游戏中被非常广泛的使用。“MIP”来自于拉丁语 multum in parvo 的首字母，意思是“放置很多东西的小空间”。Mipmap 需要占用一定的内存空间，同时也遵循小波压缩规则 （wavelet compression）

mipmap的常见使用场景是，在一个采用透视投影的三维场景中，我们看到的东西是近大远小的，对于同一种东西，比如地板，近处使用像素尺寸较大的纹理，远处的使用像素较小的纹理，这样就节省了渲染的工作量。通过使用OpenGL的glTexImage2D函数可以实现多级纹理的加载，它的第二个参数就是纹理的级别。

# 效果图

<!--more-->

![mipmap_effect.gif](http://7xi3zl.com1.z0.glb.clouddn.com/mipmap_effect.gif)

从近到远，分别是不同级别图片绘制的结果，越远的位置图片像素越少。

# 实现

制作六张图片，大小分别为32x32, 16x16, 8x8, 4x4, 2x2, 1x1，如图，使用“绘图”工具，依次创建6个图片，画一个矩形，中间用纯色填充：

**1x1像素的图**：

![create_mipmap.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/create_mipmap.jpg)


**32x32像素的图**：

![create_mipmap32.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/create_mipmap32.jpg)


制作好的6个级别的图片依次如下所示，其中1x1的太小了，与16x16的都为红色：


![mipmap6.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/mipmap6.jpg)

把图片保存为p1x1.bmp ~ p32x32.bmp。接下来要在OpenGL程序中把它们组合成一个多级纹理，我该怎么做呢？

下面是代码示例，先来怎么定义一个函数把多张图片打包成一个mipmap.

```c++

// 组成多级纹理每一级的图片名字, 这个例子一共分为6级，像素尺寸从2的五次方到2的零次方。
std::vector<std::string> fileNames =
{
    "images/p32x32.bmp",
    "images/p16x16.bmp",
    "images/p8x8.bmp",
    "images/p4x4.bmp",
    "images/p2x2.bmp",
    "images/p1x1.bmp"
};

mipmapTextureId = loadMipMap(fileNames);

unsigned int MipMapTexture::loadMipMap(const std::vector<std::string> &fileNames)
{
    unsigned int textureId = 0;

    // 生成一个纹理
    glGenTextures(1, &textureId);

    // 绑定为2D纹理
    glBindTexture(GL_TEXTURE_2D, textureId);

    // 指定远端过滤方式, 仅两种模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    // 指定近端过滤方式, 包含6种模式，GL_LINEAR_MIPMAP_LINEAR 在相邻的纹理级别之间做线性插值计算.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // 加载每个级别的纹理
    size_t nums = fileNames.size();
    for (size_t i=0; i<nums; ++i) 
    {
        // 得到图片的纹理数据, 格式为RGB 各一个字节，共24位
        FREE_IMAGE_FORMAT format = FreeImage_GetFileType(fileNames[i].c_str(), 0);
        FIBITMAP *bitmap = FreeImage_Load(format, fileNames[i].c_str(), 0);
        bitmap = FreeImage_ConvertTo24Bits(bitmap);
        BYTE *pixels = FreeImage_GetBits(bitmap);

        int width = FreeImage_GetWidth(bitmap);
        int height = FreeImage_GetHeight(bitmap);

        // bgr to rgb. (windows)
        for (size_t j = 0; j < width*height * 3; j += 3)
        {
            BYTE temp = pixels[j];
            pixels[j] = pixels[j + 2];
            pixels[j + 2] = temp;
        }

        // 绑定第i级纹理.
        glTexImage2D(GL_TEXTURE_2D, i, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);

        FreeImage_Unload(bitmap);
    }
   
    return textureId;
}
```

通过调用这个`loadMipMap()`函数，我就可以创建出mipmap形式的多级纹理了，下面我把创建出的纹理贴在一个透视投影的三维场景里，我先把render的代码贴在这吧：


```c++
// 创建mipmap多级纹理
bool MipMapTexture::init()
{
    _valid = ShaderProgram::initWithFile(_vsFileName, _fsFileName);
    if ( _valid )
    {
        _position       = glGetAttribLocation(_programId, "_position");
        _uv             = glGetAttribLocation(_programId, "_uv");
        _mipmapTexture  = glGetUniformLocation(_programId, "_textureBg");
        _mvp            = glGetUniformLocation(_programId, "_mvp");
    }

    std::vector<std::string> fileNames =
    {
        "images/p32x32.bmp",
        "images/p16x16.bmp",
        "images/p8x8.bmp",
        "images/p4x4.bmp",
        "images/p2x2.bmp",
        "images/p1x1.bmp"
    };

    _mipmapTextureId = loadMipMap(fileNames);

    using CELL::float3;
    _camera._eye   = float3(1, 1, 1);
    _camera._look  = float3(0.5f, -0.4f, -5.5f);
    _camera._up    = float3(0.0f, 1.0f, 0.0f);
    _camera._right = float3(1.0f, 0.0f, 0.0f);

    return _valid;
}

// 绘制mipmap
void MipMapTexture::render()
{
    using namespace CELL;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    auto director = Director::getInstance();
    Size s        = director->getFrameSize();
    float width   = s._width;
    float height  = s._height;

    glViewport(0, 0, width, height);

    _camera.updateCamera(0.016);

    float groundSize     = 100;
    float groundPosition = -5;
    float repeat         = 100;

    Vertex ground[] = 
    {
        { -groundSize, groundPosition, -groundSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, -groundSize,  repeat, 0.0f,   1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, groundSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },

        { -groundSize, groundPosition, -groundSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, groundSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },
        { -groundSize, groundPosition, groundSize,  0.0f, repeat,   1.0f, 1.0f, 1.0f, 1.0f },
    };

    begin();

    matrix4 matWorld(1);
    matrix4 matView = lookAt(_camera._eye, _camera._look, _camera._up);
    matrix4 matProj = perspective(45.0f, width / height, 0.1f, 100.f);
    matrix4 mvp     = matProj * matView * matWorld;

    // 给片段shader中的纹理数据传mipmap数据
    glUniform1i(_mipmapTexture, 0);
    glBindTexture(GL_TEXTURE_2D, _mipmapTextureId);

    glUniformMatrix4fv(_mvp, 1, false, mvp.data());
    
    // 顶点位置
    glVertexAttribPointer(_position, 3, GL_FLOAT, false, sizeof(Vertex), &ground[0].x);
    // 纹理坐标uv
    glVertexAttribPointer(_uv, 2, GL_FLOAT, false, sizeof(Vertex), &ground[0].u);
    // 绘制两个三角形 = 一个矩形 地板场景
    glDrawArrays(GL_TRIANGLES, 0, sizeof(ground) / sizeof (ground[0]));

    end();
}
```

**顶点shader**


```c++
precision lowp float;

attribute   vec3    _position;
uniform     mat4    _mvp;

attribute   vec2    _uv;
varying     vec2    _outUv;

void main() {
    vec4 pos    = vec4(_position.x, _position.y, _position.z, 1);
    gl_Position = _mvp * pos;
    _outUv      = _uv;
}
```

**片段shader**

```c++
precision lowp float;

varying     vec2        _outUv;
uniform     sampler2D   _textureBg;

void main() 
{
    vec4    bgColor    = texture2D(_textureBg, _outUv);
    gl_FragColor       = bgColor;
}
```

# 完整的源代码

**MipMapTexture.h**

```c++
#pragma  once

#include "gl_include.h"
#include "ELShaderProgram.h"
#include <string>
#include <vector>

NS_BEGIN(elloop);
NS_BEGIN(mip_map);

class ACamera
{
public:
    ACamera()
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


class MipMapTexture : public ShaderProgram
{
public:
    static MipMapTexture*       create();
    void                        begin()     override;
    void                        end()       override;
    void                        render()    override;

    uniform                     _mvp;
    uniform                     _mipmapTexture;
    attribute                   _position;
    attribute                   _uv;

    unsigned int                _mipmapTextureId;

    ACamera                     _camera;

protected:

    struct Vertex
    {
        float x, y, z;
        float u, v;
        float r, g, b, a;
    };

    bool                        init();
    MipMapTexture()
        : _mvp(-1)
        , _mipmapTexture(-1)
        , _mipmapTextureId(-1)
        , _position(-1)
        , _uv(-1)
    {
        _vsFileName = "shaders/3D_projection_vs.glsl";
        _fsFileName = "shaders/3D_projection_fs.glsl";
    }
    ~MipMapTexture()
    {
        glDeleteTextures(1, &_mipmapTextureId);
    }
    unsigned int loadTexture(const std::string &fileName);
    unsigned int loadMipMap(const std::vector<std::string> &fileNames);
};


NS_END(mip_map);
NS_END(elloop);
```

**MipMapTexture.cpp**

```c++
#include "scenes/MipMapTexture.h"
#include "app_control/ELDirector.h"
#include "math/ELGeometry.h"
#include "include/freeImage/FreeImage.h"

NS_BEGIN(elloop);
NS_BEGIN(mip_map);

void MipMapTexture::begin()
{
    glUseProgram(_programId);
    glEnableVertexAttribArray(_position);
    glEnableVertexAttribArray(_uv);
}

void MipMapTexture::end()
{
    glDisableVertexAttribArray(_uv);
    glDisableVertexAttribArray(_position);
    glUseProgram(0);
}

bool MipMapTexture::init()
{
    _valid = ShaderProgram::initWithFile(_vsFileName, _fsFileName);
    if ( _valid )
    {
        _position      = glGetAttribLocation(_programId, "_position");
        _uv            = glGetAttribLocation(_programId, "_uv");
        _mipmapTexture = glGetUniformLocation(_programId, "_textureBg");
        _mvp           = glGetUniformLocation(_programId, "_mvp");
    }

    std::vector<std::string> fileNames =
    {
        "images/p32x32.bmp",
        "images/p16x16.bmp",
        "images/p8x8.bmp",
        "images/p4x4.bmp",
        "images/p2x2.bmp",
        "images/p1x1.bmp"
    };

    _mipmapTextureId = loadMipMap(fileNames);

    using CELL::float3;
    _camera._eye   = float3(1, 1, 1);
    _camera._look  = float3(0.5f, -0.4f, -5.5f);
    _camera._up    = float3(0.0f, 1.0f, 0.0f);
    _camera._right = float3(1.0f, 0.0f, 0.0f);

    return _valid;
}

MipMapTexture* MipMapTexture::create()
{
    auto * self = new MipMapTexture();
    if ( self && self->init() )
    {
        self->autorelease();
        return self;
    }
    return nullptr;
}

unsigned int MipMapTexture::loadMipMap(const std::vector<std::string> &fileNames)
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
        FIBITMAP *bitmap         = FreeImage_Load(format, fileNames[i].c_str(), 0);
        bitmap                   = FreeImage_ConvertTo24Bits(bitmap);
        BYTE *pixels             = FreeImage_GetBits(bitmap);

        int width  = FreeImage_GetWidth(bitmap);
        int height = FreeImage_GetHeight(bitmap);

        for (size_t j = 0; j < width*height * 3; j += 3)
        {
            BYTE temp     = pixels[j];
            pixels[j]     = pixels[j + 2];
            pixels[j + 2] = temp;
        }

        glTexImage2D(GL_TEXTURE_2D, i, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);

        FreeImage_Unload(bitmap);
    }
   
    return textureId;
}

void MipMapTexture::render()
{
    using namespace CELL;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    auto director = Director::getInstance();
    Size s        = director->getFrameSize();
    float width   = s._width;
    float height  = s._height;

    glViewport(0, 0, width, height);

    _camera.updateCamera(0.016);

    float groundSize     = 100;
    float groundPosition = -5;
    float repeat         = 100;

    Vertex ground[] = 
    {
        { -groundSize, groundPosition, -groundSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, -groundSize,  repeat, 0.0f,   1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, groundSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },

        { -groundSize, groundPosition, -groundSize, 0.0f, 0.0f,     1.0f, 1.0f, 1.0f, 1.0f },
        { groundSize, groundPosition, groundSize,   repeat, repeat, 1.0f, 1.0f, 1.0f, 1.0f },
        { -groundSize, groundPosition, groundSize,  0.0f, repeat,   1.0f, 1.0f, 1.0f, 1.0f },
    };

    begin();

    matrix4 matWorld(1);
    matrix4 matView = lookAt(_camera._eye, _camera._look, _camera._up);
    matrix4 matProj = perspective(45.0f, width / height, 0.1f, 100.f);
    matrix4 mvp     = matProj * matView * matWorld;

    glUniform1i(_mipmapTexture, 0);
    glBindTexture(GL_TEXTURE_2D, _mipmapTextureId);

    glUniformMatrix4fv(_mvp, 1, false, mvp.data());
    
    glVertexAttribPointer(_position, 3, GL_FLOAT, false, sizeof(Vertex), &ground[0].x);
    glVertexAttribPointer(_uv, 2, GL_FLOAT, false, sizeof(Vertex), &ground[0].u);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(ground) / sizeof (ground[0]));

    end();
}


NS_END(mip_map);
NS_END(elloop);
```
# 完整项目源码

- [OpenGL-ES-2.0-cpp](https://github.com/elloop/OpenGL-ES-2.0-cpp)

如果源码对您有帮助，请帮忙在github上给我点个Star, 感谢 :)


# 推荐一个入门的[OpenGL ES 视频](http://edu.csdn.net/course/detail/958)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

