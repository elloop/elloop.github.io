---
layout: post
title: "[永远不会精通C++之一]: 两种变长参数函数比较"
category: c++
tags: c++
description: ""
---

## 前言

本文要讨论的两种变长参数函数的形式分别为：

1.  c语言的方式
2.  c++11的变长模板参数

## c语言的方式

在C++中, 通过包含`<cstdarg>`就能够使用c语言中`<stdarg.h>`里面定义的几个宏来完成变长参数的处理，先看一个实例：

```c++
#include <cstdarg>

int vsum(int count, ...) {

    // 定义一个变长参数类型的指针变量：ap （Argument Pointer）
    va_list ap;

    // 初始化指针变量ap. 
    // 第二个参数count是用来确定ap的起始位置的，count是vsum的第一个参数，
    // 注意： 如果vsum在count参数后，还有一个命名的参数叫abc, 那么就要va_start(ap, abc)来初始化ap了
    // 后边的变长参数是根据count的地址来计算出来
    va_start(ap, count);

    int val(0);
    int sum(0);

    // 遍历变长参数内容，通过ap。
    for (int i=0; i<count; ++i) {
        // va_arg的第一个参数是va_list定义的变长参数指针ap，
        // 第二个参数指明了当前位置变长参数的类型。va_arg会自动改变ap的指针位置。
        // 下次再调用va_arg它就自动取下一个参数了，这里ap就像个迭代器
        val = va_arg(ap, int);
        sum += val;
    }

    // 清理工作
    va_end(ap);

    return sum;
}

//---------------------- begin of new test case ----------------------
RUN_GTEST(GrammarTest, VA_Args, @@);

EXPECT_EQ(0, vsum(0));
EXPECT_EQ(10, vsum(1, 10));
EXPECT_EQ(10, vsum(2, 5, 5));
EXPECT_EQ(10, vsum(3, 2, 3, 5));
EXPECT_EQ(10, vsum(4, 2, 3, 2, 3));
EXPECT_EQ(10, vsum(5, 2, 3, 2, 2, 1));
EXPECT_EQ(10, vsum(10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

END_TEST;

```

运行结果： 测试通过

```c++
[==========] Running 1 test from 1 test case.
[----------] Global test environment set-up.
[----------] 1 test from GrammarTest
[ RUN      ] GrammarTest.VA_Args
@@@@@@@@@@@@@@@@@@@@ GrammarTest ---> VA_Args @@@@@@@@@@@@@@@@@@@@
[       OK ] GrammarTest.VA_Args (4 ms)
[----------] 1 test from GrammarTest (4 ms total)

[----------] Global test environment tear-down
[==========] 1 test from 1 test case ran. (4 ms total)
[  PASSED  ] 1 test.
```

使用va_list这种处理方式很早以前就有了，而且资料也比较多，在此不再多说，下面给出一个表格总结下几个关键宏（va_list是一个类型，不是宏）的作用：

|**名称**|**参数**|**作用**|
|:-------|:-------|:-------|
|va_list||定义变长参数指针类型|
|va_start(ap, paramN)|ap: va_list类型的变量, 用来获取变长参数列表，基于paramN进行计算。</br> paramN: 函数参数列表里最后一个有名字的参数，比如vsum里的count。|初始化va_list类型的变量ap,使其获得到变长参数列表|
|va_end(ap)|ap: va_list类型的变量, 之前应该用va_start初始化过| 结束使用变长参数列表，应该在调用了va_start的函数返回之前调用va_end|
|va_arg(ap, type)|ap: va_list类型的变量, 保存了变长参数列表的当前状态 </br> type: ap中当前位置的变量类型 | 返回ap当前位置的参数类型为type，同时修改ap的状态，使它的当前状态指向下一个变长参数列表里的参数。|
|va_copy(dst, src)|dst : 未经初始化的va_list类型的变量; </br> src要被复制的va_list变量| 复制src，保持其当前状态到dst，之后对dst的变长参数处理操作将会与操作src一样。操作结束后，要使用va_end(dst)来做清理工作|

##c++11中的变长模板参数

c++11中引入了变长模板参数这一功能，包括类模板和函数模板都可以使用变长模板参数

下面就演示一下如何使用变长模板参数来定义一个模板函数来达到变长参数的函数效果


