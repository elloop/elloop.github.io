---
layout: post
title: "【重识Lua】2：操作lua栈"
category: lua
tags: [lua]
description: ""
published: true
---

<font color="red">自从13年开始做手游接触lua，始终是边写边学，缺乏对lua更加全面系统的学习，这几篇文章开始“重识lua”, 把欠下的帐还回来。这个系列侧重于总结lua作为扩展程序的用法，不会着重介绍lua的语法。</font>

# 前言

本文总结了Lua中操作虚拟栈的API，通过这些API可以做到在Lua和C/C++之间传递数据，相互调用对方。在Programming In Lua那本书中（后文简称PIL），作者把这些API称作“C API”，一方面是因为他们是用C语言实现，另一方面它们的作用是用来实现C/C++语言和Lua之间的相互调用。正如PIL中说的那样，几乎所有的这些API都会操作虚拟栈，这个虚拟栈在C/C++与Lua通信过程中，解决了两者之间存在的两个差异，第一是内存管理方式的差异：Lua的垃圾回收和C语言的手动管理；第二是数据类型方面的差异：Lua是动态类型和C语言的静态类型。

本文使用的Lua版本还是5.1。

# Lua C API 版Hello World

下面这段代码演示了C API的基本用法，向lua虚拟栈中push了一个字符串，然后从栈中读取这个字符串，将其打印出来:

{% highlight c++ %}
extern "C" {
   #include "lua_51/lua.h"                            // C API函数声明所在的文件
   #include "lua_51/lauxlib.h"                        // luaL_ 开头的函数所在的头文件, 比如luaL_newstate
}

#include <iostream>

int main()
{
    lua_State* lua = luaL_newstate();                  // 创建一个lua state

    lua_pushstring(lua, "hello world");                // 入栈一个字符串
    std::cout << lua_tostring(lua, 1) << std::endl;    // 从栈中读取字符串

    lua_close(lua);                                    // 关闭lua state

    return 0;
}
{% endhighlight %}

<!--more-->


这个例子中演示了一个很简单的操作lua虚拟栈的方法，`lua_pushstring`是向栈中压入一个字符串，`lua_tostring`是从lua栈中读取一个字符串。

几乎所有的C API都需要一个`lua_State*`类型的参数，这个结构体用来保存lua的状态。`luaL_newstate`用来创建一个新的状态，这个函数被定义在lua辅助函数文件lauxlib.h中。

开头的两个头文件包含使用 extern "C"来包裹是因为我要使用C++编译器来构建工程, 也可以使用Lua 5.1中带的lua.hpp来代替。lua.hpp 这个文件在Lua 5.1解压后的根目录/etc/目录下面。

要想上面的例子编译通过，可以按如下方式来组织代码：

--src/

----lua_src/ -- 这个目录存放lua 5.1的源代码, 要想使用lua.hpp, 把Lua 5.1解压目录下的etc/lua.hpp也放在这里面

----main.cpp -- 这就是上面的示例代码所在文件

