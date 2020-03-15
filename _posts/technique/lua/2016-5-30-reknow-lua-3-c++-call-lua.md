---
layout: post
title: "【重识Lua】3：给C++程序插上翅膀——C++调用lua"
category: lua
tags: [lua]
description: ""
published: true
---

<font color="red">自从13年开始做手游接触lua，始终是边写边学，缺乏对lua更加全面系统的学习，这几篇文章开始“重识lua”, 把欠下的帐还回来。这个系列侧重于总结lua作为扩展程序的用法，不会着重介绍lua的语法。</font>

# 前言

前一篇文章总结了lua中C API的基本用法和常见的虚拟栈操作函数，并没有涉及到具体的lua代码，只有当这些API用来连接lua代码和C++代码的时候，才能发挥出它的最大威力。本文的主题在于使用C++来加载、调用lua代码。

本文使用的Lua版本还是5.1。

# C++中加载lua脚本

就像打开其它类型的文件一样，比如打开一个txt文件读取成一个字符串，打开一个json文件用json解析库来解析出感兴趣的字段；对于lua脚本则有lua解析器去解释它，它不仅可以被当做普通的静态配置文件来使用，更牛的地方就在于，它，是可编程的！对，因为它是一门编程语言。尤其是当你为lua打开了它的翅膀（lua标准库）。

下面就给出一个简单的例子，演示一下，如何把lua脚本当做一种资源，载入到C++代码中。

下面这个lua文件里定义了两个全局变量一个是字符串类型的怪物类型，一个是怪物血量，我把它当做一个配置文件来用，在C++中读取它们的值

**res/config.lua:**

{% highlight lua %}
monster_type = "Ghost"
blood        = 99.9
{% endhighlight %}

**main.cpp:**

{% highlight c++ %}
#include "lua_51/lua.hpp"
#include "include/inc.h"
#include <string>

using namespace elloop;
using namespace std;

int main() {

    string scriptName("res/config.lua");

    lua_State* lua = luaL_newstate();

    int luaError = luaL_loadfile(lua, scriptName.c_str());  // 加载lua文件
    if (luaError) {
        error(lua, "fail to load script: %s, %s", scriptName.c_str(), lua_tostring(lua, -1));
    }

    luaError = lua_pcall(lua, 0, 0, 0);     // 执行这个lua文件, 三个0依次表示：输入0个参数，返回0个结果，需要0个错误处理函数
    if (luaError) {
        error(lua, "fail to run script: %s", lua_tostring(lua, -1));
    }

    lua_getglobal(lua, "blood");                            // 获取全局变量blood
    lua_getglobal(lua, "monster_type");                     // 获取全局变量monster_type

    double blood     = lua_tonumber(lua, 1);                // 读取两个全局变量
    const char* type = lua_tostring(lua, 2);

    psln(blood);                                            // 打印 blood = 99.9
    psln(type);                                             // type = Ghost

    lua_close(lua);

    return 0;
}
{% endhighlight %}

<!--more-->

**输出：**

{% highlight c++ %}
blood = 99.9
type = Ghost
{% endhighlight %}

可以看到lua这种“配置”文件还是比较方便读取的，不用关心字符和数字等类型的处理细节，丢给lua解释器就行了，它会把值提取出来放到虚拟栈上等我来取, 只是我自己需要心里有数我想要的变量在栈的什么位置，数据类型是什么。这些都可以通过合理的封装做到更加易用和不易出错。

相对于txt, json, xml等配置文件，lua作为配置的优势还在于它拥有计算的能力，比如：

我可以在lua脚本里写一个复杂的公式，以此公式来计算一些血量值。

{% highlight lua %}

function f(var)
    return var * var + 2 * var + 100
end

blood1 = f(10)
blood2 = f(20)
blood3 = f(30)

-- .......

{% endhighlight %}

在C++中读取：

{% highlight c++ %}
int main() {

    // 同上面的代码，省略...

    lua_pop(lua, 2);        // 弹出第一个例子中的两个值：blood和monster_type

    lua_getglobal(lua, "blood1");
    lua_getglobal(lua, "blood2");
    lua_getglobal(lua, "blood3");

    double blood1, blood2, blood3;

    psln(blood1 = lua_tonumber(lua, 1));
    psln(blood2 = lua_tonumber(lua, 2));
    psln(blood3 = lua_tonumber(lua, 3));

    lua_close(lua);

    return 0;
}
{% endhighlight %}

**输出：**

{% highlight c++ %}
blood1 = lua_tonumber(lua, 1) = 220
blood2 = lua_tonumber(lua, 2) = 540
blood3 = lua_tonumber(lua, 3) = 1060
{% endhighlight %}

可以看到，这仅仅是用了lua本身的语法，还没用lua库功能情况下就已经比普通意义上的配置文件牛很多了。(想了想，其实别的编程语言不也是一种配置文件吗，他们是编译器（或解释器）才能解释的配置)

除了上面两个例子读取lua全局变量，lua中的table也很容易被C++读取：

我在lua里添加了一个table,

{% highlight lua %}
info = {
    blood        = 99.9,
    monster_type = "Ghost"
}
{% endhighlight %}

现在要在C++中读取这个table里的两个字段：

{% highlight c++ %}
int main() {

    // 略去代码同上第二个例子......

    lua_pop(lua, 3);    // 弹出 blood1, blood2, blood3

    lua_getglobal(lua, "info");     // 获取table

    lua_pushstring(lua, "blood");   // 第一种读table的方法，先压入key
    lua_gettable(lua, -2);           // 获取key对应的value，-2代表table在栈中的索引, 现在-1位置的元素是刚刚压入的key("blood"), 获取value之后，key会自动弹出栈。

    double tableBlood;
    psln(tableBlood = lua_tonumber(lua, -1));       // 打印获取的blood字段

    lua_pop(lua, 1);                                // 弹出blood这个值, 现在栈里只剩下栈顶的table

    lua_getfield(lua, -1, "monster_type");      // 第二种获取table字段的方法，在Lua 5.1中存在，针对字符串类型key的一个特化方法, -1同样是table在栈中的索引。

    const char* tableMonster;
    psln(tableMonster = lua_tostring(lua, -1));     // 打印出获取的table的monster_type字段

    lua_close(lua);

    return 0;
}
{% endhighlight %}

**输出：**

{% highlight c++ %}
tableBlood = lua_tonumber(lua, -1) = 99.9
tableMonster = lua_tostring(lua, -1) = Ghost
{% endhighlight %}

# 总结

好了，先说这么多，这篇演示了如何从C++加载lua脚本，并读取变量和表。

| *API*                                                            | *功能*                                                                             |
| -------                                                          | -------                                                                            |
| `lua_getglobal(lua_State* lua, const char* key)`                 | 获取key对应的全局变量，它其实是一个宏，详见lua.h                                   |
| `lua_gettable(lua_State* lua, int table_index)`                  | 获取table的一个字段，需通过`table_index`指明table在栈中的索引, key需要提前压入栈中 |
| `lua_getfield(lua_State* lua, int table_index, const char* key)` | 获取table key对应的value, 需通过`table_index`指明table在栈中的索引                 |

以上三个API操作的结果都会被压入栈中，而不是由函数返回。

下一篇文章总结一下如何从C++调用lua的函数。

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



