---
layout: post
title: "Lessons learned from c/c++ defects"
category: c++
tags: [c++, programming skills]
---

#summary of book "Lessons Learned From c/c++ Defects"

## basic question
1. n << 1 + 1 == 4*n , not 2*n + 1

2. what will happen? 
```
#define perimeter(x, y) 2*x + 2*y
volume = perimeter(x, y) * high
``` 

correct: #define perimeter(x, y) (2*(x) + 2*(y))
3. #define map __gnu_cxx::hash_map // in a.cpp
files which include 'a.cpp' will be polluted by map define.
4. 多语句宏使用错误，应该用{}把多语句宏括起来，或者最好是用inline函数代替宏.
5. what's wrong?
```
int main() {
    char c ;
    while ((c = getchar()) != EOF) {
        putchar(c);
    }
    return 0;
}
```
correct: int c;

6. signed int 和 unsigned int比较时候，前者会转成后者，如果前者是负数，转换结果会影响比较结果。
7. see:
```
struct data
{
    int flag:1;
    int other: 31;
}
int status()
{
    return 1;
}
int main()
{
    struct data test;
    test.flag = status();
    if (test.flag == 1)
    {
        printf("true");
    }
    else
    {
        printf("false");
    }
    return 0;
}
```
correct: flag is sined bit, value only be 0 or -1.
so change to unsigned int flag: 1;

8. compare float:
```
float f = 1.0 / 3;
float f2 = 0.333333;
// wrong
if (f == f2) {
    // same
}

// right
if (fabs(f - f2) < 0.00001)
    // same

```

9. 
```
int minInt = 0xffffffff;
minInt = -minInt;
printf("%d", minInt);

// right: -1 最小负整数的相反数需要单独判断
if (minInt == 0xffffffff) 
{

}

10. right?
```
int main()
{
    size_t size = sizeof(int);
    while (--size >= 0)
    {
        cout << size << endl;
    }
    retrun 0;
}
```
jkjkjkjkjkkjjkjk
jk
correct: --size > 0

11. struct init style.
```
struct rect
{
    int l, w;
}
hello jello jelly beans 
// bad style.
struct rect r = {10, 20};

// good style.
struct rect r = { r.l = 10, r.w = 20};
```

12. 模板的两段编译
```
template<typename T>
class A {
    protected:
        int num;
};

template <typename T>
class B : public A<T> {
    void init() {
        num = 0;
    }
};
```

won't compiling pass in latest complier
but will pass in old complier
新的编译器模板两段编译：
1. 扫描所有非依赖名称
2. (实例化模板)扫描所有依赖名称(只有实例化的时候才能消除歧义的名称)
reason: num是一个非依赖参数, 但是但是定义在基类中的，目前的编译器还没有实现第一阶段到模板基类中查找名称，因此会报错：num undeclared.

旧版的编译器没有实现两段编译，对模板类的语法解析时，所有的名字查找都留在了实例化的时候进行，所以可以通过编译

how to fix: this->num 将会使num变成依赖型名称

## lib functions.
1. sprintf: segmentation fault.
```
char src[] = "aaaaaaaaaaaaaaaaaaaaa";
char buf[10] = "";
int len = sprintf(buf, "%s", src);
```
suggestion:
>1. snprintf: 会检查返回值n，如果n>len(buffer), 会重新分配空间并再一次调用snprintf.
2. asprintf: 不预先分配buf内存，复制过程中根据实际复制源的大小动态分配内存，参考libc手册

2. snprintf parameters:
```
char buf[10] = "";
char src[10] = "hello %s";
int len = sprintf(buf, sizeof(buf), src);

correct:
int len = sprintf(buf, sizeof(buf), "%s", src);
```

3. return value of snprintf:
```
char buf[10] = "";
char src[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaa";
int len = snprintf(buf, sizeof(buf), "%s", src);
buf[len] = '\0';
printf("buf = %s, buf_len = %d\n", buf, len);
```
snprintf返回实际写入到buf的字符个数（假设buf大小没有限制）
e.g.: 
"%s" src = "123" -> len = 3
"src=%s" src = "123" -> len = strlen("str=") + strlen(src) = 6
"%s" src = "1234567890123" -> len = 13

correct:
```
int len = snprintf(buf, sizeof(buf), "%s", src);
printf("return len: %d\n", len);
if (len > sizeof(buf) - 1) {
    printf("error: src len is %d, buf size is %d not enough", len, sizeof(buf));
}
else {
    printf("buf=%s, len is %d\n", buf, strlen(buf));
}
```