在编译的时候，把src/目录放进包含目录。建议使用cmake来组织工程，会节省你很多精力。这里是我建立的一个[工程示例:`lua_in_cpp`](https://github.com/elloop/lua_in_cpp)，使用cmake组织好的，可供参考。

# 常用的lua入栈函数, 压入基本类型

| *函数名*                                                     | *作用*                             |
| ----------                                                   | -------                            |
| `lua_pushnil(lua_State* lua)`                                | 压入nil                            |
| `lua_pushboolean(lua_State* lua, int val)`                   | 压入bool                           |
| `lua_pushnumber(lua_State* lua, lua_Number n)`               | 压入数字                           |
| `lua_pushinteger(lua_State* lua, lua_Integer n)`             | 压入整数                           |
| `lua_pushlstring(lua_State* lua, const char* s, size_t len)` | 压入字符串，指定长度               |
| `lua_pushstring(lua_State* lua, const char* s)`              | 压入字符串，使用strlen自动计算长度 | 

# 读取lua栈内容的函数

| *函数名*                                                | *作用*                                      |
| --------                                                | ------                                      |
| `lua_toboolean(lua_State* lua, int index)`              | 获取栈中索引为index处的bool值               |
| `lua_tonumber(lua_State* lua, int index)`               | 获取栈中索引为index处的数字值               |
| `lua_tointeger(lua_State* lua, int index)`              | 获取栈中索引为index处的整数值               |
| `lua_tolstring(lua_State* lua, int index, size_t* len)` | 获取栈中索引为index处的字符串和其长度       |
| `lua_tostring(lua_State* lua, int index)`               | 宏，以NULL为第三个参数来调用`lua_tolstring` |
| `size_t lua_objlen(lua_State* lua, int index)`          | 获取栈中索引为index处的值的长度             |


<font color="red">注意：`lua_to***`系列函数只是读取栈内的内容，并不会修改栈的内容</font>

# 修改栈的API

| *函数名*                                        | *作用*                                                         |
| --------                                        | ------                                                         |
| `void lua_settop(lua_State* lua, int index)`    | 设置index位置为栈顶，多余元素被干掉，出现空缺的话补nil         |
| `void lua_pushvalue(lua_State* lua, int index)` | 把index处值的副本压入栈顶                                      |
| `void lua_remove(lua_State* lua, int index)`    | 移除index处的值，上面的元素下移一位                            |
| `void lua_insert(lua_State* lua, int index)`    | 在index处插入栈顶元素，其上的元素上移一位                      |
| `void lua_replace(lua_State* lua, int index)`   | 把栈顶元素设置到index处，原值被覆盖                            |
| `void lua_pop(lua_State* lua, int count)`       | 宏，从栈中弹出count个元素，等价于`lua_settop(lua, -1 - count)` |

# 其它查看lua信息的函数

| *函数名*                                             | *作用*                                                            |
| --------                                             | ------                                                            |
| `int lua_isnumber(lua_State* lua, int index)`        | 判断lua栈中index位置的元素是否是number                            |
| `int lua_isstring(lua_State* lua, int index)`        | 判断lua栈中index位置的元素是否是字符串                            |
| `int lua_is***(lua_State* lua, int index)`           | 判断lua栈中index位置的元素是否是***, 同上，不再枚举               |
| `int lua_type(lua_State* lua, int index)`            | 返回index位置元素的类型，具体取值范围请参见lua.h, 如`LUA_TNUMBER` |
| `const char* lua_typename(lua_State* lua, int type)` | 返回type常量对应的元素类型名称                                    |
| `int lua_gettop(lua_State* lua)`                     | 获得栈的大小                                                      | 


# 例程：打印lua虚拟栈

熟悉API最快的办法就是用它来写点东西，下面就来写一个实用的函数：printLuaStack, 它可以把lua虚拟栈当前的所有内容打印出来，先看一下它的作用, 在一个空栈里push进5个值，然后调用printLuaStack查看栈的情况:

{% highlight c++ %}
void testPrintStackFunction() {
    lua_State* lua = luaL_newstate();

    int stackSize = lua_gettop(lua);    // empty, so stackSize == 0;
    assert(stackSize == 0);
    
 
    lua_pushnil(lua);                   ++stackSize; // 1
    lua_pushnumber(lua, 1.2);           ++stackSize; // 2
    lua_pushstring(lua, "hello world"); ++stackSize; // 3
    lua_pushboolean(lua, 1);            ++stackSize; // 4
    lua_pushinteger(lua, 100);          ++stackSize; // 5

    printLuaStack(lua);         // 打印栈

    assert( (stackSize == 5) && (stackSize == lua_gettop(lua)) );

    lua_close(lua);
}
{% endhighlight %}

输出示例：

{% highlight c++ %}
========= content of stack from top to bottom: ===========
5 [-1]	number: 	100.00
4 [-2]	boolean: 	1
3 [-3]	string: 	hello world
2 [-4]	number: 	1.20
1 [-5]	nil
stackSize = 5
{% endhighlight %}

可以看到, printLuaStack函数打印出了从栈顶到栈底的元素信息. 

其中，<font color="red">第一列的数字就表示元素在栈中的index，从栈顶到栈底依次减小，既可以是正数，也可以是负数</font> ，比如上面例子里，栈顶元素的索引既可以是5，也可以方括号里的-1，二者等价。正数索引和负数索引有其各自的方便之处，在后面编写调用lua函数代码的时候就能体会得到。

对于栈中的元素，如果是可打印的就打印出其值，否则仅打印其类型即可。

这是一个很好的练习，使用上文表格里的几个函数即可完成，相信你会轻松搞定。下面给出一个实现作为参考。

{% highlight c++ %}
void printLuaStack(lua_State* lua) {

    pln("========= content of stack from top to bottom: ===========");

    int stackSize = lua_gettop(lua);                    // 获得栈中元素个数
    for (int i=stackSize; i>0; --i) {
        pv("%d [%d]\t", i, -1 - (stackSize - i));
        int t = lua_type(lua, i);                       // 判断当前元素类型
        switch (t) {
            case LUA_TNUMBER:
                pv("%s: \t%.2f\n", lua_typename(lua, t), lua_tonumber(lua, i));     // 打印类型名称和值
                break;
            case LUA_TBOOLEAN:
                pv("%s: \t%d\n", lua_typename(lua, t), lua_toboolean(lua, i));
                break;
            case LUA_TSTRING:
                pv("%s: \t%s\n", lua_typename(lua, t), lua_tostring(lua, i));
                break;
            default:
                // LUA_TTABLE
                // LUA_TTHREAD
                // LUA_TFUNCTION
                // LUA_TLIGHTUSERDATA
                // LUA_TUSERDATA
                // LUA_TNIL
                pv("%s\n", lua_typename(lua, t));                                   // 不好打印的类型，暂时仅打印类型名称
                break;
        }
    }
    psln(stackSize);
}
{% endhighlight %}

代码中的pln, pv, psln函数定义在[这里](https://github.com/elloop/lua_in_cpp/blob/master/src/include/print_util.h), 是一些简便易用的打印函数。

如果搭建环境有困难，可以下载我这个工程: [`lua_in_cpp`](https://github.com/elloop/lua_in_cpp). 

clone下项目之后，直接运行根目录下的run.sh即可一键编译运行工程。你需要有一个支持C++11的编译器，cmake和Make. 编译器的设置在CMakeLists.txt里面。

# 总结

一旦搭建好了环境，下面的学习过程就很容易了, Enjoy Coding and Testing and Coding loop.

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



