---
layout: post
title: "【C++ STL学习与应用总结】89: 数值算法之1: 如何使用std::accumulate"
category: c++
tags: [stl]
description: ""
---

#前言

本文总结了STL算法中，数值类算法(numeric algorithm)里的第一个算法: std::accumulate的使用, 及注意事项

#基本用法

先看一个使用accumulate的简单例子：

```c++
vector<int> vi{1, 2, 3};

cout << accumulate(vi.begin(), vi.end(), 0);    // 6
```

这个例子中，accumulate接收了三个参数，一对迭代器用来标识开始和结束区间，第三个参数0，是accumulate操作的初始值. accumulate遍历[begin, end)这个区间，把每个值累加到0这个初始值上面，并最终返回累加结束的值(0 + 1 + 2 + 3) == 6.

# 通用用法 

第一个例子只是accumulate特例的情况，其实它不仅仅能完成累加操作，它更一般的含义, 我觉得可以这样理解：

<font color="red">给定一个区间和初值init以及一个可选的操作函数op，返回一个和init一样类型的结果，该结果是通过对给定区间内的每个元素逐个累积用op操作作用于init而得到的。</font>

op是一个二元操作函数，默认的op是 `+` 运算, 这就是第一个例子执行累加的原因.

下面是其原型：

```c++
// 1. 无op
template <class InputIterator, class T>
   T accumulate (InputIterator first, InputIterator last, T init);

// 2. 有op
template <class InputIterator, class T, class BinaryOperation>
   T accumulate (InputIterator first, InputIterator last, T init,
                 BinaryOperation binary_op);
```

其可能的实现是：

```c++
template <class InputIterator, class T>
   T accumulate (InputIterator first, InputIterator last, T init)
{
  while (first!=last) {
    init = init + *first;  // or: init=binary_op(init,*first) 对于第二个原型，有op的情况
    ++first;
  }
  return init;
}
```

因此可以说第一种原型和用法只是第二种的一个特例，accumulate更通用的用法是指定一个操作函数op.

可以这样来重写第一个例子，

```c++
vector<int> vi{ 1, 2, 3 };
// 显示指定op为二元操作符 ： plus<int>()
cout << accumulate(vi.begin(), vi.end(), 0, plus<int>());   // 6
```

虽然结果是一样的，但是第二个例子是一种更为通用的用法。

# accumulate的返回值. (**注意**)

从accumulate的原型中能看到，init是按值传递的，在调用完成后局部变量init的值并没有被修改

要想使得其值等于累积后的值，需要接收accumulate的返回值。

所以下面例子中的init在调用accumulate之后并不会被改变

```c++
vector<int> vi{ 1, 2, 3 };

int init(0);
accumulate(vi.begin(), vi.end(), init, plus<int>());
EXPECT_EQ(0, init);                 // test pass

init = accumulate(vi.begin(), vi.end(), init, plus<int>());
EXPECT_EQ(6, init);                 // test pass
```

init在第一个调用完之后仍然是0. 那能不能不接受返回值，让init被修改呢, 就想传引用那样？

这个问题放在后面来讨论，使用reference_wrapper来尝试对init就行包装.

# 更多示例

可以看出，迭代器区间没什么特别需要说的，初值的选择也还好，和其它非数值类型的算法一样，accumulate的灵活性用法关键就在于op操作函数的选取上，函数对象(functors)一类东西都可以往这里塞，下面由简单到复杂给出accumulate的一些实用用法。

**使用函数、函数对象、lambda、bind函数组合等**

```c++
int func(int i, int j) 
{
    return i + j;
}

struct Functor
{
    int operator () (int i, int j)
    {
        return i + j;
    }
};

RUN_GTEST(NumericAlgorithm, MoreExamples, @);

vector<int> vi{ 1, 2, 3 };
EXPECT_EQ(6, accumulate(vi.begin(), vi.end(), 0, func));        // 使用函数
EXPECT_EQ(6, accumulate(vi.begin(), vi.end(), 0, Functor()));   // 使用函数对象
EXPECT_EQ(6, accumulate(vi.begin(), vi.end(), 0, [](int i, int j) ->int {return i + j;})); // 使用lambda


// 使用函数组合: init + v[i] * 2
int res = accumulate(vi.begin(), vi.end(), 
                        0, 
                        bind(plus<int>(), _1, 
                            bind(multiplies<int>(), _2, 2)
                        )
                    );

EXPECT_EQ(12, res);

// or use lambda. 与函数组合等效的lambda
res = accumulate(vi.begin(), vi.end(), 0, [](int i, int j) ->int { return i + 2*j; });
EXPECT_EQ(12, res);


// 使用类成员变量
struct Account
{
    int money;
};
vector<Account> va  = {Account{1}, Account{100}, Account{}};
int total = accumulate(va.begin(), va.end(), 
                        0, 
                        bind(plus<int>(), _1,
                            bind(&Account::money, _2)
                        )
                      );

EXPECT_EQ(101, total);

END_TEST;
```

以上测试在作者的环境测试通过。

再往下举例就会发现这个过程变成了functor专场，变成了组合op操作，离accumulate越来越远，就此打住。

# 最后给出一个在map上使用accumulate的例子，我觉得挺有意思

在一个map里有各种动物--数量的映射，使用accumulate统计动物总数：

```c++
RUN_GTEST(NumericAlgorithm, AdvancedUse, @);

map<string, int> m;
m.insert({ "dog",   3 });
m.insert({ "cat",   2 });
m.insert({ "fox",   1 });
m.insert({ "crow",  2 });

int animals(0);

animals = accumulate(m.begin(), m.end(),
                        0,
                        bind(plus<int>(), _1,
                            bind(&map<string, int>::value_type::second, _2)
                        )
                    );

EXPECT_EQ(8, animals);                  // animail totoal count is 8

END_TEST;
```

其实这个例子和统计Account里钱数那个例子没有本质区别，只不过绑定的类成员变量second嵌套了两层。

# 对accumulate的init参数修改的尝试

```c++
RUN_GTEST(NumericAlgorithm, TryToChangeInit, @);

// try1. 试图使用ref来包装int型的init，结果编译错误，出错在于：accumulate中`init = op(init, *first)`
// 报错信息是说：reference_wrapper没有定义移动构造函数。为什么要移动构造？是不是ref不支持内置类型?
// 于是换用class类型。即下面的Addable
vector<int> vi{ 1, 2, 3 };
int init = 0;
//accumulate(vi.begin(), vi.end(), ref(init));  // compile error
//EXPECT_NE(0, init);                 


// try2.
class Addable
{
public:
    Addable(int i=0) :i_(i) {}
    Addable operator + (const Addable& other) const
    {
        Addable a;
        a.i_ = i_ + other.i_;
        return a;
    }

    int     i_{ 0 };
};
Addable inita;
EXPECT_EQ(0, inita.i_);

vector<Addable> aa = {Addable(1), Addable(2), Addable(3)};
// ref包装Addable的对象还是编译失败，同样是reference_wrapper没有定义移动构造函数。
//accumulate(aa.begin(), aa.end(), ref(inita), plus<Addable>());  // also error.
//EXPECT_NE(0, inita.i_);

END_TEST;
```

通过用两种类型的`reference_wrapper<int>和reference_wrapper<Addable>`尝试，都没能通过编译，需要进一步了解reference_wrapper，暂时我未成功实现在accumulate内部按引用的方式修改变量init.

# 源码及参考链接

- [源码：accumulate_test.cpp](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/algorithm/numeric/accumulate_test.cpp)

- [accumulate](http://www.cplusplus.com/reference/numeric/accumulate/)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



