---
layout: post
title: Thinking-2015-6-8
category: diary
tags: [todo, question, summary]
---

##questions

##summary
用非winrt程序调用(采用链接器加载或者是#pragma comment(lib, "xx.lib")) winrt下编译的dll库时，会报这个错误。

原因就是

Error 0xc000a200 shows up when regular process (not inside an AppContainer) tries to load DLL that was marked with AppContainer flag。

解决办法就是：

dll库文件编译时，在链接器的命令行设置/APPCONTAINER:NO（ setting APPCONTAINER:NO in the comand line (under linker)）。

##todo

