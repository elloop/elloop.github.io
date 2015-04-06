#Effective cpp (third edition)
## item2: Prefer consts, enums, and inlines to #defines.
*reason*
- define会造成代码膨胀，目标代码里替换所有define为同一个东西，重复。
- define通常没有scope的概念，也没有封装的概念
- define出来的函数有隐含的出错风险。 
```c++
#define MAX(a, b) (a) > (b) ? (a) : (b);
void f() {
	int a(1), b(0);
	MAX(++a, b);		// a 被累加两次
	MAX(++a, b+10);	// a 被累加1次
}
```

*conclusion*
- 常量：使用const或enum代替
- 函数形式的宏：改用inline函数代替

## item3: Use const whenever possible.
*reason*
- 避免不必要的错误，帮助编译器侦测出错误的用法。对象、函数参数、返回类型、成员函数，都可以用const来修饰。
- 对于member function，const 函数可以使const对象可以调用。

*conclusion*
- 编译器只保证bitwise constness，程序员应该做到logical constness(const成员函数不应该返回可以修改对象内部状态的引用或指针）
- 当const和non-const版本的函数有等价的实现的时候，让non-const版本调用const版本
```c++
const int& value() const {
	// ...
}
int& value() {
	return const_cast<int&>(static_cast<const T&>(*this).value());
}
```

## item4: Make sure that objects are initialized before they are used.
*conclusion*
- 使用member initialization list初始化类成员，以声明次数为准。
- “跨编译单元的初始化次序”问题，把non-local static对象替换为local static对象。使用reference-returning函数。

```c++
//---------------------------- use local static ----------------------------
// non-local static object in A.cpp
static Object a;
// used in B.cpp
static ObjectB b = a.getB(); // a may be uninitialized.

//---------------------------- reference-returning: local static ----------------------------
Object& getA() {
	static Object a;
   return a;
}

ObjectB& getB() {
	static ObjectB b = getA().getB();
   return b;
}
```

## item7: Declare destructors virtual in polymorphic base class.
*reason*
- avoid resource leak.

*conclusion*
- 为polymorphic base class声明一个virtual析构函数。如果base class带有任何的virtual函数，它就应该有一个virtual析构函数
>polymorphic base class是指：为实现“要通过base class接口来调用derived class对象”而设计的基类。

- 不是为了继承而定义的base class就不需要声明virtual析构函数，浪费空间（带virtual函数需要该class有vtbl）。并且不要继承这种不带虚析构函数的类（比如stl里面的容器）。

## item9: Never call virtual functions during construction or destruction.
*reason*
- 在base class构造（析构）期间，virtual函数不是virtual函数。

## item10: Have assignment operators return a reference to *this.
*reason*
- 可以实现连锁赋值的效果。非强制，但是这样可以与内置类型和stl保持一致。

## item11： Hanle assignment to self in operator=.
*conclusion*
- 使用证同测试(identity test), ( `if (this == &rhs) return *this;`)
- 为了异常安全性(exception safety)，调整语句执行顺序

```c++
Object& Object::operator=(const Object& rhs) {
	Mem * pOrig = mem_;			// save original mem;
    mem_ = new Mem(*rhs.mem_);	// if throw exception here, mem_ is still available.
    delete pOrig;
    return *this;
}
```

- copy-and-swap 技术

```c++
class Object {
	void swap(Object& rhs);
};
Object& Object::operator=(const Object& rhs) {
	Object temp(rhs);
    swap(temp);
    return *this;
}
```