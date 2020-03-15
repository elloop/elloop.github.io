---
layout: post
title: "【使用CMake组织C++工程】2：CMake 常用命令和变量"
category: tools
tags: [cmake]
description: ""
---

# 前言

前面的文章介绍了一个最简单的CMake工程，这篇文章将介绍一个稍微复杂一些的CMake工程，结合这个工程总结一下在组织一个C/C++工程时最为常用的一些CMake命令和变量。对于涉及到的命令和变量，介绍的原则是点到即止，先仅需掌握基本用法即可，让工程跑起来。

上一篇文章中那个最简单的CMake Hello World工程，在其CMake脚本文件CMakeLists.txt中，仅有一句话：

{% highlight c++ %}
add_executable(hello hello.cpp)
{% endhighlight %}

这里面的`add_executable`就是一个CMake命令，它的作用是添加一个可执行文件构建目标。

下面从一个C++应用程序的编译过程为脉络对涉及到的命令和变量进行说明。

<!--more-->

为了让下面的说明举例更加容易理解，先给出本文的示例工程目录结构：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test tree
.
├── CMakeLists.txt
├── include
│   └── util.h
├── lib
│   └── libutil.a
└── src
    └── main.cpp
{% endhighlight %}

三个文件夹: include, lib, src分别存放包含文件，库文件，源文件；一个CMakeLists.txt脚本。下面我的任务是编写这个脚本，使得工程包含util.h头文件，编译main.cpp, 链接libutil.a, 最终生成一个可执行文件hello.

# 给工程起个名字

加上这句：`project(hello)`

<font color="red">解释</font>

命令：`project(<PROJECT-NAME> [LANGUAGES] [<language-name>...])`

作用：定义工程名称, 设置几个变量的名字: `PROJECT_NAME, PROJECT_SOURCE_DIR, <PROJECT-NAME>_SOURCE_DIR, PROJECT_BINARY_DIR, <PROJECT-NAME>_BINARY_DIR`, 高级用法请见参考链接2：CMake命令

# 让CMake找到我的头文件

加上这句：`include_directories(./include)`

作用：把当前目录(CMakeLists.txt所在目录)下的include文件夹加入到包含路径

我习惯这样写：`include_directories(${CMAKE_CURRENT_LIST_DIR}/include)`

<font color="red">解释</font>

命令: `include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])`

作用：

- 把dir1, [dir2 ...]这（些）个路径添加到当前CMakeLists及其子CMakeLists的头文件包含路径中;

- AFTER 或者 BEFORE 指定了要添加的路径是添加到原有包含列表之前或之后

- 若指定 SYSTEM 参数，则把被包含的路径当做系统包含路径来处理

第二种写法里用到了`CMAKE_CURRENT_LIST_DIR`这个变量，它表示当前CMakeLists所在的路径.

# 让CMake找到我的源文件

加上： `aux_source_directory(./src ${hello_src})` 

作用: 把当前路径下src目录下的所有源文件路径放到变量`hello_src`中

<font color="red">解释</font>

命令：`aux_source_directory(<dir> <variable>)`

作用：查找dir路径下的所有源文件，保存到variable变量中.

上面的例子中，`hello_src`是一个自定义变量，在执行了`aux_source_directory(./src ${hello_src})`之后，我就可以像这样来添加一个可执行文件：`add_executable(hello ${hello_src})`, 意思是用`hello_src`里面的所有源文件来构建hello可执行程序, 不用手动列出src目录下的所有源文件了。

<font color="red">注意：</font>

- aux_source_directory 不会递归包含子目录，仅包含指定的dir目录

- CMake官方不推荐使用aux_source_directory及其类似命令(file(GLOB_RECURSE ...))来搜索源文件，原因是这样包含的话，如果我再在被搜索的路径下添加源文件，我不需要修改CMakeLists脚本，也就是说，源文件多了，而CMakeLists并不需要(没有)变化，也就使得构建系统不能察觉到新加的文件，除非手动重新运行cmake，否则新添加的文件就不会被编译到项目结果中。

- 类似`include_directories()`中`CMAKE_CURRENT_LIST_DIR`的用法，也可以写成：`aux_source_directory(${CMAKE_CURRENT_LIST_DIR}/src ${hello_src})`

# 让CMake找到我的库文件

加上：`link_directories(${CMAKE_CURRENT_LIST_DIR}/lib)`

<font color="red">解释</font>

命令：`link_directories(directory1 directory2 ...)`

