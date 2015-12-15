---
layout: post
title: "【永远不会精通的C++】1: 两种变长参数函数比较"
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

<!--more-->

**例1**：使用变长参数函数求和 

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
|va_list|无|定义变长参数指针类型|
|va_start(ap, paramN)|ap: va_list类型的变量, 用来获取变长参数列表，基于paramN进行计算。</br> paramN: 函数参数列表里最后一个有名字的参数，比如vsum里的count。|初始化va_list类型的变量ap,使其获得到变长参数列表|
|va_end(ap)|ap: va_list类型的变量, 之前应该用va_start初始化过| 结束使用变长参数列表，应该在调用了va_start的函数返回之前调用va_end|
|va_arg(ap, type)|ap: va_list类型的变量, 保存了变长参数列表的当前状态 </br> type: ap中当前位置的变量类型 | 返回ap当前位置的参数类型为type，同时修改ap的状态，使它的当前状态指向下一个变长参数列表里的参数。|
|va_copy(dst, src)|dst : 未经初始化的va_list类型的变量; </br> src要被复制的va_list变量| 复制src，保持其当前状态到dst，之后对dst的变长参数处理操作将会与操作src一样。操作结束后，要使用va_end(dst)来做清理工作|

----------

c++11中引入了变长模板参数这一功能，包括类模板和函数模板都可以使用变长模板参数

下面就演示一下如何使用变长模板参数来实现例子1中的变长参数求和。

## 使用c++11的变长模板函数

**例2**：

```c++
template <typename T, typename ... Args>
T vsum(const T &t, const Args&... args) {
    T sum(0);
    sum += t;
    sum += vsum(args...);
    return sum;
}

template <typename T>
T vsum(const T &t) { return t; }

//---------------------- begin of new test case ----------------------
RUN_GTEST(GrammarTest, VA_Args, @@);

EXPECT_EQ(0, vsum(0));
EXPECT_EQ(10, vsum(5, 5));
EXPECT_EQ(10, vsum(3, 3, 3, 1));
EXPECT_EQ(10, vsum(2, 2, 2, 2, 2));
EXPECT_EQ(10, vsum(1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

END_TEST;

```

测试结果：通过

```c++
[----------] 1 test from GrammarTest
[ RUN      ] GrammarTest.VA_Args
@@@@@@@@@@@@@@@@@@@@ GrammarTest ---> VA_Args @@@@@@@@@@@@@@@@@@@@
[       OK ] GrammarTest.VA_Args (16 ms)
[----------] 1 test from GrammarTest (16 ms total)
```

代码分析:

```c++

// 定义一个函数模板，接受可变数量参数, 且每个参数的类型可以不一样
// 这里面是一个递归调用的形式来定义的，比如：
// vsum(1, 2, 3) 会返回 1 + vsum(2, 3)
// vsum(2, 3)    返回 2 + vsum(3)
// vsum(3)       返回 3
// 递归的出口就是第二个函数模板，它只接受一个参数，并返回参数本身, 递归到这一点就开始回溯，累加结果
template <typename T, typename ... Args>
T vsum(const T &t, const Args&... args) {
    T sum(0);
    sum += t;
    // 递归调用 vsum, 把参数args，拆分为(head, tail...), tail越来越短，最后变为一个参数的版本vsum(t).
    sum += vsum(args...);  
    return sum;
}

// 函数模板递归出口
template <typename T>
T vsum(const T &t) { return t; }

```

与va_list的实现方式比较：

1.  模板函数更加灵活，不需要指定参数个数count，且参数类型可以不同. va_list方案中必须都是同一种类型int才能统一处理.
2.  不必显示指定参数类型(va_list方案中需要va_arg(ap, type)来指定type), 函数模板的版本中不需要对类型进行判断，只要支持“+”操作的类型即可被当做参数传入vsum.
3.  灵活性大也意味着容易犯错, 对于函数模板的vsum：</br>
    请分析vsum(1, 2.5, 3)的返回值是多少？ 它和vsum(1.5, 2, 3)的结果一样吗，都是6.5？</br>
    vsum(1, 2.5, 3) 将返回6, 而vsum(1.5, 2, 3)将返回6.5. </br>
    这是因为vsum的返回值被定义为第一个参数的返回类型(int)，也就是说vsum(1, 2.5, 3)的6.5在返回时被转为6.

