---
layout: post
title: "【Programming In Lua (2E) 笔记】5：使用C++为Lua编写扩展库（macOS上两种动态库格式的坑）"
category: lua
tags: [lua]
description: ""
published: true
---

**ps: 2016年6月的WWDC上，Mac操作系统正式更名为macOS, 与iOS, watchOS, tvOS的命名风格终于统一了。**

# 前言

本文记录了在macOS上使用c++为lua编写动态库的过程，分享一个容易翻车的坑。

Lua Version: 5.1

# 问题描述

在PIL第26章：《从Lua调用C》，介绍了从lua调用C程序的方法，即扩展lua, 用c++来为lua编写扩展库。

文中提到了扩展lua的两种方式：

- 把c++代码编译为为动态库，使用lua的动态链接功能来加载c++的模块（即，require "cpplib"的方式, 这里cpplib为一个例子，比如我编译为libcpplib.so, 就需要像这样来加载这个动态库。）

- 把编写好的c++模块加入到lua源码，重新编译lua可执行程序，这样c++模块就成为了lua的一部分（类似lua标准库string，math等等）

第二种方式--重新编译lua很简单，按照书中所说，把写好的c++模块注册函数`luaopen_mylib`添加到`luaL_openlibs`会打开的标准库列表里。(在linit.c中) 

经过我在mac上的实践，第二种方式顺利搞定。毕竟lua源码中的README和INSTALL文档已经把编译lua讲的很明白了。

至于这第一种方式，别看书里一笔带过，这实践起来还真是。。。。。。 一言不合就翻车了。

<!--more-->

原文是说：

>当写完C模块后，必须将其链接到解释器。如果Lua解释器支持动态链接的话，那么最简便的方法是使用动态链接机制。在这种情况下，必须将C代码编译成动态链接库，并将这个库放入C路径中。然后，便可以用require从Lua中加载这个模块：`require "mylib"`，这句调用将会将动态库myilb链接到Lua，并会寻找`luaopen_mylib`函数，将其注册为一个Lua函数，然后调用它以打开模块。

总结起来就是两步：

**第一步，按照Lua调用c++的协议编写好c++模块。**

**第二步，把这个模块编译成动态库，在lua中require一下，就ok了。**

我遇到的问题都集中在编译动态库这一步，

<font color="red">**第一个问题：动态库的生成，需要链接liblua吗？**</font>

<font color="red">**第二个问题：在lua中require的时候，会报错：`file is not a bundle`.**</font>

# 问题重现

我遇到这个问题的时候还是在两个月前，现在回想这个问题印象已经不是很深了，不靠谱的程序员就是这样吧，脑子里一天不知道都装些什么，解决过的问题往脑袋后面一抛又去搞别的，再碰到类似的问题就会把自己当初解决问题相关的记录翻个底朝天，像个侦探一样回想着当初案件发生时候留下的蛛丝马迹，为的就是灵机一动，回想起当时的问题和解决办法，然而好运并不常常有。我以前经常犯这种错误，不过现在我靠谱多了，翻看一下自己的github提交日志，居然把问题和解决方案都记录下来了，并且留下了一个可以重现问题最简单的demo，这一次给自己点个赞 (～ o ～)~zZ

c++之父BS曾经分享过一个解决问题的技巧，大意是说“简化问题的环境，剥去问题的层层外衣，把最简单、最本质的问题暴露出来”。

下面这两段代码给出了这个问题的最简单的模型：

目录结构：

{% highlight c++ %}
.
├── Makefile
├── hello.lua
└── test.cpp
{% endhighlight %}

**test.cpp: 定义了一个c++模块，叫test，里面有个add方法会在参数上加10然后返回，这个模块注册到lua中的名字也叫test。**

{% highlight c++ %}
#include "lua_51/lua.hpp"       // lua.hpp 包含了lua.h, lualib.h, lauxlib.h 他们提供了lua基本类型和api的声明

int l_add(lua_State* lua) {
    int i = luaL_checknumber(lua, 1);
    lua_pushnumber(lua, i+10);
    return 1;
}

static const luaL_reg testlib[] = {
    {"add", l_add},
    {NULL, NULL}
};

extern "C" int luaopen_test(lua_State* lua) {
    luaL_register(lua, "test", testlib);
    return 1;
}
{% endhighlight %}

**hello.lua: 测试c++模块test的脚本文件，require test这个模块，并调用其add方法**

{% highlight lua %}
require "test"         -- 加载test.so动态库

print(test.add(2))     -- 以1为参数调用add, 将返回（10+2）即：12
{% endhighlight %}

