---
layout: post
title: "【C++ STL应用与实现】56: 使用std::unique删除重复元素"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的unique算法的使用，结合一个具体例子讲解如何使用它删除自定义类型结合里面的重复元素(不仅仅是连续的)。这篇文章最早写作于2012年6月在中关村软件园实习的时候，在2015年12月的时候，重新整理了格式，并搬运到了github博客.

# 原型

`<algorithm>`中的unique函数， 它能删除连续序列的副本(Remove consecutive duplicates in range).
原型如下:

{% highlight c++ %}
template <class ForwardIterator>
  ForwardIterator unique ( ForwardIterator first, ForwardIterator last );

template <class ForwardIterator, class BinaryPredicate>
  ForwardIterator unique ( ForwardIterator first, ForwardIterator last,
                           BinaryPredicate pred );
{% endhighlight %}

<!--more-->

“删除连续序列”这样的描述容易造成误解，知道下面几点有助于更好理解这个操作：

- 其实unique仅仅是按照一个规则来修改[first, last)之间的元素，并不会删除任何东西，它不会改变容器的size。这个规则就是连续一样的元素会被后面的元素覆盖。

- 它通过一个返回迭代器result，并保证在[first, result)之间的元素是不存在连续重复的元素。可以把[result, last)之间的元素移除掉，这才算删除了连续重复的元素。

- 默认判断两个元素相等是使用==操作符，第二个版本也可自己指定二元函数（函数，functors，lambda...).

看看与它等价的代码就知道了：

{% highlight c++ %}
template <class ForwardIterator>
  ForwardIterator unique (ForwardIterator first, ForwardIterator last)
{
  if (first==last) return last;

  ForwardIterator result = first;
  while (++first != last)
  {
    if (!(*result == *first))  // or: if (!pred(*result,*first)) for version (2)
      *(++result)=*first;
  }
  return ++result;
}
// 代码摘自 http://www.cplusplus.com/reference/algorithm/unique/
{% endhighlight %}

# 简单示例

模拟这个原型代码的执行过程：

如果原始序列是： 1,2,2,3,2,1,1

那么unique之后：1,2,3,2,1,1,1， 容器元素被修改了，但是个数没变，需要手动再把结尾的1,1删掉，这个位置由unique的返回值来确定, 下面的代码演示了这个过程：

{% highlight c++ %}
#include <iostream>
#include <iterator>     // ostream_iterator
#include <algorithm>    // unique，distance
#include <vector>

int main() {
    using namespace std;
    vector<int> vi{1,2,2,3,2,1,1};
    // 去重
    auto result = unique(vi.begin(), vi.end());
    // 删除
    vi.resize(distance(vi.begin(), result));
    copy(vi.begin(), vi.end(), ostream_iterator<int>(cout, ","));
    return 0;
}
{% endhighlight %}

输出：

{% highlight c++ %}
1,2,3,2,1,
{% endhighlight %}

# 实习中对unique运用

下面的例子是在完成实习任务中的应用，在做图片轮廓提取的时候，得到一些点的坐标，我在点与点之间画线，把轮廓描绘出来，在使用OpenCV提取轮廓点之后，有些数据点重复，它们并不是连续重复的，比如：

(1, 2), (3, 4), (1, 2), (3, 4), (3, 4), (1,2)
我要把所有重复的点删掉，不能仅仅删除连续重复的，如果用unique结果会是:
(1, 2), (3, 4), (1, 2), (3, 4), (1, 2)

不能把所有重复的删掉。所以不能直接使用unique，要先把点排序，这样重复的点都变成连续的了，接下来就可以用unique一次搞定了。这几步都能用stl轻松实现，下面是示例代码：

{% highlight c++ %}
#include <iostream>
#include <iterator>     // ostream_iterator
#include <algorithm>    // sort, copy, unique
#include <vector>

class Point {
public:
    Point(int x, int y) {
        x_ = x;
        y_ = y;
    }

    // 用于copy()库函数.
    Point(const Point& other) {
        x_ = other.x_;
        y_ = other.y_;
    }

    // 用于sort库函数.
    bool operator<(const Point & other) {
        return ((x_ < other.x_) && (y_ < other.y_));
    }

    // 用于erase库函数.
    bool operator==(const Point & other) const {
        return ((x_ == other.x_) && (y_ == other.y_));
    }

    int x() const { return x_; }
    int y() const { return y_; }
private:
    int x_, y_;
};

// 重载<<操作符，为了使用ostream_iterator<Point>
std::ostream& operator<<(std::ostream& os, const Point & p) {
    os << "(" << p.x() << ", " << p.y() << ")";
    return os;
}

int main() {

    using namespace std;

    // c++11风格容器初始化，使用初始化列表(initializer_list)
    vector<Point> vp { Point(1, 2), Point(3, 4), Point(1, 2), Point(3, 4), Point(3, 4), Point(1, 2) };

    // 打印容器内的Point到标准输出流cout. 以逗号分隔.
    cout << "origin..." << endl;
    copy(vp.begin(), vp.end(), ostream_iterator<Point>(cout, ","));
    putchar(10);
    putchar(10);

    // 容器排序. 为了后面的unique操作，因为unique是删除连续相同元素的副本.
    sort(vp.begin(), vp.end());
    cout << "after sorting..." << endl;

    // 打印排序后的容器内容.
    copy(vp.begin(), vp.end(), ostream_iterator<Point>(cout, ","));
    putchar(10);
    putchar(10);

    // 删除重复元素.
    auto it = unique(vp.begin(), vp.end()); // it 类型为 vector<Point>::iterator
    vp.erase(it, vp.end());

    // 打印处理后的内容.
    cout << "after unique..." << endl;
    copy(vp.begin(), vp.end(), ostream_iterator<Point>(cout, ","));
    putchar(10);

    return 0;
}
{% endhighlight %}

运行结果：

{% highlight c++ %}
origin...
(1, 2),(3, 4),(1, 2),(3, 4),(3, 4),(1, 2),

after sorting...
(1, 2),(1, 2),(1, 2),(3, 4),(3, 4),(3, 4),

after unique...
(1, 2),(3, 4),
{% endhighlight %}

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



