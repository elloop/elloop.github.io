---
layout: post
title: "【使用CMake组织C++工程】3：CMake 函数和宏"
category: tools
tags: [cmake]
description: ""
published: true
---

# 前言

这篇文章分享一下CMake中函数:function, 和宏：macro的使用。本文先从二者区别说起，由于二者区别很小，所以后文就仅对函数的用法进行讨论，因为函数有作用域的概念，适用范围更广。后文分享一个很实用的递归函数用于包含指定目录的所有子目录。

# CMake中function和macro的区别

从其官方文档的描述并不会看出二者有什么大的区别，除了在function的定义中提到了Scope的概念。

下面以StackOverflow上的一个例子来直观的了解一下二者的区别:

{% highlight c++ %}
set(var "ABC")

macro(Moo arg)
  message("arg = ${arg}")
  set(arg "abc")
  message("# After change the value of arg.")
  message("arg = ${arg}")
endmacro()
message("=== Call macro ===")
Moo(${var})

function(Foo arg)
  message("arg = ${arg}")
  set(arg "abc")
  message("# After change the value of arg.")
  message("arg = ${arg}")
endfunction()
message("=== Call function ===")
Foo(${var})
{% endhighlight %}

输出结果是：

<!--more-->

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
=== Call macro ===
arg = ABC
# After change the value of arg.
arg = ABC
=== Call function ===
arg = ABC
# After change the value of arg.
arg = abc
{% endhighlight %}

可以看到，Moo这个宏的表现与C语言中的宏类似，仅仅是做字符串的替换; Foo函数里arg则是被赋值为var的值，在Foo内部可以修改这个arg变量的值。

个人感觉, 对于CMake里的函数和宏的使用原则可以以C语言里函数和宏的使用原则来作为参考。下面就着重说一下我在组织工程的时候对于function的常见用法。

# function 的使用技巧

## 如何按引用来传递参数？(在function中修改外部作用域的值)

**答：通过名字来传递变量**

例如：有一个var变量，在函数外部定义，要通过调用一个函数f1, 来修改var的值

{% highlight c++ %}
set(var "abc")                      # 定义一个变量var，初值为abc

function(f1 arg)
    set(${arg} "ABC" PARENT_SCOPE)  # ${arg} == var, 于是相当于set(var "ABC" PARENT_SCOPE)
endfunction()

message("before calling f1, var = ${var}")
f1(var)                                     # 如果写成了f1(${var})会怎样？
message("after calling f1, var = ${var}")
{% endhighlight %}

结果：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
before calling f1, var = abc
after calling f1, var = ABC
{% endhighlight %}

需要注意的两点：

- 函数调用处用变量的名字var，而不是它的值${var}
 
- 在函数内部，set的时候，要加上作用域PARENT_SCOPE.


试试写成`f1(${var})`:

{% highlight c++ %}
set(var "abc")                      # 定义一个变量var，初值为abc

function(f1 arg)
    set(${arg} "ABC" PARENT_SCOPE)  # ${arg} == var, 于是相当于set(var "ABC" PARENT_SCOPE)
endfunction()

message("before calling f1, abc = ${abc}")
f1(${var})                                     
message("after calling f1, abc = ${abc}")
{% endhighlight %}

输出是：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
before calling f1, abc = 
after calling f1, abc = ABC
{% endhighlight %}
如果写成了 `f1(${var})`, 那么先计算表达式`${var}`, 即相当于调用f1(abc), 调用结果是在函数的父作用域定义了一个abc变量.

其实在了解了参数展开之后，这个问题很显而易见，本质上就是调用了一个`set(<var-name> <var-value> <var-scope>)`, 只不过如果需要通过函数来包装他的话就要注意传参传过来的东西是个变量名还是变量的值。


## 如何传递列表类型的参数？

如果我要打印一个列表要怎么写？

{% highlight c++ %}
set(arg hello world)

foreach(v ${arg})
    message(${v})
endforeach()
{% endhighlight %}

输出：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
hello
world
{% endhighlight %}

在调试CMake脚本的时候，可能经常用到这种打印列表的代码，于是很自然的我需要写一个打印列表的函数：`print_list`

实现很简单，只要把上面那个foreach丢到一个函数体里面就好了

{% highlight c++ %}
function(print_list arg)
    foreach(v ${arg})
        message(${v})
    endforeach()
endfunction()
{% endhighlight %}