为了编译动态库的操作方便，添加了一个Makefile:

{% highlight bash %}
CXX       = clang++     # macOS上xcode工具链里的默认c++编译器
INCLUDE   = -I../       # 上一层目录就是lua_51所在目录，对应test.cpp中的#include。

FLAGS     = -fpic       # position independent code, 编译动态库通常都指定这个选项，
                        # 意思是跟位置无关的代码，即不管动态库被加载到内存的哪个位置，代码都能正常工作

LIBOPTS   = -shared     # 编译动态库

LINK_LIBS = -llua       # 链接的库

test.so: test.o
	$(CXX) $(LIBOPTS) $(FLAGS) $(LINK_LIBS) -o $@ $^

test.o : test.cpp
	$(CXX) $(INCLUDE) -c $^

.PHONY : clean
clean:
		-rm *.so *.o
{% endhighlight %}

好了，添加了这三个文件之后就可以开始操作了，第一步，把test.cpp编译成一个动态库

这是c++的基本功了，不必赘述，直接在当前目录下执行：make

输出：

{% highlight c++ %}
lang++ -I../ -c test.cpp
clang++ -shared -fpic  -llua -o test.so test.o
{% endhighlight %}

查看目录：

{% highlight c++ %}
── Makefile
├── hello.lua
├── test.cpp
├── test.o
└── test.so
{% endhighlight %}

可以看到已经成功生成了test.so, 此时我想确认一下这个动态库里有哪些符号，是否有`luaopen_test`这个符号暴露出来，以便require的时候可以调用到。

输入：`nm -gm test.so`

{% highlight c++ %}
(undefined) external __DefaultRuneLocale (from libSystem)
0000000000016d10 (__TEXT,__text) external __Z5l_addP9lua_State
                 (undefined) external ___bzero (from libSystem)
                 (undefined) external ___error (from libSystem)
                 (undefined) external ___maskrune (from libSystem)
                 (undefined) external ___sprintf_chk (from libSystem)
                 (undefined) external ___stack_chk_fail (from libSystem)
                 (undefined) external ___stack_chk_guard (from libSystem)
                 (undefined) external ___stderrp (from libSystem)
                 (undefined) external ___stdinp (from libSystem)
                 (undefined) external ___strcat_chk (from libSystem)
                 (undefined) external ___strncat_chk (from libSystem)
                 (undefined) external __longjmp (from libSystem)
                 (undefined) external __setjmp (from libSystem)
                 (undefined) external _exit (from libSystem)
                 (undefined) external _fclose (from libSystem)
                 (undefined) external _feof (from libSystem)
                 (undefined) external _ferror (from libSystem)
                 (undefined) external _floor (from libSystem)
                 (undefined) external _fopen (from libSystem)
                 (undefined) external _fprintf (from libSystem)
                 (undefined) external _fread (from libSystem)
                 (undefined) external _free (from libSystem)
                 (undefined) external _getc (from libSystem)
                 (undefined) external _localeconv (from libSystem)
