---
layout: post
title: "C++的The Big Three and A Half 是什么"
category: c++
tags: [stl]
description: ""
---


# 前言

big three and a half or rule of three.

回答内容摘录自：[stack overflow - what is rule of three](http://stackoverflow.com/questions/4172722/what-is-the-rule-of-three)

C++ treats variables of user-defined types with value semantics. This means that objects are implicitly copied in various contexts, and we should understand what "copying an object" actually means.

Let us consider a simple example:

{% highlight c++ %}
class person
{
    std::string name;
    int age;

public:

    person(const std::string& name, int age) : name(name), age(age)
    {
    }
};

int main()
{
    person a("Bjarne Stroustrup", 60);
    person b(a);   // What happens here?
    b = a;         // And here?
}
{% endhighlight %}

(If you are puzzled by the name(name), age(age) part, this is called a member initializer list.)

<!--more-->

Special member functions

What does it mean to copy a person object? The main function shows two distinct copying scenarios. The initialization person b(a); is performed by the copy constructor. Its job is to construct a fresh object based on the state of an existing object. The assignment b = a is performed by the copy assignment operator. Its job is generally a little more complicated, because the target object is already in some valid state that needs to be dealt with.

Since we declared neither the copy constructor nor the assignment operator (nor the destructor) ourselves, these are implicitly defined for us. Quote from the standard:

The [...] copy constructor and copy assignment operator, [...] and destructor are special member functions. [ Note: The implementation will implicitly declare these member functions for some class types when the program does not explicitly declare them. The implementation will implicitly define them if they are used. [...] end note ] [n3126.pdf section 12 §1]
By default, copying an object means copying its members:

The implicitly-defined copy constructor for a non-union class X performs a memberwise copy of its subobjects. [n3126.pdf section 12.8 §16]

The implicitly-defined copy assignment operator for a non-union class X performs memberwise copy assignment of its subobjects. [n3126.pdf section 12.8 §30]
Implicit definitions

The implicitly-defined special member functions for person look like this:

{% highlight c++ %}

// 1. copy constructor
person(const person& that) : name(that.name), age(that.age)
{
}

// 2. copy assignment operator
person& operator=(const person& that)
{
    name = that.name;
    age = that.age;
    return *this;
}

// 3. destructor
~person()
{
}
{% endhighlight %}

Memberwise copying is exactly what we want in this case: name and age are copied, so we get a self-contained, independent person object. The implicitly-defined destructor is always empty. This is also fine in this case since we did not acquire any resources in the constructor. The members' destructors are implicitly called after the person destructor is finished:

After executing the body of the destructor and destroying any automatic objects allocated within the body, a destructor for class X calls the destructors for X's direct [...] members [n3126.pdf 12.4 §6]
Managing resources

So when should we declare those special member functions explicitly? When our class manages a resource, that is, when an object of the class is responsible for that resource. That usually means the resource is acquired in the constructor (or passed into the constructor) and released in the destructor.

Let us go back in time to pre-standard C++. There was no such thing as std::string, and programmers were in love with pointers. The person class might have looked like this:

{% highlight c++ %}
class person
{
    char* name;
    int age;

public:

    // the constructor acquires a resource:
    // in this case, dynamic memory obtained via new[]
    person(const char* the_name, int the_age)
    {
        name = new char[strlen(the_name) + 1];
        strcpy(name, the_name);
        age = the_age;
    }

    // the destructor must release this resource via delete[]
    ~person()
    {
        delete[] name;
    }
};
{% endhighlight %}

Even today, people still write classes in this style and get into trouble: "I pushed a person into a vector and now I get crazy memory errors!" Remember that by default, copying an object means copying its members, but copying the name member merely copies a pointer, not the character array it points to! This has several unpleasant effects:

Changes via a can be observed via b.

Once b is destroyed, a.name is a dangling pointer.

If a is destroyed, deleting the dangling pointer yields undefined behavior.

Since the assignment does not take into account what name pointed to before the assignment, sooner or later you will get memory leaks all over the place.
Explicit definitions

Since memberwise copying does not have the desired effect, we must define the copy constructor and the copy assignment operator explicitly to make deep copies of the character array:

{% highlight c++ %}
// 1. copy constructor
person(const person& that)
{
    name = new char[strlen(that.name) + 1];
    strcpy(name, that.name);
    age = that.age;
}

// 2. copy assignment operator
person& operator=(const person& that)
{
    if (this != &that)
    {
        delete[] name;
        // This is a dangerous point in the flow of execution!
        // We have temporarily invalidated the class invariants,
        // and the next statement might throw an exception,
        // leaving the object in an invalid state :(
        name = new char[strlen(that.name) + 1];
        strcpy(name, that.name);
        age = that.age;
    }
    return *this;
}
{% endhighlight %}

Note the difference between initialization and assignment: we must tear down the old state before assigning to name to prevent memory leaks. Also, we have to protect against self-assignment of the form x = x. Without that check, delete[] name would delete the array containing the source string, because when you write x = x, both this->name and that.name contain the same pointer.

Exception safety

Unfortunately, this solution will fail if new char[...] throws an exception due to memory exhaustion. One possible solution is to introduce a local variable and reorder the statements:

{% highlight c++ %}
// 2. copy assignment operator
person& operator=(const person& that)
{
    char* local_name = new char[strlen(that.name) + 1];
    // If the above statement throws,
    // the object is still in the same state as before.
    // None of the following statements will throw an exception :)
    strcpy(local_name, that.name);
    delete[] name;
    name = local_name;
    age = that.age;
    return *this;
}
{% endhighlight %}

This also takes care of self-assignment without an explicit check. An even more robust solution to this problem is the copy-and-swap idiom, but I will not go into the details of exception safety here. I only mentioned exceptions to make the following point: Writing classes that manage resources is hard.

Noncopyable resources

Some resources cannot or should not be copied, such as file handles or mutexes. In that case, simply declare the copy constructor and copy assignment operator as private without giving a definition:

{% highlight c++ %}
private:

    person(const person& that);
    person& operator=(const person& that);
{% endhighlight %}

Alternatively, you can inherit from boost::noncopyable or declare them as deleted (C++0x):

{% highlight c++ %}
person(const person& that) = delete;
person& operator=(const person& that) = delete;
{% endhighlight %}

The rule of three


Sometimes you need to implement a class that manages a resource. (Never manage multiple resources in a single class, this will only lead to pain.) In that case, remember the rule of three:

If you need to explicitly declare either the destructor, copy constructor or copy assignment operator yourself, you probably need to explicitly declare all three of them.
(Unfortunately, this "rule" is not enforced by the C++ standard or any compiler I am aware of.)

Advice

Most of the time, you do not need to manage a resource yourself, because an existing class such as std::string already does it for you. Just compare the simple code using a `std::string` member to the convoluted and error-prone alternative using a `char*` and you should be convinced. As long as you stay away from raw pointer members, the rule of three is unlikely to concern your own code.


---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