现在来调用一下这个函数：

{% highlight c++ %}
set(arg hello world) 

print_list(${arg})
{% endhighlight %}

输出结果：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
hello
{% endhighlight %}

<font color="red">应该是hello world才对，怎么会只有一个hello ? </font>

这几乎是初学者必犯的错误，问题出在对`print_list`的调用方式上：

`print_list(${arg})` 展开来看就是 `print_list(hello world)`, 因此，传递给`print_list`的第一个参数只有hello。

<font color="red">正确的调用方式应该是下面这样，使用双引号把参数括起来:</font>

{% highlight c++ %}
print_list("${arg}")
{% endhighlight %}

输出：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
hello
world
{% endhighlight %}

<font color="red">函数里几个有用的隐含参数：</font>

| *name*   | *description*                                                    |
| -------  | ---------------                                                  |
| ARGC     | 函数实参的个数                                                   |
| ARGV     | 所有实参列表                                                     |
| ARGN     | 所有额外实参列表, 即ARGV去掉函数声明时显示指定的实参，剩余的实参 |
| ARGV0    | 函数第1个实参                                                    |
| ARGV1    | 函数第2个实参                                                    |
| ARGV2    | 函数第3个实参                                                    |
| 依次类推 | 依次类推                                                         |


使用上面表格里的几个隐含参数，通过下面这个例子可以更好的说明上面两种传递参数的方式，函数内部发生了什么。

{% highlight c++ %}
function(print_list arg)
    message("======= args count : ${ARGC} ======= ")    # 实际实参个数

    message("======= all args ======= ")                # 打印所有参数
    foreach(v IN LISTS ARGV)
        message(${v})
    endforeach()


    message("======= all extra args ======= ")          # 打印所有额外参数
    foreach(v IN LISTS ARGN)
        message(${v})
    endforeach()

    message("======= print content of ARGV0 ======= ")  # 打印第一个参数里的所有内容
    foreach(v IN LISTS ARGV0)
        message(${v})
    endforeach()
endfunction()

set(arg hello world) 

message("------------ calling with qutoes -----------")     # 使用引号来调用
print_list("${arg}")

message("------------ calling without qutoes -----------")  # 不使用引号调用
print_list(${arg})
{% endhighlight %}

输出：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
------------ calling with qutoes -----------
======= args count : 1 ======= 
======= all args ======= 
hello
world
======= all extra args ======= 
======= print content of ARGV0 ======= 
hello
world
------------ calling without qutoes -----------
======= args count : 2 ======= 
======= all args ======= 
hello
world
======= all extra args ======= 
world
======= print content of ARGV0 ======= 
hello
{% endhighlight %}

从两个输出结果里可以看到：

**1.使用引号包裹参数时**

参数个数：1, 即hello world
额外参数个数: 0
打印第一个参数的内容 = 要打印的列表内容

**2.不使用引号包裹参数时**

参数个数：2, 分别是 hello 和 world
额外参数个数: 1, world
打印第一个参数的内容 = hello

在不使用括号包裹的情况下，因为函数只需要一个参数，列表里除了第一个元素的其它元素被当做额外的参数传给函数了，当我打印第一个参数的时候，就仅仅把列表的第一个元素打印出来了。

通过这个例子可以看到，在不使用括号来包裹列表类型的参数作为函数实参时，列表参数内部的空格（或者分号）会使得这个列表的内容被当做多个参数传递给函数。


# CMake里的函数支持递归调用吗？

经过我的测试，答案是肯定的。

CMake里面有个命令就带有递归的含义：

`file(GLOB_RECURSE cpp_list ./*.cpp)`

这个file命令，使用`GLOB_RECURSE`参数的时候即表示递归搜索的意思，上面这句话的意思是递归搜索当前目录及其子目录下的所有.cpp文件，把其完整路径放入列表`cpp_list`中。

通常情况下，确定了所有源文件的路径，对于一个工程的构建来说就已经完成了一大半，剩下的问题就是库和头文件的搜索路径。而库的搜索路径通常很简单，因为通常不需要链接很多的库，并且库可以统一存放。最后的问题就是头文件的搜索路径问题，在一个组织良好的项目里，公用的头文件通常放在一个公共的include路径，业务逻辑里的头文件通常和其源文件放在相同的路径下，此时在其源文件中使用`#include`时候，即使没有写完整的包含路径，仅仅写`#include "header.h"`也能够编译通过。然而在某些情况下，例如如在的目录树结构：

