---
layout: post
title: "Learning Python 1: basic"
category: python
tags: [python, programming skills]
description: ""
---

**注意：本系列文章均以linux为主**

*实际操作之前，请确保已经安装Python并且将python添加到环境变量*

# 让Python跑起来的几种方式

- way1 REPL模式：打开终端，敲入`python`
  
    ```python
    linadeMacBook-Pro:Downloads lina$ python
    Python 2.7.6 (default, Sep  9 2014, 15:04:36) 
    [GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.39)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> hi = "hello world"
    >>> print(hi)
    hello world
    >>> 
    ```

- way2 `python <python-script-name>.py`
   创建一个以py结尾的文件，输入下面的内容，保存为hello.py, 它就成为了一个python脚本 

    ```python
    #hello.py
    hi = "hello world"
    print(hi)
    ```

    保存之后，在终端敲入：

    ```python
    linadeMacBook-Pro:Downloads lina$ python hello.py 
    hello world
    linadeMacBook-Pro:Downloads lina$ 
    ```

    这样脚本就执行完成了

- way3 可执行脚本 可执行脚本也是以py结尾的文件
    - windows上不需要特别处理，把py文件的打开方式和python.exe进行关联即可。
    - unix风格脚本需要:1.在文件的第一行加入#!+python解释器的路径; 2.给文件添加可执行权限

    创建一个hello.py
            
    ```python
    #!/usr/bin/env python
    hi = "hello world"
    print(hi)
    ```

    添加可执行权限：

    ```python
    linadeMacBook-Pro:Downloads lina$ chmod +x hello.py
    linadeMacBook-Pro:Downloads lina$ ./hello.py 
    hello world
    linadeMacBook-Pro:Downloads lina$ 
    ```

    >`#!/usr/bin/env python`的意思是到环境变量中查找python解释器的路径，这种写法比`#!/usr/local/bin/python`的写法更有可移植性
