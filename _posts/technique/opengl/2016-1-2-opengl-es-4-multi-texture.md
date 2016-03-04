---
layout: post
title: "【C++ OpenGL ES 2.0编程笔记】4: 纹理贴图-图片叠加效果实现"
category: OpenGL
tags: [opengl]
description: ""
---

**作者是现在对相关知识理解还不是很深入，后续会不断完善。因此文中内容仅供参考，具体的知识点请以OpenGL的官方文档为准**

# 前言

本文介绍了如何使用OpenGL ES 2.0 API实现纹理图片的叠加显示效果。

#开发环境及相关库

- vs2013 / C++

- libEGL.lib   : windows上的OpenGL ES环境

- libGLESv2.lib : OpenGL ES 2.0 API

- d3dcompiler_47.dll : 使用DX来模拟OpenGL

- FreeImage.lib/dll : 加载纹理数据

- 代码架构： 仿cocos2d-x结构，启动点在ELAppdelegate.cpp.

# 效果图：

<!--more-->

![dog_texture.gif](http://7xi3zl.com1.z0.glb.clouddn.com/dog_texture.gif)

# 实现代码：

**MultiTexture.h**

{% highlight c++ %}
#pragma  once

#include "gl_include.h"
#include "ELShaderProgram.h"
#include <string>

NS_BEGIN(elloop);

class MultiTexture : public ShaderProgram
{
public:
    static MultiTexture*        create();
    void                        begin()     override;
    void                        end()       override;
    void                        render()    override;

    uniform                     mvp_;
    uniform                     textureBg_;
    uniform                     textureCloud_;
    uniform                     deltaUv_;
    attribute                   position_;
    attribute                   uv_;

    unsigned int                textureBgId_;
    unsigned int                textureCloudId_;
protected:
    struct Vertex
    {
        CELL::float2      pos;
        CELL::float2      uv;
    };
    bool                        init();
    MultiTexture()
        : mvp_(-1)
        , textureBg_(-1)
        , textureCloud_(-1)
        , textureBgId_(-1)
        , textureCloudId_(-1)
        , position_(-1)
        , uv_(-1)
        , deltaUv_(-1)
    {
        vsFileName_ = "shaders/multi_texture_vs.glsl";
        fsFileName_ = "shaders/multi_texture_fs.glsl";
    }
    ~MultiTexture()
    {}
    unsigned int loadTexture(const std::string &fileName);
};

NS_END(elloop);
{% endhighlight %}


**MultiTexture.cpp**

{% highlight c++ %}
#include "scenes/MultiTexture.h"
#include "app_control/ELDirector.h"
#include "math/ELGeometry.h"
#include "include/freeImage/FreeImage.h"

NS_BEGIN(elloop);

void MultiTexture::begin()
{
    glUseProgram(programId_);
    glEnableVertexAttribArray(position_);
    glEnableVertexAttribArray(uv_);
}

void MultiTexture::end()
{
    glDisableVertexAttribArray(uv_);
    glDisableVertexAttribArray(position_);
    glUseProgram(0);
}

bool MultiTexture::init()
{
    valid_ = ShaderProgram::initWithFile(vsFileName_, fsFileName_);
    if ( valid_ )
    {
        position_       = glGetAttribLocation(programId_, "position_");
        uv_             = glGetAttribLocation(programId_, "uv_");
        deltaUv_        = glGetUniformLocation(programId_, "deltaUv_");
        textureBg_      = glGetUniformLocation(programId_, "textureBg_");
        textureCloud_   = glGetUniformLocation(programId_, "textureCloud_");
        mvp_            = glGetUniformLocation(programId_, "mvp_");
    }

    textureBgId_    = loadTexture("images/dog.png");
    textureCloudId_ = loadTexture("images/fog.bmp");

    return valid_;
}

MultiTexture* MultiTexture::create()
{
    auto * self = new MultiTexture();
    if ( self && self->init() )
    {
        self->autorelease();
        return self;
    }
    return nullptr;
}

unsigned int MultiTexture::loadTexture(const std::string &fileName)
{
    unsigned int textureId = 0;

    // 图片格式：如FIF_PNG, FIF_BMP, FIF_JPEG ...
    FREE_IMAGE_FORMAT format = FreeImage_GetFileType(fileName.c_str(), 0);

    FIBITMAP *bitmap = FreeImage_Load(format, fileName.c_str(), 0);

    bitmap = FreeImage_ConvertTo24Bits(bitmap);

    BYTE *pixels = FreeImage_GetBits(bitmap);

    int width  = FreeImage_GetWidth(bitmap);
    int height = FreeImage_GetHeight(bitmap);

    for (size_t i=0; i<width*height*3; i+=3) 
    {
        BYTE temp = pixels[i];
        pixels[i] = pixels[i+2];
        pixels[i+2] = temp;
    }

    glGenTextures(1, &textureId);

    glBindTexture(GL_TEXTURE_2D, textureId);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,width,height,0,GL_RGB,GL_UNSIGNED_BYTE,pixels);
    FreeImage_Unload(bitmap);   
    return textureId;
}

