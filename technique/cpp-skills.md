# c++ programming skills

## Latest Questions
- 2014-12-4 父类和子类同时又一个同名文件的时候，通过父类接口改变同名变量，改变的是父类的还是子类的？如AdventureBase的setInitData().

-

## Language skills

## 12/12/2014
陈硕，Linux C++程序员，muduo 网络库作者
查灏巍、Linux、邹晓航 等人赞同
只有含 reserve()/capacity() 成员函数的容器才需要用 swap idiom 来释放空间，而 C++ 里只有 vector 和 string 这两个符合条件。在 C++11 中可以直接使用 shrink_to_fit()。

list/deque/set/map 等容器是没有 reserve() 和 capacity() 这两个成员函数的，因此 swap 是无用功（除非用户代码使用了定制的 per-object allocator）。

check google's chromium source codes to learn technique of managing memory of stl utils.
[](http://src.chromium.org/viewvc/chrome/trunk/src/base/stl_util.h)

## before 12/12/2014
- 1. DISALLOW_COPY_AND_ASSIGN
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

- 2. big_endian or little_endian
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