00000000000005e0 (__TEXT,__text) external _luaA_pushobject
000000000000a300 (__TEXT,__text) external _luaC_barrierback
000000000000a1e0 (__TEXT,__text) external _luaC_barrierf
0000000000009850 (__TEXT,__text) external _luaC_callGCTM
0000000000009960 (__TEXT,__text) external _luaC_freeall
000000000000a0a0 (__TEXT,__text) external _luaC_fullgc
000000000000a320 (__TEXT,__text) external _luaC_link
000000000000a340 (__TEXT,__text) external _luaC_linkupval
0000000000009730 (__TEXT,__text) external _luaC_separateudata
0000000000009b60 (__TEXT,__text) external _luaC_step
0000000000008580 (__TEXT,__text) external _luaD_call
0000000000007bf0 (__TEXT,__text) external _luaD_callhook
0000000000007bd0 (__TEXT,__text) external _luaD_growstack
0000000000008890 (__TEXT,__text) external _luaD_pcall
0000000000008470 (__TEXT,__text) external _luaD_poscall
0000000000007cf0 (__TEXT,__text) external _luaD_precall
0000000000008a30 (__TEXT,__text) external _luaD_protectedparser
00000000000079e0 (__TEXT,__text) external _luaD_rawrunprotected
0000000000007b50 (__TEXT,__text) external _luaD_reallocCI
0000000000007a60 (__TEXT,__text) external _luaD_reallocstack
0000000000007800 (__TEXT,__text) external _luaD_seterrorobj
0000000000007870 (__TEXT,__text) external _luaD_throw
0000000000010380 (__TEXT,__text) external _luaE_freethread
0000000000010210 (__TEXT,__text) external _luaE_newthread
0000000000009480 (__TEXT,__text) external _luaF_close
0000000000009390 (__TEXT,__text) external _luaF_findupval
00000000000096b0 (__TEXT,__text) external _luaF_freeclosure
0000000000009600 (__TEXT,__text) external _luaF_freeproto
0000000000009450 (__TEXT,__text) external _luaF_freeupval
00000000000096e0 (__TEXT,__text) external _luaF_getlocalname
0000000000009250 (__TEXT,__text) external _luaF_newCclosure
00000000000092b0 (__TEXT,__text) external _luaF_newLclosure
0000000000009560 (__TEXT,__text) external _luaF_newproto
0000000000009340 (__TEXT,__text) external _luaF_newupval
00000000000076b0 (__TEXT,__text) external _luaG_aritherror
0000000000006c40 (__TEXT,__text) external _luaG_checkcode
0000000000006c10 (__TEXT,__text) external _luaG_checkopenop
0000000000007690 (__TEXT,__text) external _luaG_concaterror
0000000000007750 (__TEXT,__text) external _luaG_errormsg
0000000000007700 (__TEXT,__text) external _luaG_ordererror
0000000000007510 (__TEXT,__text) external _luaG_runerror
0000000000007260 (__TEXT,__text) external _luaG_typeerror
0000000000011300 (__TEXT,__text) external _luaH_free
0000000000011450 (__TEXT,__text) external _luaH_get
0000000000011c00 (__TEXT,__text) external _luaH_getn
0000000000011370 (__TEXT,__text) external _luaH_getnum
0000000000011400 (__TEXT,__text) external _luaH_getstr
00000000000110e0 (__TEXT,__text) external _luaH_new
0000000000010b60 (__TEXT,__text) external _luaH_next
0000000000010d10 (__TEXT,__text) external _luaH_resizearray
0000000000011640 (__TEXT,__text) external _luaH_set
0000000000011ae0 (__TEXT,__text) external _luaH_setnum
0000000000011b90 (__TEXT,__text) external _luaH_setstr
00000000000041c0 (__TEXT,__text) external _luaK_checkstack
0000000000003d40 (__TEXT,__text) external _luaK_codeABC
0000000000003e40 (__TEXT,__text) external _luaK_codeABx
0000000000003e60 (__TEXT,__text) external _luaK_concat
0000000000004580 (__TEXT,__text) external _luaK_dischargevars
0000000000004d90 (__TEXT,__text) external _luaK_exp2RK
0000000000004cb0 (__TEXT,__text) external _luaK_exp2anyreg
0000000000004690 (__TEXT,__text) external _luaK_exp2nextreg
0000000000004d10 (__TEXT,__text) external _luaK_exp2val
00000000000060b0 (__TEXT,__text) external _luaK_fixline
0000000000003f30 (__TEXT,__text) external _luaK_getlabel
0000000000005160 (__TEXT,__text) external _luaK_goiftrue
0000000000005470 (__TEXT,__text) external _luaK_indexed
0000000000005a40 (__TEXT,__text) external _luaK_infix
0000000000003d70 (__TEXT,__text) external _luaK_jump
0000000000003c90 (__TEXT,__text) external _luaK_nil
0000000000004430 (__TEXT,__text) external _luaK_numberK
0000000000003f40 (__TEXT,__text) external _luaK_patchlist
0000000000004120 (__TEXT,__text) external _luaK_patchtohere
0000000000005ca0 (__TEXT,__text) external _luaK_posfix
00000000000054a0 (__TEXT,__text) external _luaK_prefix
0000000000004200 (__TEXT,__text) external _luaK_reserveregs
0000000000003f00 (__TEXT,__text) external _luaK_ret
0000000000005030 (__TEXT,__text) external _luaK_self
00000000000062c0 (__TEXT,__text) external _luaK_setlist
0000000000004520 (__TEXT,__text) external _luaK_setoneret
0000000000004460 (__TEXT,__text) external _luaK_setreturns
0000000000004ea0 (__TEXT,__text) external _luaK_storevar
0000000000004260 (__TEXT,__text) external _luaK_stringK
0000000000016420 (__TEXT,__text) external _luaL_addlstring
0000000000016480 (__TEXT,__text) external _luaL_addstring
0000000000016640 (__TEXT,__text) external _luaL_addvalue
0000000000015570 (__TEXT,__text) external _luaL_argerror
0000000000016400 (__TEXT,__text) external _luaL_buffinit
0000000000015e80 (__TEXT,__text) external _luaL_callmeta
0000000000015c10 (__TEXT,__text) external _luaL_checkany
0000000000015d30 (__TEXT,__text) external _luaL_checkinteger
00000000000159b0 (__TEXT,__text) external _luaL_checklstring
0000000000015c50 (__TEXT,__text) external _luaL_checknumber
00000000000158a0 (__TEXT,__text) external _luaL_checkoption
0000000000015b50 (__TEXT,__text) external _luaL_checkstack
0000000000015b90 (__TEXT,__text) external _luaL_checktype
0000000000015aa0 (__TEXT,__text) external _luaL_checkudata
0000000000015660 (__TEXT,__text) external _luaL_error
0000000000016080 (__TEXT,__text) external _luaL_findtable
0000000000015e00 (__TEXT,__text) external _luaL_getmetafield
00000000000161c0 (__TEXT,__text) external _luaL_gsub
0000000000016be0 (__TEXT,__text) external _luaL_loadbuffer
00000000000168b0 (__TEXT,__text) external _luaL_loadfile
0000000000016c30 (__TEXT,__text) external _luaL_loadstring
0000000000015a30 (__TEXT,__text) external _luaL_newmetatable
0000000000016c70 (__TEXT,__text) external _luaL_newstate
0000000000015f00 (__TEXT,__text) external _luaL_openlib
0000000000015dc0 (__TEXT,__text) external _luaL_optinteger
0000000000015950 (__TEXT,__text) external _luaL_optlstring
0000000000015cf0 (__TEXT,__text) external _luaL_optnumber
0000000000016550 (__TEXT,__text) external _luaL_prepbuffer
00000000000164f0 (__TEXT,__text) external _luaL_pushresult
0000000000016770 (__TEXT,__text) external _luaL_ref
0000000000015ef0 (__TEXT,__text) external _luaL_register
00000000000157b0 (__TEXT,__text) external _luaL_typerror
0000000000016830 (__TEXT,__text) external _luaL_unref
0000000000015810 (__TEXT,__text) external _luaL_where
000000000000c3e0 (__TEXT,__text) external _luaM_growaux_
000000000000c4d0 (__TEXT,__text) external _luaM_realloc_
000000000000c530 (__TEXT,__text) external _luaM_toobig
000000000000cbd0 (__TEXT,__text) external _luaO_chunkid
000000000000c590 (__TEXT,__text) external _luaO_fb2int
000000000000c550 (__TEXT,__text) external _luaO_int2fb
000000000000c5b0 (__TEXT,__text) external _luaO_log2
0000000000017ae0 (__TEXT,__const) external _luaO_nilobject_
000000000000cb20 (__TEXT,__text) external _luaO_pushfstring
000000000000c740 (__TEXT,__text) external _luaO_pushvfstring
000000000000c600 (__TEXT,__text) external _luaO_rawequalObj
000000000000c660 (__TEXT,__text) external _luaO_str2d
0000000000017bf0 (__TEXT,__const) external _luaP_opmodes
0000000000018260 (__DATA,__const) external _luaP_opnames
0000000000010980 (__TEXT,__text) external _luaS_newlstr
0000000000010af0 (__TEXT,__text) external _luaS_newudata
0000000000010890 (__TEXT,__text) external _luaS_resize
0000000000011f20 (__TEXT,__text) external _luaT_gettm
0000000000011f60 (__TEXT,__text) external _luaT_gettmbyobj
0000000000011eb0 (__TEXT,__text) external _luaT_init
00000000000183a0 (__DATA,__const) external _luaT_typenames
0000000000008b80 (__TEXT,__text) external _luaU_dump
0000000000012e80 (__TEXT,__text) external _luaU_header
0000000000011fb0 (__TEXT,__text) external _luaU_undump
0000000000013840 (__TEXT,__text) external _luaV_concat
0000000000013630 (__TEXT,__text) external _luaV_equalval
0000000000013c70 (__TEXT,__text) external _luaV_execute
0000000000013050 (__TEXT,__text) external _luaV_gettable
0000000000013400 (__TEXT,__text) external _luaV_lessthan
0000000000013210 (__TEXT,__text) external _luaV_settable
0000000000012f70 (__TEXT,__text) external _luaV_tonumber
0000000000012fc0 (__TEXT,__text) external _luaV_tostring
000000000000ab60 (__TEXT,__text) external _luaX_init
000000000000ac50 (__TEXT,__text) external _luaX_lexerror
000000000000baa0 (__TEXT,__text) external _luaX_lookahead
000000000000ada0 (__TEXT,__text) external _luaX_newstring
000000000000ae80 (__TEXT,__text) external _luaX_next
000000000000adf0 (__TEXT,__text) external _luaX_setinput
000000000000ad90 (__TEXT,__text) external _luaX_syntaxerror
000000000000abd0 (__TEXT,__text) external _luaX_token2str
0000000000018160 (__DATA,__const) external _luaX_tokens
000000000000ccf0 (__TEXT,__text) external _luaY_parser
0000000000015370 (__TEXT,__text) external _luaZ_fill
0000000000015410 (__TEXT,__text) external _luaZ_init
00000000000153c0 (__TEXT,__text) external _luaZ_lookahead
0000000000015510 (__TEXT,__text) external _luaZ_openspace
0000000000015440 (__TEXT,__text) external _luaZ_read
0000000000000760 (__TEXT,__text) external _lua_atpanic
0000000000003380 (__TEXT,__text) external _lua_call
0000000000000600 (__TEXT,__text) external _lua_checkstack
0000000000010800 (__TEXT,__text) external _lua_close
00000000000038b0 (__TEXT,__text) external _lua_concat
0000000000003530 (__TEXT,__text) external _lua_cpcall
00000000000029b0 (__TEXT,__text) external _lua_createtable
0000000000003650 (__TEXT,__text) external _lua_dump
0000000000001380 (__TEXT,__text) external _lua_equal
00000000000037a0 (__TEXT,__text) external _lua_error
00000000000036a0 (__TEXT,__text) external _lua_gc
0000000000003930 (__TEXT,__text) external _lua_getallocf
0000000000002b20 (__TEXT,__text) external _lua_getfenv
0000000000002690 (__TEXT,__text) external _lua_getfield
00000000000064d0 (__TEXT,__text) external _lua_gethook
00000000000064f0 (__TEXT,__text) external _lua_gethookcount
00000000000064e0 (__TEXT,__text) external _lua_gethookmask
0000000000006730 (__TEXT,__text) external _lua_getinfo
0000000000006560 (__TEXT,__text) external _lua_getlocal
0000000000002a10 (__TEXT,__text) external _lua_getmetatable
0000000000006500 (__TEXT,__text) external _lua_getstack
00000000000025b0 (__TEXT,__text) external _lua_gettable
00000000000007d0 (__TEXT,__text) external _lua_gettop
00000000000039e0 (__TEXT,__text) external _lua_getupvalue
0000000000017a30 (__TEXT,__const) external _lua_ident
00000000000009f0 (__TEXT,__text) external _lua_insert
0000000000000e30 (__TEXT,__text) external _lua_iscfunction
0000000000000f20 (__TEXT,__text) external _lua_isnumber
0000000000001020 (__TEXT,__text) external _lua_isstring
0000000000001100 (__TEXT,__text) external _lua_isuserdata
0000000000001530 (__TEXT,__text) external _lua_lessthan
0000000000003600 (__TEXT,__text) external _lua_load
00000000000103e0 (__TEXT,__text) external _lua_newstate
0000000000000780 (__TEXT,__text) external _lua_newthread
0000000000003970 (__TEXT,__text) external _lua_newuserdata
00000000000037b0 (__TEXT,__text) external _lua_next
0000000000001bc0 (__TEXT,__text) external _lua_objlen
00000000000033d0 (__TEXT,__text) external _lua_pcall
0000000000002530 (__TEXT,__text) external _lua_pushboolean
0000000000002410 (__TEXT,__text) external _lua_pushcclosure
0000000000002340 (__TEXT,__text) external _lua_pushfstring
00000000000021e0 (__TEXT,__text) external _lua_pushinteger
0000000000002560 (__TEXT,__text) external _lua_pushlightuserdata
0000000000002210 (__TEXT,__text) external _lua_pushlstring
00000000000021a0 (__TEXT,__text) external _lua_pushnil
00000000000021c0 (__TEXT,__text) external _lua_pushnumber
0000000000002270 (__TEXT,__text) external _lua_pushstring
0000000000002580 (__TEXT,__text) external _lua_pushthread
0000000000000c40 (__TEXT,__text) external _lua_pushvalue
00000000000022f0 (__TEXT,__text) external _lua_pushvfstring
00000000000011e0 (__TEXT,__text) external _lua_rawequal
00000000000027b0 (__TEXT,__text) external _lua_rawget
00000000000028b0 (__TEXT,__text) external _lua_rawgeti
0000000000002e60 (__TEXT,__text) external _lua_rawset
0000000000002f90 (__TEXT,__text) external _lua_rawseti
00000000000008e0 (__TEXT,__text) external _lua_remove
0000000000000af0 (__TEXT,__text) external _lua_replace
0000000000008620 (__TEXT,__text) external _lua_resume
0000000000003950 (__TEXT,__text) external _lua_setallocf
0000000000003220 (__TEXT,__text) external _lua_setfenv
0000000000002d40 (__TEXT,__text) external _lua_setfield
0000000000006490 (__TEXT,__text) external _lua_sethook
0000000000006640 (__TEXT,__text) external _lua_setlocal
00000000000030c0 (__TEXT,__text) external _lua_setmetatable
0000000000002c50 (__TEXT,__text) external _lua_settable
00000000000007f0 (__TEXT,__text) external _lua_settop
0000000000003b20 (__TEXT,__text) external _lua_setupvalue
0000000000003690 (__TEXT,__text) external _lua_status
00000000000018d0 (__TEXT,__text) external _lua_toboolean
0000000000001cf0 (__TEXT,__text) external _lua_tocfunction
00000000000017d0 (__TEXT,__text) external _lua_tointeger
00000000000019c0 (__TEXT,__text) external _lua_tolstring
00000000000016d0 (__TEXT,__text) external _lua_tonumber
0000000000001fb0 (__TEXT,__text) external _lua_topointer
0000000000001ed0 (__TEXT,__text) external _lua_tothread
0000000000001de0 (__TEXT,__text) external _lua_touserdata
0000000000000d20 (__TEXT,__text) external _lua_type
0000000000000e00 (__TEXT,__text) external _lua_typename
0000000000000670 (__TEXT,__text) external _lua_xmove
0000000000008840 (__TEXT,__text) external _lua_yield
0000000000016d50 (__TEXT,__text) external _luaopen_test
                 (undefined) external _memchr (from libSystem)
                 (undefined) external _memcmp (from libSystem)
                 (undefined) external _memcpy (from libSystem)
                 (undefined) external _pow (from libSystem)
                 (undefined) external _realloc (from libSystem)
                 (undefined) external _strchr (from libSystem)
                 (undefined) external _strcmp (from libSystem)
                 (undefined) external _strcoll (from libSystem)
                 (undefined) external _strcspn (from libSystem)
                 (undefined) external _strerror (from libSystem)
                 (undefined) external _strlen (from libSystem)
                 (undefined) external _strncpy (from libSystem)
                 (undefined) external _strstr (from libSystem)
                 (undefined) external _strtod (from libSystem)
                 (undefined) external _strtoul (from libSystem)
                 (undefined) external _ungetc (from libSystem)
                 (undefined) external dyld_stub_binder (from libSystem)
{% endhighlight %}

