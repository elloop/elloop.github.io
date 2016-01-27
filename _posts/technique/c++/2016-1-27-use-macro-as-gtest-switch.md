---
layout: post
title: "使用宏来作为C++单元测试开关"
category: c++
tags: [tools]
description: ""
---

#前言

本文介绍了如何使用宏来控制C++单元测试的开启和关闭，本文的单元测试工具指的是google的C++测试框架gtest。

gtest目前最新的稳定release版本是1.7，关于gtest的介绍请移步[gtest的主页](https://github.com/google/googletest)，它的[编译安装](https://github.com/google/googletest/tree/master/googletest)和使用都很简单，你可以直接把gtest的源码copy到自己项目里来使用，也可以使用header+静态库的方式集成到项目中。入门的话建议从它源码仓库里[自带的测试用例](https://github.com/google/googletest/tree/master/googletest/samples)看起，模仿着这些sample写用例可以快速上手。本文不对具体使用方法做介绍。

# 当单元测试变多的时候遇到的麻烦

我对gtest使用比较多的特性是基本的`TEST`测试，典型的用法像下面的代码这样：

```c++
#include <iostream>
#include "gtest/gtest.h"

using namespace std;

TEST(TempTest, Test1)
{
    cout << "============== Test1 ================" << endl;

    int i = 4 * 5;
    EXPECT_EQ(20, i);           // 20 == i
    EXPECT_NE(21, i);           // 21 != i

    EXPECT_TRUE(20 == i);
    EXPECT_FALSE(21 == i);

    cout << i << endl;          // 输出这么多行是在模拟复杂测试的时候，测试用例的输出可能会很多。
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
}

<!--more-->

TEST(TempTest, Test2)
{
    cout << "============== Test2 ================" << endl;

    int i = 20 * 5;
    EXPECT_GT(101, i);      // 101 > i
    EXPECT_LT(99, i);       // 99 < i

    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
}

TEST(TempTest, Test3)
{
    cout << "============== Test3 ================" << endl;

    int i = 2 * 5;
    EXPECT_GT(1, i);        // 1 > i ?  will not pass.

    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
    cout << i << endl;
}

int main(int argc, char** argv) 
{
	testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
```

测试代码中，我定义了一个测试用例，包含三个子测试Test123，其中输出那么多行的i是为了模拟测试用例可能的复杂输出，上面的测试结果如下：

![basic_gtest.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/gtest_basic.jpg)

Test1, Test2通过，Test3中1 > i的条件失败，导致其未通过。

**遇到的麻烦**

从结果中可以看到，仅仅三个子测试就已经可能有这么多输出了，当我添加更多的文件，每个文件里有更多的测试用例的时候麻烦就出现了，我要从好几页的输出结果中，找到某个特定的测试用例的输出可是要看好一会呢。

# 解决问题

解决这个麻烦，我的需求是:

**每次运行程序时，只显示我要测试的用例，这样测试结果就一目了然了。**

**方案1：把其它测试删掉或注释掉？**

不行，不能删除用例，因为好些用例是很有价值的，包括正在学习的类库用法什么的要保留下来以后复习。注释掉太麻烦了，写的用例越来越多，一个个注释很麻烦，以后想再运行某个用例的时候还有再解注释，麻烦。

**方案2：修改gtest源码，给TEST加上附加参数来控制某个TEST要不要运行**

不行，这样搞代价太大而且有些有力过猛的感觉，以后gtest升级的话会受影响。

**方案3：弄一个全局开关，在每个TEST体内，根据开关状态判断，如果开关打开，那就直接返回，不输出。**

```c++
bool gSkipAllTest = true;

// 禁止输出的用例
TEST(A, a)
{
    if (gSkipAllTest)
        return;

    // ......
}

// 需要输出的用例
TEST(N, n)
{
    // ......
}
```

在需要输出的用例中，不加条件判断，在测试完毕之后再加上条件。这样只有每次新加的测试会有输出。当想打开所有测试的时候，把全局的开关打开就行了。看起来不错，但是运行起来的时候会发现，虽然那些用例没有输出但是gtest还是会打印出那些测试用例的测试报告，即使它是个没有任何测试条件和输出的用例。

因此，要想不让其它不需要运行的测试干扰我的视线，最根本的办法应该是在编译层面来做控制，因为只要TEST()一旦被编译，这个测试用例就会在最终的输出中出现。

控制编译过程？那就要靠宏了，虽然它的名声不咋地。

**<font color="red">最终方案：使用宏来控制编译过程，过滤掉不需要运行的TEST</font>**

## 思路：

**1. 使用`RUN_GTEST`和`BEGIN_TEST`来代替TEST来定义测试用例 (“通过简单地增加另外一个间接层就可以解决软件的任何问题”)**

**2. 使用`RUN_GTEST`定义的用例是在本次编译后，肯定会被执行的用例**

**3. 使用`BEGIN_TEST`定义的用例是可能被执行的用例，它取决于控制宏`SKIP_ALL_TEST`是否被定义，如果定义，那么`BEGIN_TEST`所定义的用例就被一个哑巴函数代替，即不执行；如果未定义`SKIP_ALL_TEST`，那么`BEGIN_TEST`等同于`RUN_GTEST`，就成为了一个将被执行的测试用例。**


下面是这几个宏的定义(END_TEST仅仅是个花括号结束。)

## 实现

```c++

// p(x) 是一个模板函数，这样写你应该懂吧：cout<T> << x;

#define RUN_GTEST(__CASE__, __SUB_CASE__, __TAG__) TEST(__CASE__, __SUB_CASE__) { \
    std::fill_n(std::ostream_iterator<std::string>(std::cout, ""), 10, #__TAG__); \
    p(" "); \
    p(#__CASE__); \
    p(" ---> "); \
    p(#__SUB_CASE__); \
    p(" "); \
    std::fill_n(std::ostream_iterator<std::string>(std::cout, ""), 10, #__TAG__); \
    cr;

#define SKIP_ALL_TEST           // 全局开关

#ifdef  SKIP_ALL_TEST
#define BEGIN_TEST(__CASE__, __SUB_CASE__, __TAG__) void __CASE__##__SUB_CASE__() { return;         // 编译为一个哑巴函数
#else
#define BEGIN_TEST(__CASE__, __SUB_CASE__, __TAG__) RUN_GTEST(__CASE__, __SUB_CASE__, __TAG__)      // 编译为一个测试用例
#endif

#define END_TEST }
```

## 用法

```c++
BEGIN_TEST(A, h1, @);
// ...
END_TEST;


RUN_GTEST(Hello, h2, $#);
// ...
END_TEST;
```

**输出**

```c++
[----------] 1 test from Hello
[ RUN      ] Hello.h2
$#$#$#$#$#$#$#$#$#$# Hello ---> h2 $#$#$#$#$#$#$#$#$#$#
[       OK ] Hello.h2 (2 ms)
[----------] 1 test from Hello (2 ms total)
```

可以看到，只有使用`RUN_GTEST`定义的h2被执行了。在用例的函数体里我不需要自己写log了。`RUN_GTEST`会把测试用例名字给我打印出来。

## 解释

这里面代码最多的是`RUN_GTEST`，它复杂在多了一个附加的参数`__TAG__`, TEST只需要两个参数，`RUN_GTEST`和`BEGIN_TEST`为什么需要三个？

第三个参数是log里面常用的标志，用来标识这个测试用例，有了这个`__TAG__`参数，我就可以灵活的标识一个测试用例，即使它混杂在若干用例的输出结果之中，通过这个`__TAG__``我也能一眼就看到它的输出。

如果不用TAG，那么每个用例开头，我都需要写一句输出语句：

```c++
TEST(A, a1)
{
    cout << "============= A ---> a1 ===================" << endl;
    // test body
}

TEST(A, a2)
{
    cout << "============= A ---> a2 ===================" << endl;
    // test body
}
```

使用`RUN_GTEST`和TAG就可以这样写：

```c++
RUN_GTEST(A, a1, =);

// test body

END_TEST;


RUN_GTEST(A, a2, @);

// test body

END_TEST;
```

第三个参数`__TAG__`是字符串"="和"@"，从`RUN_GTEST`的定义中可以看到，在刚一进入测试用例，`__TAG__`会被输出10次，然后是`__CASE__ ---> __SUB_CASE__`, 接着又是10次`__TAG__`字符串的输出。如下：

```c++
[----------] 2 tests from A
[ RUN      ] A.a1
========== A ---> a1 ==========
[       OK ] A.a1 (1 ms)
[ RUN      ] A.a2
@@@@@@@@@@ A ---> a2 @@@@@@@@@@
[       OK ] A.a2 (2 ms)
[----------] 2 tests from A (3 ms total)
```

如果不够明显，还可以使用更复杂的`__TAG__`:

```c++
RUN_GTEST(A, a, @@@$);

END_TEST;

// 输出：
[----------] 1 test from A
[ RUN      ] A.a
@@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$ A ---> a @@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$@@@$
[       OK ] A.a (3 ms)
[----------] 1 test from A
```

## 结论

使用`RUN_GTEST`和`BEGIN_TEST`这两个宏，就可以灵活控制哪个测试用例该被执行，哪个该“消失”。因为两个宏的参数是完全一样的，因此要想开启或关闭一个测试用例，使用`RUN_GTEST`替换掉`BEGIN_TEST`即可（关闭一个用例则执行相反的替换）。如果要打开所有用例，那直接定义`SKIP_ALL_TEST`这个宏就可以了，不必挨个替换。

# 参考

[gtest github主页 ](https://github.com/google/googletest)

[gtest samples](https://github.com/google/googletest/tree/master/googletest/samples)

[gtest 安装说明](https://github.com/google/googletest/tree/master/googletest)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