{% highlight c++ %}
src
├── a
│   └── a.cpp
├── b
│   └── bb
│       ├── a.h
│       ├── bb.cpp
│       └── bb.h
├── c
│   └── cc
│       └── ccc
│           ├── ccc.cpp
│           └── ccc.h
├── d
│   └── dd
│       └── ddd
│           └── dddd
│               ├── d.cpp
│               └── d.h
└── main.cpp

10 directories, 9 files
{% endhighlight %}

某程序员放错了a.h的位置，并且他的编码习惯也很差，在a.cpp里的头部，他这样编写了include:

{% highlight c++ %}
#include "a.h"
#include "bb.h"
#include "ccc.h"
#include "dddd.h"
// ...
{% endhighlight %}

此时，在构建项目的时候就必须把 src/b/bb, src/c/cc/ccc, src/d/dd/ddd/dddd 都放入头文件包含路径，否则a.cpp的编译肯定会报错找不到这几个头文件。

也许你觉得添加这几个路径挺容易的，但是考虑一下更惨的情况，数百个cpp文件，每个cpp不知道包含了哪个.h, 不知道被包含的.h分散在某个子目录下，我如果挨个找头文件，挨个添加包含目录会不会很惨？

所以，我需要一个函数，递归的搜索指定目录的子目录，把所有的子目录添加到include路径里。简单粗暴！

**下面就是我要分享的函数：** 

{% highlight c++ %}
function(include_sub_directories_recursively root_dir)
    if (IS_DIRECTORY ${root_dir})               # 当前路径是一个目录吗，是的话就加入到包含目录
        message("include dir: " ${root_dir})
        include_directories(${root_dir})
    endif()

    file(GLOB ALL_SUB RELATIVE ${root_dir} ${root_dir}/*) # 获得当前目录下的所有文件，让如ALL_SUB列表中
    foreach(sub ${ALL_SUB})
        if (IS_DIRECTORY ${root_dir}/${sub})                    
            include_sub_directories_recursively(${root_dir}/${sub}) # 对子目录递归调用，包含
        endif()
    endforeach()
endfunction()
{% endhighlight %}

对于刚才的目录结构，

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test l
total 8
drwxr-xr-x  5 lina  staff   170B  4 18 18:21 .
drwxr-xr-x  8 lina  staff   272B  4  7 23:38 ..
-rw-r--r--  1 lina  staff   1.4K  4 18 18:21 CMakeLists.txt
drwxr-xr-x  6 lina  staff   204B  4 18 18:21 build
drwxr-xr-x  7 lina  staff   238B  4 18 17:48 src
{% endhighlight %}

使用我这个函数来解决包含问题：`include_sub_directories_recursively(${CMAKE_CURRENT_LIST_DIR}/src)`

这句话，会把当前CMakeLists.txt所在目录下src的所有子目录(包括src目录)加入到包含路径。

输出结果是：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/a
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/b
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/b/bb
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/c
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/c/cc
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/c/cc/ccc
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/d
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/d/dd
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/d/dd/ddd
include dir: /Users/sunyongjian1/codes/local_codes/cmake_test/src/d/dd/ddd/dddd
-- Configuring done
-- Generating done
-- Build files have been written to: /Users/sunyongjian1/codes/local_codes/cmake_test/build
{% endhighlight %}

可以看到所有的子目录都被加入到包含路径了。

**为什么自己写，而不用file(GLOB_RECURSE ... ) ?**

因为file命令搜到的是带文件名的完整路径，我需要的是目录。

对于这个函数在实际组织项目中的应用，请参考我[这个项目的CMake脚本](https://github.com/elloop/CS.cpp)，在下一篇CMake文章里，我将分享一下这个项目使用CMake来组织的过程。


# 参考链接

- [cmake-language](https://cmake.org/cmake/help/v3.0/manual/cmake-language.7.html)

- [CMake Documentation(V3.0为例)](https://cmake.org/cmake/help/v3.0/)

- [CMake 变量](https://cmake.org/cmake/help/v3.0/manual/cmake-commands.7.html)

- [function的定义](https://cmake.org/cmake/help/v3.0/command/function.html#command:function)

- [macro的定义](https://cmake.org/cmake/help/v3.0/command/macro.html#command:macro)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