是否有些吃惊，这个so里居然导出了这么多的符号，在最后一个000000...开头的符号里，我看到了`_luaopen_test`这个符号，虽然包含进去了但是这么多额外的符号是没必要的，它们都是liblua里面导进来的。为了不要这些没用的符号，我有两个办法，或者是指定`__attribute__((visibility("hidden")))`来关闭lua中导出的符号，或者是不链接liblua。第一种方法要修改lua源码中的宏定义部分，重新编译lua。第二中，不链接lua是否可行呢？

试一下，去掉Makefile中的`LINK_LIBS`, 即修改Makefile中: `LINK_LIBS = ""`, 执行：`make clean && make`:

{% highlight c++ %}
clang++ -I../ -c test.cpp
clang++ -shared -fpic   -o test.so test.o
Undefined symbols for architecture x86_64:
  "_luaL_checknumber", referenced from:
      l_add(lua_State*) in test.o
  "_luaL_register", referenced from:
      _luaopen_test in test.o
  "_lua_pushnumber", referenced from:
      l_add(lua_State*) in test.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [test.so] Error 1
{% endhighlight %}

预料之中，test.cpp中用到的几个lua api未找到符号定义。google了一下动态库构建和Undefined symbols, 发现加上 `-undefined dynamic_lookup`这个选项就不会报错了，于是Makefile再次修改一下，在 FLAGS 上添加： `FLAGS     += -undefined dynamic_lookup`, 再次执行make:

{% highlight c++ %}
clang++ -I../ -c test.cpp
clang++ -shared -fpic  -undefined dynamic_lookup  -o test.so test.o
{% endhighlight %}

生成成功，查看test.so导出的符号, `nm -gm test.so`:

{% highlight c++ %}
0000000000000ef0 (__TEXT,__text) external __Z5l_addP9lua_State
                 (undefined) external _luaL_checknumber (dynamically looked up)
                 (undefined) external _luaL_register (dynamically looked up)
                 (undefined) external _lua_pushnumber (dynamically looked up)
0000000000000f30 (__TEXT,__text) external _luaopen_test
                 (undefined) external dyld_stub_binder (from libSystem)
{% endhighlight %}

这次可以看到，导出的有效符号仅有test.cpp中定义的两个函数，`_luaopen_test`和`__Z5l_addP9lua_State`(add函数) 的符号.

OK, 到这里我看起来已经解决了第一个问题（生成动态库）。 下面进行第二步，在lua中require这个test.so, 在当前路径执行：`lua hello.lua`

输出：

{% highlight c++ %}
lua: error loading module 'test' from file './test.so':
	file is not a bundle
stack traceback:
	[C]: ?
	[C]: in function 'require'
	hello.lua:1: in main chunk
	[C]: ?
{% endhighlight %}

