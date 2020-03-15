---
layout: post
title: "【OpenGL Programming On macOS using glfw 】0: Build a Simple OpenGL Program"
category: [OpenGL]
tags: [opengl]
description: ""
---

# 前言

OpenGL红宝书第九版已经开始使用[glfw](http://www.glfw.org/)作为窗口管理和Context创建工具, 取代了第八版里的`freeglut`和`glew`。

本文讲解如何使用glfw在macOS上来构建一个OpenGL程序（OpenGL 3.0+）

包括以下步骤：

- 从github下载glfw源码

- 使用CMake构建glfw，并运行示例，以确保glfw确实可用

- 编写自己的OpenGL代码，并链接glfw来展示结果

**本机环境：macOS Sierra (10.12) + glfw 3.2.1 + OpenGL 4.1**

# 下载源码

**官方代码仓库：**

- github: [glfw/glfw](https://github.com/glfw/glfw)

可以使用SourceTree来下载，下载完切换到latest分支，这是最新的stable分支。

**官方入门文档：**

- quick intro: [Getting started](http://www.glfw.org/docs/latest/quick.html)

- build guide: [build guide](http://www.glfw.org/docs/latest/build_guide.html)


# build glfw

**编译**

假设你已经熟悉CMake，这里我使用`out-of-tree`的构建方式，打开terminal，切换到glfw根目录，比如： `~/codes/glfw/`

{% highlight c++ %}
cd ~/codes/glfw
mkdir build && cd build            
cmake ..     # macOS上glfw的依赖项目除了完整的Xcode工具链就只需要一个CMake就ok了，所以这一步正常应该不会出问题的。
make         # 开始编译, 如果要安装到系统，执行make install， 我不需要安装，只是跑个demo
{% endhighlight %}

**运行示例**

make成功后，在build目录下输入命令（或者在finder中直接打开build/examples/simple.app)

{% highlight c++ %}
open ./examples/simple.app
{% endhighlight %}

可以看到如下的一个旋转的三角形：

![glfw-simple.png](http://7xi3zl.com1.z0.glb.clouddn.com/glfw-simple.png)

官方编译参考文档：[compile glfw](http://www.glfw.org/docs/latest/compile_guide.html#compile_compile)

# 开始写自己的OpenGL项目

正如构建其它的c++程序一样，构建自己的基于glfw的OpenGL项目，无非就两步：第一，包含正确的头文件；第二，链接正确的库文件。

<!--more-->

## 1. 包含正确的头文件

很简单，对于glfw来说，仅仅一个：

{% highlight c++ %}
#include <GLFW/glfw3.h>
{% endhighlight %}

需要注意的是，有一些宏可以控制`#include<GLFW/glfw3.h>`的具体行为，比如：

`GLFW_INCLUDE_GLCOREARB` 这个宏使得glfw去包含现代的`GL/glcorearb.h`(在macOS上是`OpenGL/gl3.h`), 而不是包含普通的OpenGL头文件(如macOS上的`OpenGL/gl.h`).

类似的宏还有：`GLFW_INCLUDE_ES1`, `GLFW_INCLUDE_ES2`, `GLFW_INCLUDE_ES3`,`GLFW_INCLUDE_VULKAN`,`GLFW_INCLUDE_NONE`,`GLFW_INCLUDE_GLEXT`,`GLFW_INCLUDE_GLU`.

具体含义不多说了，详情参考[官方文档](http://www.glfw.org/docs/latest/build_guide.html), 注意要在包含头文件之前定义宏。

## 2. 链接正确的库

glfw官方教程提到了如下几个方式:

**1. With MinGW or Visual C++ on Windows**

<font color="red">2. With CMake and GLFW source</font>

**3. With CMake and installed GLFW binaries**

**4. With makefiles and pkg-config on Unix**

**5. With Xcode on OS X**

**6. With command-line on OS X**

在mac上有2, 3, 5, 6, 这几种方式，其中最简单当属Xcode了，最原始的方式则是直接command-line, 我习惯于CMake + source的方式。

Xcode的方式请参考这两篇文章，还算比较新，

一个是10.10 + Xcode 6 : [OS X 下 OpenGL 4.x 环境配置](http://www.cnblogs.com/tangyikejun/p/4508120.html)

一个是10.9.2 + Xcode 5 : [Xcode环境下OpenGL C++ GLFW开发环境搭建](http://www.cnblogs.com/be2n2me/p/3701338.html)

下面着重讲解CMake + glfw source 的方式构建

## CMake + glfw source 构建OpenGL项目

使用源码的好处是随时可查看、修改、调试源码，轻量，不需关心维护库文件, 不需要安装glfw到系统。

### 第一步，创建工程目录，编写CMakeLists.txt脚本

假设我在~/codes/下新建一个目录，叫RedBook

第一，因为要使用glfw的源码，所以要拷贝glfw源码到工程目录

第二，添加一个CMake脚本文件，CMakeLists.txt

第三，添加一个src目录，用来存放接下来要编写的OpenGL代码

创建好的目录如下所示：

{% highlight c++ %}
drwxr-xr-x  10 elloop  staff   340B Nov 19 00:10 .
drwxr-xr-x  29 elloop  staff   986B Nov 19 00:10 ..
-rw-r--r--   1 elloop  staff   2.7K Nov 19 00:10 CMakeLists.txt
drwxr-xr-x  17 elloop  staff   578B Nov 19 00:10 glfw
drwxr-xr-x   9 elloop  staff   306B Nov 19 00:10 src
{% endhighlight %}

第四，编写CMake脚本，语法比Makefile简单很多，照着github上别人的工程脚本就可逐渐写出来。一般写过一份之后，新项目拷一份过来改改就好了。


{% highlight c++ %}
cmake_minimum_required ( VERSION 3.0)       # 支持最低的CMake版本
project                ( red )              # 我的工程名叫red

set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )      # 生成 compile_commands.json供vim c++插件语义补全使用

# 下面几行设置c++编译选项
set(CXX_FLAGS -std=c++11 -g -Wall)
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${CXX_FLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG   "-O0" )
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -finline-limit=1000 -DNDEBUG " )

# 可选，设置可执行程序的输出目录，我习惯于放在build/bin. 库放在build/lib下
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/build/bin)
set(LIBRARY_OUTPUT_PATH    ${PROJECT_SOURCE_DIR}/build/lib)

# 下面三个开关用来控制glfw的构建，关闭 帮助文档、测试项目、示例项目的构建。因为我只是把glfw作为一个库来使用。
set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)  
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

# 添加glfw的CMake模块。 相当于 include(./glfw/CMakeLists.txt), glfw使用自己的构建脚本。
# 同时会把glfw的头文件包含目录添加到项目中。
add_subdirectory(${PROJECT_SOURCE_DIR}/glfw)

# 添加 ./src 到头文件搜索路径，以后自己编写的头文件如果放在src下的话，就能被编译器搜索到。
include_directories ( ${PROJECT_SOURCE_DIR}/src)

# 添加要编译的cpp源代码，先只要一个main.cpp
set(SRC_LIST ${PROJECT_SOURCE_DIR}/src/main.cpp)

# 添加项目的构建目标，一个可执行程序，叫：${PROJECT_NAME}, 也就是文件开头定义的 “red”
add_executable(${PROJECT_NAME} ${SRC_LIST})

# 让项目的可执行程序red链接glfw库
target_link_libraries(${PROJECT_NAME} glfw)

# 让CMake去系统搜索OpenGL库，找不到就报错(REQUIRED).  
# 找到了之后就会有两个变量可用：OPENGL_INCLUDE_DIR 和 OPENGL_gl_LIBRARY
find_package(OpenGL REQUIRED)

# 添加OpenGL头文件包含目录
target_include_directories(${PROJECT_NAME} PUBLIC ${OPENGL_INCLUDE_DIR})

# 让项目的可执行程序red链接系统OpenGL库
target_link_libraries(${PROJECT_NAME} ${OPENGL_gl_LIBRARY})
{% endhighlight %}

### 第二步，编写OpenGL代码，运行

现在来补全CMake脚本中提到的main.cpp文件，在src下，新建一个main.cpp:

代码的init()和display()方法跟第四版的红宝书第一个例子几乎没什么区别，不做介绍。

因为暂时不知道使用命令行打包macOS二进制程序怎么把文本等资源文件打进Bundle之中，因此shader源码直接写在cpp代码中了。

{% highlight c++ %}
#define GLFW_INCLUDE_GLCOREARB      // 会是glfw包含OpenGL/gl3.h
#include "GLFW/glfw3.h"

#include <iostream>
using std::cout;
using std::endl;
#define BUFFER_OFFSET(a) ((void*)(a))

static void errorCallback(int error, const char *des) {
    fprintf(stderr, "error: %s\n", des);
}

static void keyCallback(GLFWwindow *window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GLFW_TRUE);
    }
}

enum { Triangle, NumVao };

enum { VertexBuffer, NumBuffer };

enum { vPosition = 0, };

GLuint vaos[NumVao];
GLuint buffers[NumBuffer];
const GLuint kNumVertices = 6;

GLuint makeShader(GLuint sType, const GLchar *shaderStr) {
    GLuint shader = glCreateShader(sType);
    glShaderSource(shader, 1, &shaderStr, NULL);
    glCompileShader(shader);
    GLint compiled;
    glGetShaderiv( shader, GL_COMPILE_STATUS, &compiled );
    if ( !compiled ) {
        GLsizei len;
        glGetShaderiv( shader, GL_INFO_LOG_LENGTH, &len );

        GLchar* log = new GLchar[len];
        glGetShaderInfoLog( shader, len, &len, log );
        std::cerr << "shader compilation failed: " << log << std::endl;
        delete [] log;
        return 0;
    }
    return shader;
}

void init() {
    glGenVertexArrays(NumVao, vaos);
    glBindVertexArray(vaos[Triangle]);

    GLfloat  vertices[kNumVertices][2] = {  
        { -0.90, -0.90 },  // Triangle 1  
        {  0.85, -0.90 },  
        { -0.90,  0.85 },  
        {  0.90, -0.85 },  // Triangle 2  
        {  0.90,  0.90 },  
        { -0.85,  0.90 }  
    };  

    glGenBuffers(NumBuffer, buffers);
    glBindBuffer(GL_ARRAY_BUFFER, buffers[VertexBuffer]);
    glBufferData(GL_ARRAY_BUFFER, sizeof vertices, vertices, GL_STATIC_DRAW);

    const GLchar *vertShaderStr =                 \
        "#version 410 core                        \n "
        "layout( location = 0) in vec4 vPosition; \n "
        "                                         \n "
        "void main()                              \n "
        "{                                        \n "
        "    gl_Position = vPosition;             \n "
        "}                                        \n "
        ;
    GLuint vertShader = makeShader(GL_VERTEX_SHADER, vertShaderStr);

    const GLchar *fragShaderStr =              \
        "#version 410 core                     \n"
        "out vec4 fColor;                      \n"
        "void main()                           \n"
        "{                                     \n"
        "   fColor = vec4(0.5, 0.4, 0.8, 1.0); \n"
        " }                                    \n"
        ;
    GLuint fragShader = makeShader(GL_FRAGMENT_SHADER, fragShaderStr);

    GLuint program = glCreateProgram();
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);
    glLinkProgram(program);
    GLint linked;
    glGetProgramiv( program, GL_LINK_STATUS, &linked );
    if ( !linked ) {
        std::cout << "link error" << std::endl;
        GLsizei len;
        glGetProgramiv( program, GL_INFO_LOG_LENGTH, &len );

        GLchar* log = new GLchar[len+1];
        glGetProgramInfoLog( program, len, &len, log );
        std::cerr << "Shader linking failed: " << log << std::endl;
        delete [] log;
    }

    glUseProgram(program);

    glVertexAttribPointer(vPosition, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(vPosition);
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glBindVertexArray(vaos[Triangle]);
    glDrawArrays(GL_TRIANGLES, 0, kNumVertices);
    glFlush();
}

int main() {
    
    GLFWwindow *window;

    glfwSetErrorCallback(errorCallback);
    if (!glfwInit()) {
        exit(EXIT_FAILURE);
    }

    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // 使用core-profile这行代码很重要
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);  
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);

    window = glfwCreateWindow(640, 480, "red", NULL, NULL);
    if (!window) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }

    glfwSetKeyCallback(window, keyCallback);

    glfwMakeContextCurrent(window);

    cout << "OpenGL Vendor:"    << glGetString(GL_VENDOR)                   << endl;
    cout << "OpenGL Renderer: " << glGetString(GL_RENDERER)                 << endl;
    cout << "OpenGL Version: "  << glGetString(GL_VERSION)                  << endl;
    cout << "GLSL Version:"     << glGetString(GL_SHADING_LANGUAGE_VERSION) << endl;

    glfwSwapInterval(1);

    init();

    while (!glfwWindowShouldClose(window)) {
        display();
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}
{% endhighlight %}

编写完毕，回到RedBook根目录，开始编译构建，执行：

{% highlight c++ %}
mkdir build && cd build     # 创建构建目录
cmake ..                    # cmake
make                        # 开始构建
./bin/red                   # 执行
{% endhighlight %}

可以看到绘制出的三角形和控制台输出core profile下显卡驱动支持的OpenGL版本：

![redrun.png](http://7xi3zl.com1.z0.glb.clouddn.com/redrun.png)

### 遇到的问题

1. NSGL: The targeted version of OS X only supports forward-compatible contexts for OpenGL 3.2 and above, 并且控制台打印的OpenGL版本是2.1.

添加这行代码：`glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)`, 上面的源代码中已经是加完的了。

# todo

1. shader保存成文件的话，如何打包进可执行程序（bundle）, 在CMakeLists里如何编写？

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

