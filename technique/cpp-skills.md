# c++ programming skills

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

