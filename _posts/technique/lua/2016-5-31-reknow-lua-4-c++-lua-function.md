---
layout: post
title: "【Programming In Lua (2E) 笔记】4：用lua扩展C++——C++调用lua函数"
category: lua
tags: [lua]
description: ""
published: true
---

<font color="red">自从13年开始做手游接触lua，始终是边写边学，缺乏对lua更加全面系统的学习，这几篇文章开始“重识lua”, 把欠下的帐还回来。这个系列侧重于总结lua作为扩展程序的用法，不会着重介绍lua的语法。</font>

# 前言

本文介绍如何在C++中调用lua的function，lua很多情况下是被用做一种扩展语言，它的function更是增加了这门扩展语言的灵活性，赋予了lua生命力，使它变化莫测。在lua的function中还可以回调宿主语言的函数。这篇文章展示如何从C++端调用lua函数，相反的过程在后面的文章再做介绍。

本文使用的Lua版本还是5.1。


# 简单的调用示例

还是使用上一篇文章中使用的环境，调用config.lua里面的f函数：

**res/config.lua:**

{% highlight lua %}
function f(var)
    return var * var + 2 * var + 100
end
{% endhighlight %}

<!--more-->

**main.cpp：**

{% highlight c++ %}
int main() {

    lua_State* lua = luaL_newstate();

    // 加载config.lua
    luaL_loadfile(lua, "res/config.lua");
    lua_pcall(lua, 0, 0, 0);

    lua_getglobal(lua, "f");        // 获得全局函数f

    if (!lua_isfunction(lua, -1)) {
        error(lua, "f is not a function");
    }

    lua_pushnumber(lua, 10);        // 压入参数 10

    int luaError = lua_pcall(lua, 1, 1, 0);     // 调用函数f，传入1个参数，返回1个参数，不使用错误处理函数
    if (luaError) {
        error(lua, "fail to call f: %s", lua_tostring(lua, -1));
    }

    double result = lua_tonumber(lua, -1);      // 得到返回值

    psln(result); // result = 10*10 + 2 * 10 + 100 = 220

    lua_close(lua);

    return 0;
}
{% endhighlight %}

## `lua_pcall`

其实这个例子里面出现的几个API在前两篇文章中都已经见过，只不过没有用来调用function。这里面调用function的API就是`lua_pcall`, 它的原型是：

`LUA_API int   (lua_pcall) (lua_State *L, int nargs, int nresults, int errfunc);`

第一个参数是lua状态，第二个参数是输入参数个数，第三个参数是返回值个数，最后一个参数是错误处理函数.

<font color="red">注意：无论在执行正常还是出错，之前在栈中的函数和输入参数都会被弹出；如果调用失败，会压入一条错误信息；如果调用成功, `lua_pcall`先弹出函数和输入参数，然后压入返回值，如果返回值个数多于指定的返回值个数nresults, 那么多余的会被丢弃；如果小于nresults，则会压入nil来凑数。</font>

## 关于错误处理函数

在上面的例子中，没有使用错误处理函数，`lua_pcall`的第四个参数传入0即表示不设置错误处理函数。注意到这个参数是一个整数，它的含义是错误处理函数在虚拟栈中的索引。因此，如果我想指定错误处理函数，那么要在调用函数之前，把错误处理函数先压入栈, 而且要先于函数和其参数。当`lua_pcall`调用失败，在压入错误信息之前，会先调用这个错误处理函数。

## `lua_pcall`的返回值

- 0: 调用成功；

- 非0： 调用错误；

## 有没有与`lua_pcall`类似的调用函数？

# 封装调用函数

在PIL第25.4节，介绍了一个通用的调用函数，其功能如下：

对于如下的lua脚本，

**test.lua:**

{% highlight lua %}
function add(a, b)
    return a + b
end
{% endhighlight %}

我要在C++中调用它的add方法:

{% highlight c++ %}
double x, y, z;
x = 10, y = 20, z = 0;

call_va("add", "dd>d", x, y, &z);

assert(z == 30);
{% endhighlight %}

这里的`call_va`就是所说的通用调用函数，

- add: 表示要调用的lua函数名字

- `dd>d`: d 表示double， `>`之前的两个d，表示有两个输入参数分别是double， double； `>`后面的一个d表示返回一个double

- x : 对应于`dd>d`中第1个d, 输入参数

- y : 对应于`dd>d`中第2个d, 输入参数

- z : 对应于`dd>d`中第3个d, 输出参数 —— 即返回值。


