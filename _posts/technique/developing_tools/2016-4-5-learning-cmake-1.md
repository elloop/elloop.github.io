---
layout: post
title: "【使用CMake组织C++工程】1：CMake Hello World"
category: tools
tags: [cmake]
description: ""
---

# 前言

本文介绍了如何使用CMake来构建一个Hello World的C++工程.

<!--more-->

# CMake使用惯例

使用过CMake构建项目的朋友都知道，CMake的使用有如下的“惯例”:

- 在项目根目录建立一个build目录：`mkdir build && cd build`.

- 执行:`cmake ../`

- 确定生成Makefile成功，执行`make`. (或者打开生成的工程文件，如Visual Studio项目文件或者是Xcode项目文件)

# 模仿

下面我要建立一个Hello World也是按照这个过程来使用CMake构建。

假设当前目录为：test

## 第一步：新建Hello.cpp

{% highlight c++ %}
#include <iostream>
int main() {
    std::cout << "hello cmake" << std::endl;
    return 0;
}
{% endhighlight %}

## 第二步：新建CMakeLists.txt

{% highlight c++ %}
add_executable(hello hello.cpp)
{% endhighlight %}

现在的目录结构如下：

--test/

----hello.cpp

----CMakeLists.txt

## 第三步：使用“惯例”方法来构建

### 1. 创建一个build目录

--test/

----hello.cpp

----CMakeLists.txt

----build/

### 2. 进入build目录，执行`cmake ../`

输出：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..

-- The C compiler identification is AppleClang 7.3.0.7030029
-- The CXX compiler identification is AppleClang 7.3.0.7030029
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Configuring done
-- Generating done
-- Build files have been written to: /Users/sunyongjian1/codes/local_codes/cmake_test/build
{% endhighlight %}

此时查看build目录下内容：

{% highlight c++ %}
total 56
drwxr-xr-x   6 lina  staff   204B  4  5 21:52 .
drwxr-xr-x   5 lina  staff   170B  4  5 21:52 ..
-rw-r--r--   1 lina  staff    12K  4  5 21:52 CMakeCache.txt
drwxr-xr-x  12 lina  staff   408B  4  5 21:52 CMakeFiles
-rw-r--r--   1 lina  staff   4.8K  4  5 21:52 Makefile
-rw-r--r--   1 lina  staff   1.3K  4  5 21:52 cmake_install.cmake
{% endhighlight %}

可以看到生成的Makefile, 

### 3. 执行`make`:

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build make
Scanning dependencies of target hello
[100%] Building CXX object CMakeFiles/hello.dir/hello.cpp.o
Linking CXX executable hello
[100%] Built target hello
{% endhighlight %}

再次查看build目录下内容，可以看到生成的hello文件，

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build l
total 88
drwxr-xr-x   7 lina  staff   238B  4  5 21:54 .
drwxr-xr-x   5 lina  staff   170B  4  5 21:52 ..
-rw-r--r--   1 lina  staff    12K  4  5 21:52 CMakeCache.txt
drwxr-xr-x  12 lina  staff   408B  4  5 21:54 CMakeFiles
-rw-r--r--   1 lina  staff   4.8K  4  5 21:52 Makefile
-rw-r--r--   1 lina  staff   1.3K  4  5 21:52 cmake_install.cmake
-rwxr-xr-x   1 lina  staff    15K  4  5 21:54 hello
{% endhighlight %}

### 4. 运行`./hello`:

可以看到输出：hello cmake.

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build ./hello
hello cmake
{% endhighlight %}

# 总结

以上就是使用CMake来构建一个Hello World C++项目的过程，可以看到相对于自己编写Makefile，使用CMake是简单很多的，仅需要一句：

`add_executable(hello, hello.cpp)`

就搞定了。

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

