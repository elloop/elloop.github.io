---
layout: post
title: Date-04-07
category: life
tags: [diary]
published: false
---

#Todo
---

#Summary
---
## 1 ADL
**ADL**: Argument Dependent Lookup:
picked from StackOverflow:

Koenig Lookup is also commonly known as Argument Dependent Lookup in C++ and most of the Standard C++ compilers support it.

The C++11 standard § 3.4.2/1 states:

When the postfix-expression in a function call (5.2.2) is an unqualified-id, other namespaces not considered during the usual unqualified lookup (3.4.1) may be searched, and in those namespaces, namespace-scope friend function declarations (11.3) not otherwise visible may be found. These modifications to the search depend on the types of the arguments (and for template template arguments, the namespace of the template argument).
In simpler terms Nicolai Josuttis states1:

**You don’t have to qualify the namespace for functions if one or more argument types are defined in the namespace of the function.**
A simple code example:

namespace MyNamespace
{
    class MyClass {};
    void doSomething(MyClass);
}

MyNamespace::MyClass obj; // global object


int main()
{
    doSomething(obj); // Works Fine - MyNamespace::doSomething() is called.
}
In the above example there is neither a using-declaration nor a using-directive but still the compiler correctly identifies the unqualified name doSomething() as the function declared in namespace MyNamespace by applying the Koenig algorithm.

How does it work?
The algorithm tells the compiler to not just look at local scope, but also the namespaces that contain the argument's type. Thus, in the above code, the compiler finds that the object obj, which is the argument of the function doSomething(), belongs to the namespace MyNamespace. So, it looks at that namespace to locate the declaration of doSomething().

What is the advantage of Koenig Lookup?
As the simple code example above demonstrates above the Koenig Algorithm provides convenience and ease of usage to the programmer. Without Koenig Algorithm there would be an overhead on the programmer, to repeatedly specify the fully qualified names, or instead, use numerous using-declarations.

Why the criticism of Koenig Algorithm?
Over dependence on Koenig Algorithm can lead to semantic problems,and catch the programmer off guard sometimes.

Consider the example of std::swap, which is a standard library algorithm to swap two values. With the Koenig algorithm one would have to be cautious while using this algorithm because:

std::swap(obj1,obj2);    
may not show the same behavior as:

using std::swap;
swap(obj1, obj2);
With ADL, which version of swap function gets called would depend on the namespace of the arguments passed to it.
If there exists an namespace A and if A::obj1, A::obj2 & A::swap() exist then the second example will result in a call to A::swap() which might not be what the user wanted.

Further, if for some reason both:
A::swap(A::MyClass&, A::MyClass&) and std::swap(A::MyClass&, A::MyClass&) are defined, then the first example will call std::swap(A::MyClass&, A::MyClass&) but the second will not compile because swap(obj1, obj2) would be ambiguous.

## 2. noncopyable implementation.

{% highlight c++ %}
//  Boost noncopyable.hpp header file  --------------------------------------//

//  (C) Copyright Beman Dawes 1999-2003. Distributed under the Boost
//  Software License, Version 1.0. (See accompanying file
//  LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

//  See http://www.boost.org/libs/utility for documentation.

#ifndef BOOST_NONCOPYABLE_HPP_INCLUDED
#define BOOST_NONCOPYABLE_HPP_INCLUDED

#include <boost/config.hpp>

namespace boost {

//  Private copy constructor and copy assignment ensure classes derived from
//  class noncopyable cannot be copied.

//  Contributed by Dave Abrahams

namespace noncopyable_  // protection from unintended ADL
{
  class noncopyable
  {
   protected:
#ifndef BOOST_NO_DEFAULTED_FUNCTIONS
    BOOST_CONSTEXPR noncopyable() = default;
    ~noncopyable() = default;
#else
    noncopyable() {}
      ~noncopyable() {}
#endif
#ifndef BOOST_NO_DELETED_FUNCTIONS
        noncopyable( const noncopyable& ) = delete;
        noncopyable& operator=( const noncopyable& ) = delete;
#else
    private:  // emphasize the following members are private
      noncopyable( const noncopyable& );
      noncopyable& operator=( const noncopyable& );
#endif
  };
}

typedef noncopyable_::noncopyable noncopyable;

} // namespace boost

#endif  // BOOST_NONCOPYABLE_HPP_INCLUDED
{% endhighlight %}

#Qeustions.
---