可以使用如下测试代码，来确定vsum(1, 2.5, 3) 和 vsum(1.5, 2, 3)的返回类型.

```c++
string t1 = typeid( decltype( vsum(1, 2.5, 3) ) ).name();
EXPECT_STREQ("int", t1.c_str());

string t2 = typeid( decltype( vsum(1.5, 2, 3) ) ).name();
EXPECT_STREQ("double", t2.c_str());
```

## 使用c++11的变长参数类模板来实现可变参数求和 vsum

**例3**：使用模板类

```c++
template <long ... Args> class vsum;

template <long d, long ... Args>
class vsum<d, Args...> {
public:
    static const long value = d + vsum<Args...>::value;
};

template <>
class vsum<> {
public:
    static const long value = 0;
};


//---------------------- begin of new test case ----------------------
RUN_GTEST(GrammarTest, VA_Args, @@);

long s = vsum<>::value;                         EXPECT_EQ(0, s);

s = vsum<5, 5>::value;                          EXPECT_EQ(10, s);

s = vsum<5, 2, 3>::value;                       EXPECT_EQ(10, s);

s = vsum<3, 3, 1, 3>::value;                    EXPECT_EQ(10, s);

s = vsum<1, 1, 1, 1, 1, 1, 1, 1, 1, 1>::value;  EXPECT_EQ(10, s);

END_TEST;

```

测试结果： 通过

```c++
[----------] 1 test from GrammarTest
[ RUN      ] GrammarTest.VA_Args
@@@@@@@@@@@@@@@@@@@@ GrammarTest ---> VA_Args @@@@@@@@@@@@@@@@@@@@
[       OK ] GrammarTest.VA_Args (0 ms)
[----------] 1 test from GrammarTest (0 ms total)
```

代码分析：
思路是通过模板元编程的方式，在编译期完成计算。类似经典的模板元编程求阶乘的方法。 模板参数类型使用了非类型模板(nontype template)参数:long。 变长模板的展开通常都是通过递归的方式。

```c++
// (1) 模板类前置声明，用于下面 (3) 处那个模板的特化.
template <long ... Args> class vsum;

// (2) 递归主体,  
// vsum<1, 2, 3>::value = 1 + vsum<2, 3>::value
// vsum<2, 3>::value    = 2 + vsum<3>::value
// vsum<3>::value       = 3 + vsum<>::value
// vsum<>               = 0 即递归出口在 (3) 模板类特化处。
template <long d, long ... Args>
class vsum<d, Args...> {
public:
    // 递归部分，类似例2中函数模板的递归展开
    static const long value = d + vsum<Args...>::value; 
};

// (3) 模板类特化
template <>
class vsum<> {
public:
    static const long value = 0;
};

```

## 总结，对比两种方式可以看出，

1.  c语言中，va_list的方式写法比较直接、易懂，但是不是c++解决问题的方式，不够通用，限制太多， 且用到了宏(Effective c++里不推荐宏)。
2.  变长模板参数和变长模板类能实现va_list的功能，且灵活性比较大，使用函数和类，解决方法更为通用。其中类模板的方式, 和的计算在编译期就已完成。


## 源代码

本文的测试代码使用了google的c++单元测试框架gtest，源码请到我的github仓库查看:

- [源代码-头文件](https://github.com/elloop/CS.cpp/blob/master/TrainingGround/grammar/va_args_test.h)

- [源代码-源文件](https://github.com/elloop/CS.cpp/blob/master/TrainingGround/grammar/va_args_test.cpp)

`git clone git@github.com:elloop/CS.cpp.git` 下来，使用vs2013打开CS.cpp.sln，设置TrainingGround为启动项目, 构建运行即可。

## 参考链接
- [va_list参考](http://www.cplusplus.com/reference/cstdarg/va_list/?kw=va_list)
- [va_list方式更细致的讲解](http://blog.csdn.net/jackystudio/article/details/17523523)
- [深入理解c++11](http://book.douban.com/subject/24738301/)
- [深入理解c++11代码总结](https://github.com/elloop/CS.cpp/tree/master/UnderstandingCpp11)




