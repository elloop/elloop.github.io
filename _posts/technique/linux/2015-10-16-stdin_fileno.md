---
layout: post
title: "STD*_FILENO与stdin的区别"
highlighter_style: monokai
category: linux
tags: [linux]
description: ""
---

##从数据类型上看

- stdin等类型为FILE*。

- STDIN_FILENO等类型为unsigned int, 它们是一组文件描述符。
    见/usr/include/unistd.h

    ```c
    /* Standard file descriptors. */
    #define STDIN_FILENO 0 /* Standard input. */
    #define STDOUT_FILENO 1 /* Standard output. */
    #define STDERR_FILENO 2 /* Standard error output. */
    ```

##从层次上看

- STDIN_FILENO等属于系统api接口库，是一个打开文件句柄，STDIN_FILENO是标准输入设备的文件描述符。使用它的函数主要有open, read, write, close等系统级调用。

- stdin等抽象层次更高，是语言级别的抽象，在linux系统，fread, fwrite, fclose等操作内部调用read, write, close系统api来实现。

