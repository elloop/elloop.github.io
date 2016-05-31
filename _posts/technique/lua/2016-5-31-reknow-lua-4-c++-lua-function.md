---
layout: post
title: "【重识Lua】4：用lua扩展C++——C++调用lua函数"
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

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