额，就是这个file is not a bundle的错误折腾了我好久，google和stackoverflow了好久，最后还是在6.12号我过生日那天把它搞定了。

当时很好奇为什么出现了bundle这个奇怪的词？为什么我的test.so要是个bundle，google了好久都没有头绪，不如去lua源码里瞧瞧，看哪里报了这个错, 在loadlib.c中看到了这个错误，

{% highlight c++ %}
static const char *errorfromcode (NSObjectFileImageReturnCode ret) {
  switch (ret) {
    case NSObjectFileImageInappropriateFile:
      return "file is not a bundle";
    case NSObjectFileImageArch:
      return "library is for wrong CPU type";
    case NSObjectFileImageFormat:
      return "bad format";
    case NSObjectFileImageAccess:
      return "cannot access file";
    case NSObjectFileImageFailure:
    default:
      return "unable to load library";
  }
}
{% endhighlight %}

在Xcode中跑起调试，按照调用堆栈，再往下一层，看到了是在`ll_load`之中，加载test.so时候, 调用`NSCreateObjectFileImageFromFile`失败。

{% highlight c++ %}
static void *ll_load (lua_State *L, const char *path) {
  NSObjectFileImage img;
  NSObjectFileImageReturnCode ret;
  /* this would be a rare case, but prevents crashing if it happens */
  if(!_dyld_present()) {
    lua_pushliteral(L, "dyld not present");
    return NULL;
  }
  ret = NSCreateObjectFileImageFromFile(path, &img);
  if (ret == NSObjectFileImageSuccess) {
    NSModule mod = NSLinkModule(img, path, NSLINKMODULE_OPTION_PRIVATE |
                       NSLINKMODULE_OPTION_RETURN_ON_ERROR);
    NSDestroyObjectFileImage(img);
    if (mod == NULL) pusherror(L);
    return mod;
  }
  lua_pushstring(L, errorfromcode(ret));
  return NULL;
}
{% endhighlight %}

