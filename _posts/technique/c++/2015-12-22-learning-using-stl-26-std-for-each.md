---
layout: post
title: "【C++ STL学习与应用总结】26: 如何使用std::for_each以及基于范围的for循环 (since C++11)"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文总结了STL算法中for_each, for_each算法很常用，以致于C++11定义了一个新的语法: `range based for loop`, 也就是基于范围的for循环，直接在语法层面把for_each的功能给实现了。下面就举一些使用for_each和range based for loop的使用例子。

# for_each的原型

```c++
template<class InputIterator, class Function>
  Function for_each(InputIterator first, InputIterator last, Function fn)
{
  while (first!=last) {
    fn (*first);
    ++first;
  }
  return fn;      // or, since C++11: return move(fn);
}
```

# 不修改元素的用法 (non-modifying)

```c++
void printFun(int i)
{
    cout << i << " ";
}
//----------------------- for_each non-modify----------------------
RUN_GTEST(ForEachTest, NonModify, @);

auto print = [](int i){ cout << i << " "; };

vector<int> v{1,2,3,4,5};
for_each(v.begin(), v.end(), print);
cr;

for_each(v.begin(), v.end(), printFun);
cr;

END_TEST;
```

上面的例子输出都是`1 2 3 4 5`, for_each接受一个范围迭代器对，外加一个一元函数，跟其他的算法一样，这个函数选择很灵活，包括functors概念里的所有东西。

# 修改元素的用法 (modifying)

```c++
template <typename T>
class AddVal
{
public:
    AddVal(const T& val) : val_(val)
    {}

    void operator() (T & val)
    {
        val += val_;
    }

private:
    T val_;
};

void add50(int &val)
{
    val += 50;
}
//----------------------- for_each modify----------------------
RUN_GTEST(ForEachTest, Modify, @);

vector<int> coll;
insertElements(coll, 1, 5);
printContainer(coll, "coll: ");  // coll: 1 2 3 4 5 

// change use lambda.
for_each(coll.begin(), coll.end(),
         [](int& elem){ elem += 50; });

printContainer(coll, "coll: ");  //coll: 51 52 53 54 55 


// change use functor
for_each(coll.begin(), coll.end(),
         AddVal<int>(50));

printContainer(coll, "coll: ");//coll: 101 102 103 104 105 

// change use function.
for_each(coll.begin(), coll.end(), add50);
printContainer(coll, "coll: ");//coll: 151 152 153 154 155 

END_TEST;
```

这个例子展示了如何使用for_each来修改元素，分别使用了lambda、functor和普通函数，三者原理相同，都是通过接受一个引用类型的参数, 在函数内部修改了这个实参，从而达到修改容器元素的效果。

# `range based for loop` 用法

for_each完成的工作都可以用基于范围的for来做，比如上面的例子，使用for来实现：

```c++
RUN_GTEST(ForEachTest, RangeForLoop, @);

//-----------non-modifying --------------
auto print = [](int i)
{
    cout << i << " ";
};

vector<int> v{ 1, 2, 3, 4, 5 };
//for_each(v.begin(), v.end(), print);
for (auto item : v)
{
    print(item);
}
cr;

//for_each(v.begin(), v.end(), printFun);
for (auto item : v)
{
    printFun(item);
}
cr;

//----------- modifying --------------
vector<int> coll;
insertElements(coll, 1, 5);
printContainer(coll, "coll: ");  // coll: 1 2 3 4 5 

for (auto & item : coll) {
    item += 50;
}
printContainer(coll, "coll: ");  //coll: 51 52 53 54 55 

END_TEST;
```

上面的例子展示了使用基于范围的for实现for_each的modifying和non-modifying代码功能，可以看出，for循环并结合auto关键字，使得同样的功能实现起来更加直观、简单。for_each会慢慢被for替代，从而走出我们的视野。

# for_each的返回值

for_each有个返回值功能，通常不会被注意，也不是很常用。这一点是基于范围的for循环所不能取代的。

看原型的代码：


```c++
template<class InputIterator, class Function>
  Function for_each(InputIterator first, InputIterator last, Function fn)
{
  while (first!=last) {
    fn (*first);
    ++first;
  }
  return fn;      // or, since C++11: return move(fn);
}
```

它的返回值就是：std::move(fn). 什么意思，就是返回for_each(begin, end, fn)中的第三个参数fn的move结果，也就是说，如果fn有移动构造函数，那么返回值就是fn的移动构造结果，否则返回值就是fn的副本（copy构造结果）。

下面看一个使用for_each返回值的例子， 它用来计算一串数字的平均值：

```c++
class MeanValue
{
public:
    MeanValue() : count_(0), sum_(0) {}
    void operator() (int val)
    {
        sum_ += val;
        ++count_;
    }
    operator double()
    {
        if ( count_ <= 0 )
        {
            return 0;
        }
        return sum_ / count_;
    }
private:
    double      sum_;
    int         count_;
};
//----------------------- for_each return value----------------------
BEGIN_TEST(ForEachTest, UseReturnValue, @);

vector<int> coll2{ 1, 2, 3, 4, 5 };
printContainer(coll2, "coll2:");   // coll2: 1 2 3 4 5

//for_each returns a copy of MeanValue(), then use operator double().
// same with:
// MeanValue mv = for_each(coll2.begin(), coll2.end(), MeanValue());
// double meanValue = mv;
double meanValue = for_each(coll2.begin(), coll2.end(),
                            MeanValue());

// validate result using numeric.
using std::accumulate;
double sum(0);
sum = accumulate(coll2.begin(), coll2.end(), sum);
EXPECT_EQ(sum / coll2.size(), meanValue);

END_TEST;
```

# 基于范围的for循环使用注意事项

**1. for循环里取出的item是对迭代器解引用后的结果**

```c++
vector<int> vi{1, 2, 3};
auto iter = vi.begin();
for( auto elem : vi)
{
    // elem 的类型相当于： *iter 后的类型.
}
```


# 源码及参考链接

- [源码：accumulate_test.cpp](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/algorithm/numeric/accumulate_test.cpp)

- [accumulate](http://www.cplusplus.com/reference/numeric/accumulate/)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



