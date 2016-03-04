---
layout: post
title: "c++标识符中下划线的使用"
category: c++
tags: grammar
description: ""
---

今天在Code Review网站上看到了一个关于在宏定义中使用下划线的讨论 :

{% highlight c++ %}
#define _BasicFsmT_h
{% endhighlight %}

这个宏定义有问题吗？

<!--more-->

是有问题的，证明它有问题的证据就是c++标准的规定：

>在任何作用域内，以一个下划线开头，并且紧接着一个大写字母是保留的标识符。

---
下面的一个SOF的回答总结了更多的关于在标识符里使用下划线的规则:

##The rules (which did not change in C++11):

>
- Reserved in any scope, including for use as implementation macros:
    - identifiers beginning with an underscore followed immediately by an uppercase letter
    - identifiers containing adjacent underscores (or "double underscore")
- Reserved in the global namespaces:
    - identifiers beginning with an underscore
    - Also, everything in the std namespace is reserved. (You are allowed to add template specializations, though.)

##From the 2003 C++ Standard:

>
- 17.4.3.2.1 Global names [lib.global.names]
    Certain sets of names and function signatures are always reserved to the implementation:

        - Each name that contains a double underscore (_ _) or begins with an underscore followed by an uppercase letter (2.11) is reserved to the implementation for any use.
        - Each name that begins with an underscore is reserved to the implementation for use as a name in the global namespace. Such names are also reserved in namespace ::std (17.4.3.1).

Because C++ is based on the C standard (1.1/2, C++03) and C99 is a normative reference (1.2/1, C++03) these also apply, from the 1999 C Standard:

>##7.1.3 Reserved identifiers
Each header declares or defines all identifiers listed in its associated subclause, and optionally declares or defines identifiers listed in its associated future library directions subclause and identifiers which are always reserved either for any use or for use as file scope identifiers.
>
- All identifiers that begin with an underscore and either an uppercase letter or another underscore are always reserved for any use.
- All identifiers that begin with an underscore are always reserved for use as identifiers with file scope in both the ordinary and tag name spaces.
- Each macro name in any of the following subclauses (including the future library directions) is reserved for use as specified if any of its associated headers is included; unless explicitly stated otherwise (see 7.1.4).
- All identifiers with external linkage in any of the following subclauses (including the future library directions) are always reserved for use as identifiers with external linkage.
- Each identifier with file scope listed in any of the following subclauses (including the future library directions) is reserved for use as a macro name and as an identifier with file scope in the same name space if any of its associated headers is included.

>No other identifiers are reserved. If the program declares or defines an identifier in a context in which it is reserved (other than as allowed by 7.1.4), or defines a reserved identifier as a macro name, the behavior is undefined.

>If the program removes (with #undef) any macro definition of an identifier in the first group listed above, the behavior is undefined.

>The list of reserved identifiers with external linkage includes errno, math_errhandling, setjmp, and va_end.

Other restrictions might apply. For example:
##the POSIX standard reserves a lot of identifiers that are likely to show up in normal code:

>
- Names beginning with a capital 'E' followed a digit or uppercase letter:
may be used for additional error code names.
- Names that begin with either 'is' or 'to' followed by a lowercase letter
may be used for additional character testing and conversion functions.
- Names that begin with 'LC_' followed by an uppercase letter
may be used for additional macros specifying locale attributes.
- Names of all existing mathematics functions suffixed with 'f' or 'l' are reserved
for corresponding functions that operate on float and long double arguments, respectively.
- Names that begin with 'SIG' followed by an uppercase letter are reserved
for additional signal names.
- Names that begin with 'SIG_' followed by an uppercase letter are reserved
for additional signal actions.
- Names beginning with 'str', 'mem', or 'wcs' followed by a lowercase letter are reserved
for additional string and array functions.
- Names beginning with 'PRI' or 'SCN' followed by any lowercase letter or 'X' are reserved
for additional format specifier macros
- Names that end with '_t' are reserved
for additional type names.

While using these names for your own purposes right now might not cause a problem, they do raise the possibility of conflict with future versions of that standard.