下面给出的`call_va`函数的实现与书中实现上略有区别，PIL是C语言风格的代码，这里是C++风格的代码：

{% highlight c++ %}
void call_va(const std::string& script, const std::string& funcName, const std::string& signature, ...) {

    lua_State* lua = luaL_newstate();

    if (luaL_loadfile(lua, script.c_str()) || lua_pcall(lua, 0, 0, 0)) {
        error(lua, "fail to load script: %s, %s", script.c_str(), lua_tostring(lua, -1));
    }

    lua_getglobal(lua, funcName.c_str());
    if (!lua_isfunction(lua, -1)) {
        error(lua, "%s should be a function", funcName.c_str());
    }

    va_list varg;
    va_start(varg, signature);

    int argCount(0);
    std::string returnStr;
    auto iter = signature.begin();
    while (iter != signature.end()) {
        if (*iter == '>') {
            copy(++iter, signature.end(), std::back_inserter(returnStr));
            break;
        }
        else if (*iter == 'd') {
            lua_pushnumber(lua, va_arg(varg, double));
        }
        else if (*iter == 'i') {
            lua_pushinteger(lua, va_arg(varg, int));
        }
        else if (*iter == 's') {
            lua_pushstring(lua, va_arg(varg, char*));
        }
        else if (*iter == 'b') {
            lua_pushboolean(lua, va_arg(varg, bool));
        }
        else {
            error(lua, "unknown arg type: %c", *iter);
        }
        ++iter;
        ++argCount;
    }

    int numberOfReturn = returnStr.length();
    if (lua_pcall(lua, argCount, numberOfReturn, 0) != 0) {
        error(lua, "fail to call %s", funcName.c_str());
    }

    iter = returnStr.begin();
    int returnValueLeft = numberOfReturn;
    while (iter != returnStr.end()) {
        if (returnValueLeft < 1) {
            error(lua, "too much return value specified in signature");
        }

        if (*iter == 'd') {
            if (!lua_isnumber(lua, -returnValueLeft)) {
                error(lua, "%d-th return value should be double", numberOfReturn - returnValueLeft + 1);
            }
            *va_arg(varg, double*) = lua_tonumber(lua, -returnValueLeft);
        }     
        else if (*iter == 'i') {
            if (!lua_isnumber(lua, -returnValueLeft)) {
                error(lua, "%d-th return value should be int", numberOfReturn - returnValueLeft + 1);
            }
            *va_arg(varg, int*) = lua_tointeger(lua, -returnValueLeft);
        }
        else if (*iter == 'b') {
            if (!lua_isboolean(lua, -returnValueLeft)) {
                error(lua, "%d-th return value should be boolean", numberOfReturn - returnValueLeft + 1);
            }
            *va_arg(varg, bool*) = lua_toboolean(lua, -returnValueLeft);
        }
        else {
            error(lua, "unsupported return type: %c", *iter);
        }
        ++iter;
        --returnValueLeft;
    }
    va_end(varg);
    lua_close(lua);
    pv("function call %s(...) complete!\n", funcName.c_str());
}
{% endhighlight %}

测试用例：

**lua脚本：res/extend_demo.lua**

{% highlight lua %}
function add(x, y)
    return x + y
end

function concat(str, n)
    -- print(str .. tostring(n))
end

function fufudezheng(x, y)
    -- print(type(x))
    -- print(type(y))
    if not x and not y then
        return true
    elseif x and y then
        return true
    else
        return false
    end
end
{% endhighlight %}


{% highlight c++ %}
void testLuaCaller() {

    std::string scriptName("res/extend_demo.lua");

    int x, y, z;
    x = 10; y = 20; z = 0;
    callLuaFunction(scriptName, "add", "ii>i", x, y, &z);
    psln(z);                    // z = 30

    int n(10);
    const char* prefix = "hello";
    callLuaFunction(scriptName, "concat", "si", prefix, n);

    double dx, dy, dz;
    dx = 1.2, dy = 1.3, dz = 0;
    callLuaFunction(scriptName, "add", "dd>d", dx, dy, &dz);
    psln(dz);                   // dz = 2.5

    bool bx, by, bz;
    bx = false, by = false, bz = true;
    callLuaFunction(scriptName, "fufudezheng", "bb>b", bx, by, &bz);
    psln(bz);                   // bz = 1   (true)

}
{% endhighlight %}

这个实现还要修改一下:

- 1. 兼容返回char*

- 在C++中打开lua标准库，让res/extend_demo.lua中可以使用lua标准库里的函数

修改之后再回来修改 to be continue...

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

