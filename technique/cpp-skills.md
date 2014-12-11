# c++ programming skills

## Latest Questions
- 2014-12-4 父类和子类同时又一个同名文件的时候，通过父类接口改变同名变量，改变的是父类的还是子类的？如AdventureBase的setInitData().

-

## Language skills

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

