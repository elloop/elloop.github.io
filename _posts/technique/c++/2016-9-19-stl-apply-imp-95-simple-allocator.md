---
layout: post
title: "【C++ STL应用与实现】95: 如何使用Allocator"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

# 前言

本文展示了如何使用Allocator，例子取自《STL源码剖析》里实现的一个简单的Allocator，从中可以看到Allocator最基本的用法。


<!--more-->

STL标准要求[^stl-standard]，一个allocator必须有下面这几种类型和成员：

{% highlight c++ %}
type:
     value_type
     pointer
     const_pointer
     reference
     const_reference
     size_type
     difference_type
memeber:
     rebind
     allocator()
     allocator(const allocator&)
     ~allocator()
     address(reference x)           // return pointer
     address(const_reference x)     // return const_pointer
     allocate(size_type n, const void* = 0)
     deallocate(pointer p, size_type n)
     max_size()
     construct(pointer p, const T& x)
     destroy(pointer p)
{% endhighlight %}

下面的`allocator<T>`实现了这最基本的要求:


{% highlight c++ %}
#include "inc.h"

#include <new>              // placement new
#include <cstddef>          // ptrdiff_t, size_t
#include <cstdlib>          // exit
#include <climits>          // UINTMAX_MAX

#include <vector>

using namespace std;

NS_BEGIN(elloop);           // namespace elloop {


//
// a simple allocator should at least:
// type:
//      value_type
//      pointer
//      const_pointer
//      reference
//      const_reference
//      size_type
//      difference_type
// memeber:
//      rebind
//      allocator()
//      allocator(const allocator&)
//      ~allocator()
//      address(reference x): return pointer
//      address(const_reference x): return const_pointer
//      allocate()
//      deallocate()
//      max_size()
//      construct()
//      destroy()

template <typename T>
inline T* _allocate(ptrdiff_t size, T*) {
    set_new_handler(0);
    T* tmp = (T*)(::operator new((size_t)(size * sizeof(T))));
    if (!tmp) {
        cerr << "out of memory" << endl;
        exit(1);
    }
    return tmp;
}

template <typename T>
inline void _deallocate(T* buffer) {
    ::operator delete(buffer);
}

template <typename T1, typename T2>
inline void _construct(T1* p, const T2& value) {
    new(p) T1(value);           // placement new 参考: cpp primer.
}

template <typename T>
inline void _destroy(T* ptr) {
    ptr->~T();
}

template <typename T>
class allocator {
public:
    typedef T           value_type;
    typedef T*          pointer;
    typedef const T*    const_pointer;
    typedef T&          reference;
    typedef const T&    const_reference;
    typedef size_t      size_type;
    typedef ptrdiff_t   difference_type;

    template <typename U>
    struct rebind {
        typedef allocator<U> other;
    };

    pointer allocate(size_type n, const void* hint=0) {
        pv("allocate %d for type %s\n", n, typeid(T).name());
        return _allocate((difference_type)n, (pointer)0);
    }

    void deallocate(pointer p, size_type n) {
        pv("deallocate %d for type %s\n", n, typeid(*p).name());
        _deallocate(p);
    }

    void destroy(pointer p) {
        _destroy(p);
    }

    pointer address(reference x) {
        return (pointer)&x;
    }

    const_pointer address(const_reference x) {
        return (const_pointer)&x;
    }

    size_type max_size() const {
        return size_type(UINTMAX_MAX / sizeof(T));
    }
};


RUN_GTEST(AllocatorTest, SimpleAllocator, @@);          // TEST(); google gtest.

vector<int, elloop::allocator<int>> iv{1, 2, 3, 4, 5, 6};
printContainer(iv, "iv = ");  // iv = 1, 2, 3, 4, 5, 6

END_TEST;


NS_END(elloop);
{% endhighlight %}

输出：

{% highlight c++ %}
allocate 6 for type i
iv = 1 2 3 4 5 6
deallocate 6 for type i
{% endhighlight %}

可以看到，vector分配空间的时候调用了我自定义的`allocator<int>`, 打印出了分配的元素类型和个数，个数是6， 类型是：`i`, 我是使用clang++编译的代码，这里i是int的name。这个name根据编译器的不同而不同，用vc++编译运行int的name就是int而不是本文中的`i`.


[^stl-standard]: 我没有去看最新的标准，这个结论是从《STL源码剖析》里面得出的。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



