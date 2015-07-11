---
layout: post
title: "c++ accumulation"
category: c++
tags: [c++, programming skills]
description: "programming things about c++"
---

#Traps

## 类的static member variables不能在构造函数的初始化列表里初始化

{% highlight c++ %}
class CustomParticleTest : public cocos2d::ParticleSystemQuad {

    public:
        // fail to compile.
        // CustomParticleTest(int particleNum = 350) : s_particleNum(particleNum) {}

        // this is ok.
        CustomParticleTest(int particleNum = 350) {
            s_particleNum = particleNum;
        }

        ~CustomParticleTest() {}
        static CustomParticleTest * create();
        bool initWithTotalParticles(int numberOfParticles);
    private:
        static int s_particleNum;
};
{% endhighlight %}

## 关于dynamic_cast

- dynamic_cast<*> or dynamic_cast<&> need RTTI, so if base class has no virtual functions, will cause compile error. 
    - dynamic_cast<*> return normal pointer or nullptr(when fail).
    - dynamic_cast<&> return normal reference or throw an exception(when fail). 
- dynamic_cast<A*>(nullptr) 会崩溃吗？
    - visual studio 2013 测试不会崩溃

## A* 与 const A *&

```c++
class A {
public:
  int a_;
};

int* g(int* i) {
  return i;
}

int main() {
  int * p = new int(1);
  const int * cp = new int(12);

  int * q = p;
  const int * cq = p;

  int *& rp = p;
  //const int * & crp = p;
  const int* & crp = const_cast<const int*&>( p );
  crp = cp;

  A * pa = new A();
  pa->a_ = 10;

  A*& rpa = pa;
  const A* & crpa = const_cast<const A*&>(pa);

  //int*& ptemp = g(p);

  delete pa;
  delete cp;
  delete p;
  return 0;
}
```

# Latest Questions
- 2014-12-4 父类和子类同时又一个同名文件的时候，通过父类接口改变同名变量，改变的是父类的还是子类的？如AdventureBase的setInitData().
- 没有多态性质的继承体系，在向下转型指针或引用的时候，使用static_cast<>安全吗，无论对单继承还是多继承都会成功转换成功吗？

---

#Language skills

- 只有含 reserve()/capacity() 成员函数的容器才需要用 swap idiom 来释放空间，而 C++ 里只有 vector 和 string 这两个符合条件。在 C++11 中可以直接使用 shrink_to_fit()。 list/deque/set/map 等容器是没有 reserve() 和 capacity() 这两个成员函数的，因此 swap 是无用功（除非用户代码使用了定制的 per-object allocator）。 check google's chromium source codes to learn technique of managing memory of stl utils.  [chromium codes: stl_util.h](http://src.chromium.org/viewvc/chrome/trunk/src/base/stl_util.h)

- DISALLOW_COPY_AND_ASSIGN (or boost::noncopyable)

```c++
\#define DISALLOW_COPY_AND_ASSIGN(TypeName) \
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

- big_endian or little_endian

```c++
// return 0 for big_endian
// return 1 for little_endian
int check_cpu_endian()
{
	union
	{
		int		a;
		char	b;
	}c;
	//
	c.a = 1;
	//
	return (c.b == 1);
}
```

---
#基础知识
##浅谈C/C++中运算符的优先级、运算符的结合性以及操作数的求值顺序
(我的总结：在优先级相同的情况下，结合性决定了谁和谁在一起计算，但是不规定谁先算)
一.运算符的优先级

    在C++ Primer一书中，对于运算符的优先级是这样描述的：

    Precedence specifies how the operands are grouped. It says nothing about the order in which the operands are evaluated.

    意识是说优先级规定操作数的结合方式，但并未说明操作数的计算顺序。举个例子:

    6+3*4+2

    如果直接按照从左到右的计算次序得到的结果是:38，但是在C/C++中它的值为20。

    因为乘法运算符的优先级高于加法的优先级，因此3是和4分组到一起的，并不是6与3进行分组。这就是运算符优先级的含义。

二.运算符的结合性

    Associativity specifies how to group operators at the same precedence level.

    结合性规定了具有相同优先级的运算符如何进行分组。

    举个例子:

    a=b=c=d;

    由于该表达式中有多个赋值运算符，到底是如何进行分组的，此时就要看赋值运算符的结合性了。因为赋值运算符是右结合性，因此该表达式等同于(a=(b=(c=d))),而不是(a=(b=c)=d)这样进行分组的。

    同理如m=a+b+c;

   等同于m=(a+b)+c;而不是m=a+(b+c);

三.操作数的求值顺序

   在C/C++中规定了所有运算符的优先级以及结合性，但是并不是所有的运算符都被规定了操作数的计算次序。在C/C++中只有4个运算符被规定了操作数的计算次序，它们是&&,||,逗号运算符(,),条件运算符(?:)。

   如m=f1()+f2();

   在这里是先调用f1()，还是先调用f2()?不清楚，不同的编译器有不同的调用顺序，甚至相同的编译器不同的版本会有不同的调用顺序。只要最终结果与调用次序无关，这个语句就是正确的。这里要分清楚操作数的求值顺序和运算符的结合性这两个概念，可能有时候会这样去理解，因为加法操作符的结合性是左结合性，因此先调用f1()，再调用f2()，这种理解是不正确的。结合性是确定操作符的对象，并不是操作数的求值顺序。

    同理2+3*4+5;

    它的结合性是(2+(3*4))+5，但是不代表3*4是最先计算的，它的计算次序是未知的，未定义的。

    比如3*4->2+3*4->2+3*4+5

    以及2->3*4->2+3*4->2+3*4+5和5->3*4->2+3*4->2+3*4+5这些次序都是有可能的。虽然它们的计算次序不同，但是对最终结果是没有影响的。

## anonymous namespace's function?

---
#STL


