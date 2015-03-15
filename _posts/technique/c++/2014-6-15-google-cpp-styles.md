---
layout: post
title: google cpp programming style gain
---
{{ page.title }}

- 1. DISALLOW_COPY_AND_ASSIGN

```
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