作用：不必细说，与`include_directories()`类似，这个命令添加了库包含路径。

# 告诉CMake我的构建目标

加上：`add_executable(${PROJECT_NAME} ${hello_src})`

<font color="red">解释</font>

命令：`add_executable(<name> [WIN32] [MACOSX_BUNDLE] [EXCLUDE_FROM_ALL] source1 [source2 ...])`

作用：目前仅需知道，其作用是使用`${hello_src}`里面的源文件来生成一个可执行文件，起名叫`${PROJECT_NAME}`, 即hello. 在一开始定义的那个project(hello)中的hello。

# 告诉CMake我要链接哪个库文件

加上：`target_link_libraries(${PROJECT_NAME} util)`

<font color="red">解释</font>

命令：`target_link_libraries(<target> [item1 [item2 [...]]] [[debug|optimized|general] <item>] ...)`

作用：仅需知道，名字叫`${PROJECT_NAME}`这个target需要链接util这个库，会优先搜索libutil.a(windows上就是util.lib), 如果没有就搜索libutil.so(util.dll, util.dylib)'

上面的例子意思是，让hello去链接util这个库。

# 传递FLAGS给C++编译器

如果我的main.cpp里面用到了C++11，那么我需要告诉CMake在生成的Makefile里告诉编译器启用C++11。与此类似，我可能也要传递其他FLAGS给编译器，怎么办？

答案是：设置`CMAKE_CXX_FLAGS`变量

加上：

{% highlight c++ %}
set(CMAKE_CXX_COMPILER      "clang++" )         # 显示指定使用的C++编译器

set(CMAKE_CXX_FLAGS   "-std=c++11")             # c++11
set(CMAKE_CXX_FLAGS   "-g")                     # 调试信息
set(CMAKE_CXX_FLAGS   "-Wall")                  # 开启所有警告

set(CMAKE_CXX_FLAGS_DEBUG   "-O0" )             # 调试包不优化
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG " )   # release包优化
{% endhighlight %}

<font color="red">解释</font>

- `CMAKE_CXX_FLAGS` 是CMake传给C++编译器的编译选项，通过设置这个值就好比 `g++ -std=c++11 -g -Wall`

- `CMAKE_CXX_FLAGS_DEBUG` 是除了`CMAKE_CXX_FLAGS`外，在Debug配置下，额外的参数

- `CMAKE_CXX_FLAGS_RELEASE` 同理，是除了`CMAKE_CXX_FLAGS`外，在Release配置下，额外的参数

# 开始构建

通过以上步骤， 最后，在文件头部添加CMake版本检查，以我的电脑上的环境为例，我的CMake版本是3.0，那么我在脚本最开始加上:

`cmake_minimum_required ( VERSION 3.0)`

完整的CMakeLists.txt如下所示：

{% highlight c++ %}
cmake_minimum_required ( VERSION 3.0)

project(hello)

include_directories(${CMAKE_CURRENT_LIST_DIR}/include)

link_directories(${CMAKE_CURRENT_LIST_DIR}/lib)

aux_source_directory(${CMAKE_CURRENT_LIST_DIR}/src ${hello_src})

add_executable(${PROJECT_NAME} ${hello_src})

target_link_libraries(${PROJECT_NAME} util)

set(CMAKE_CXX_COMPILER      "clang++" )         # 显示指定使用的C++编译器

set(CMAKE_CXX_FLAGS   "-std=c++11")             # c++11
set(CMAKE_CXX_FLAGS   "-g")                     # 调试信息
set(CMAKE_CXX_FLAGS   "-Wall")                  # 开启所有警告

set(CMAKE_CXX_FLAGS_DEBUG   "-O0" )             # 调试包不优化
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG " )   # release包优化
{% endhighlight %}

在CMakeLists.txt所在目录，新建build目录，并切换进build进行构建即可. 具体构建方法参见上一篇CMake Hello World的构建。

注意：生成的可执行文件路径会在build/src目录下，如需修改生成位置，请参考CMake变量`EXECUTABLE_OUTPUT_PATH`。

# 总结

本文通过一个C++工程实例，介绍了构建过程中用到的一些CMake命令和变量.

后面的文章将会讲解如何构建更加复杂的C++工程，会用到CMake里的function和其他命令和变量。

# 参考链接

- [CMake Documentation(V3.0为例)](https://cmake.org/cmake/help/v3.0/)

- [CMake 变量](https://cmake.org/cmake/help/v3.0/manual/cmake-commands.7.html)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

