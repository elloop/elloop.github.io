---
layout: post
title: "google cpp programming style gain"
category: c++
tags: [c++, programming skills]
---

#[summary url](http://zh-google-styleguide.readthedocs.org/en/latest/google-cpp-styleguide/contents/#c)

- 1. DISALLOW_COPY_AND_ASSIGN

```c++
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
```