void MultiTexture::render()
{
    using namespace CELL;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    auto director = Director::getInstance();
    Size s = director->getFrameSize();
    float width = s.width_;
    float height = s.height_;

    glViewport(0, 0, width, height);

    begin();

    matrix4 screenProj = ortho<float>(0, width, height, 0, -100.0f, 100);
    GLfloat x = 100;
    GLfloat y = 100;
    GLfloat w = 300;
    GLfloat h = 300;

    Vertex ary[] =
    {
        float2{ x, y },         float2(0, 1),
        float2{ x + w, y },     float2(1, 1),
        float2{ x, y + h },     float2(0, 0),
        float2{ x + w, y + h }, float2(1, 0),
    };

    // uv 动画，纹理坐标在x方向每次增加0.01, 详见片段shader multi_texture_fs.glsl 中对deltaUv_的使用
    static float incUv = 0;
    incUv += 0.01;

    // 绑定背景图：狗狗
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureBgId_);

    // 绑定前景：雾
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, textureCloudId_);

    glUniformMatrix4fv(mvp_, 1, false, screenProj.data());

    glUniform1i(textureBg_, 0);
    glUniform1i(textureCloud_, 1);

    glUniform1f(deltaUv_, incUv);
    
    glVertexAttribPointer(position_, 2, GL_FLOAT, false, sizeof(Vertex), ary);
    glVertexAttribPointer(uv_, 2, GL_FLOAT, false, sizeof(Vertex), &(ary[0].uv));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    end();
}

NS_END(elloop);
{% endhighlight %}

# shader

顶点着色器：`multi_texture_vs.glsl`

{% highlight c++ %}
precision lowp float;

attribute   vec2    position_;
uniform     mat4    mvp_;

attribute   vec2    uv_;
varying     vec2    outUv_;

void main() 
{
    vec4 pos    = vec4(position_, 0, 1);
    gl_Position = mvp_ * pos;
    outUv_      = uv_;
}
{% endhighlight %}

片段着色器：`multi_texture_fs.glsl`

{% highlight c++ %}
precision lowp float;

varying     vec2        outUv_;
uniform     sampler2D   textureBg_;
uniform     sampler2D   textureCloud_;
uniform     float       deltaUv_;

void main() 
{
    vec4    bgColor    = texture2D(textureBg_, outUv_);
    vec2    moveUv     = vec2(outUv_.x + deltaUv_, outUv_.y);
    vec4    cloudColor = texture2D(textureCloud_, moveUv);
    gl_FragColor    = bgColor + cloudColor;
    /* gl_FragColor       = mix(bgColor, cloudColor, 0.5); */
}
{% endhighlight %}


有空的时候再来补充注释及说明，想了解更多内容请参考源码部分。

# 遇到的问题

在绑定纹理的时候，误把`glBindTexture(GL_TEXTURE_2D, &textureId)`误写为`glBindTexture(GL_SAMPLER_2D, &textureId)`, 导致只能加载最后一次调用loadTexture()的纹理。今后不会<font color="red">混淆`GL_TEXTURE_2D`和`GL_SAMPLER_2D`了</font>。

# 完整项目源码

源码中包含

- [OpenGL-ES-2.0-cpp](https://github.com/elloop/OpenGL-ES-2.0-cpp)

如果源码对您有帮助，请帮忙在github上给我点个Star, 感谢 :)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