于是到Apple Developer网站搜索这个 `NSCreateObjectFileImageFromFile`函数，答案就在这个函数的说明里：

[NSCreateObjectFileImageFromFile](https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/MachOReference/#//apple_ref/c/func/NSCreateObjectFileImageFromFile)

>Given a pathname to a Mach-O executable, this function creates and returns a NSObjectFileImage reference. The current implementation works only with bundles, so you must build the Mach-O executable file using the -bundle linker option

意思是，要求是Mach-O类型的可执行文件才行，并提示我，构建这种类型的动态库要使用`-bundle`这个选项。

于是，再次修改Makefile, 把LIBOPTS从`-shared`改为`-bundle`, 最终的Makefile:


{% highlight bash %}
CXX       = clang++     # macOS上xcode工具链里的默认c++编译器
INCLUDE   = -I../       # 上一层目录就是lua_51所在目录，对应test.cpp中的#include。

FLAGS     = -fpic       # position independent code, 编译动态库通常都指定这个选项，
                        # 意思是跟位置无关的代码，即不管动态库被加载到内存的哪个位置，代码都能正常工作

FLAGS     += -undefined dynamic_lookup  # ignore undefined symbols error. 

LIBOPTS   = -bundle     # 编译Mach-O类型的动态库，即所谓的"bundle"

#LINK_LIBS = -llua       # 不需要链接liblua库

test.so: test.o
	$(CXX) $(LIBOPTS) $(FLAGS) $(LINK_LIBS) -o $@ $^

test.o : test.cpp
	$(CXX) $(INCLUDE) -c $^

.PHONY : clean
clean:
		-rm *.so *.o
{% endhighlight %}

OK, 感觉马上要成功了，再次执行：`make clean && make`:

{% highlight c++ %}
rm *.so *.o
clang++ -I../ -c test.cpp
clang++ -bundle -fpic  -undefined dynamic_lookup  -o test.so test.o
{% endhighlight %}

可以看到，成功生成了test.so, 并且选项里确实是用的-bundle。我如何确定这个test.so是Mach-O类型的库呢？这个问题就很好搜了，结论是：

`otool -hv test.so`

输出：

{% highlight c++ %}
test.so:
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00      BUNDLE    13       1200   NOUNDEFS DYLDLINK TWOLEVEL
{% endhighlight %}

看到了filetype那一列，写着：BUNDLE, 恩，这时候想起了file is not a bunle这个提示是多么的直白呀。。。。读书太少就是吃亏。

现在，再运行lua脚本，`lua hello.lua`:

{% highlight c++ %}
12
{% endhighlight %}

OK，终于不报错了, 结果也是对的。至此所有的坑都讲完了。


# 总结

- 使用`-undefined dynamic_lookup`选项来去除动态库构建时候的Undefined symbols 错误

- 使用`-bundle` 选项来指定构建Mach-O type的动态库

我对之前使用-shared选项构建的test.so使用otool来查看其类型, 输出如下：

{% highlight c++ %}
test.so:
Mach header
      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags
MH_MAGIC_64  X86_64        ALL  0x00       DYLIB    14       1232   NOUNDEFS DYLDLINK TWOLEVEL NO_REEXPORTED_DYLIBS
{% endhighlight %}

它的类型是DYLIB, 结合着官方的开发者文档，可以总结出来：

- Mac OS 上的两种动态库格式: `BUNDLE` 和 `DYLIB`, 分别使用`-bundle`和`-shared`选项构建而成。


<font color="red">**==============================下面是彩蛋时间==============================**</font>


# 在CMake里解决上述问题

由于我的项目是用CMake组织起来的，因此刚才解决的两个问题还不是我遇到问题的全部，我要想办法在CMake脚本里指定动态库的构建类型为bundle，经过我的google结果总结和测试，直接贴出脚本了，看注释就可以知道结论啦 O(∩-∩)O~

{% highlight c++ %}
# 省略了一些脚本，这个项目是把lua源码集成在了c++之中，因此会控制lua的构建过程，下面是为lua开始动态链接特性
if (APPLE)
    message("platform: OS X")
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
    add_definitions( -DLUA_USE_MACOSX )     # enable dynamic linking for lua.
endif(APPLE)

# 我的c++动态库取名叫：ellua
set(LUA_SO_NAME ellua)

# 源代码只有一个文件：lua_so.cpp, 不要把lua也链接进去，否则会弄出冗余的符号，
# 并且在执行lua脚本(里面调用了listdir函数)之后会报下面提到的那个'pointer being freed was not allocated'的错误
set(LUA_SO_SRC
    src/lua_so.cpp

    # DO NOT link with liblua.a when building shared object. Fix "pointer being freed was not allocated" error
    # ${LUA_SRC}    
)

# 指定忽略Undefined symbols 错误，同Makefile一样
set(IGNORE_UNDEFINED_SYMBOLS ${CMAKE_CXX_FLAGS}  " -undefined dynamic_lookup")
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${IGNORE_UNDEFINED_SYMBOLS}")

# 关键在这里
if (APPLE)
    add_library(${LUA_SO_NAME} MODULE ${LUA_SO_SRC})        # a bunlde on mac os, Mach-o type的动态库，即BUNDLE
else (APPLE)
    add_library(${LUA_SO_NAME} SHARED ${LUA_SO_SRC})        # will be a dylib on mac. 即DYLIB
endif(APPLE)
{% endhighlight %}

# 参考链接

- [Dynamic Library Programming Topics-动态库变成主题](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/DynamicLibraries/000-Introduction/Introduction.html#//apple_ref/doc/uid/TP40001869)

- [OS X ABI Dynamic Loader Reference-macOS ABI动态库加载参考](https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/MachOReference/index.html#//apple_ref/doc/uid/TP40001398)

- [作者的`lua_in_cpp`项目的CMakeLists脚本](https://github.com/elloop/lua_in_cpp/blob/master/CMakeLists.txt)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

