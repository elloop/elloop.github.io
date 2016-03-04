---
layout: post
title: "Google C++编程风格"
from_others: true
original_url: "http://zh-google-styleguide.readthedocs.org/en/latest/google-cpp-styleguide/contents/#c"
category: c++
tags: [notes]
---

- 1. DISALLOW_COPY_AND_ASSIGN

{% highlight c++ %}
#define DISALLOW_COPY_AND_ASSIGN(TypeName) \
            TypeName(const TypeName&); \
            void operator=(const TypeName&)

// in class define
class Foo {
    public:
        Foo(int f);
        ~Foo();

    private:
        DISALLOW_COPY_AND_ASSIGN(Foo);
};
{% endhighlight %}

<!--more-->
