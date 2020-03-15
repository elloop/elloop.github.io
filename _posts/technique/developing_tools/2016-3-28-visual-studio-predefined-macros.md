---
layout: post
title: "Visual Studio中的环境变量(以Visual Studio 2013为例)"
category: tools
tags: [visual studio]
description: ""
---

# 前言 #

本文总结了Visual Studio中常见的环境变量及其在组织解决方案、工程中的作用。

注：本文使用的是Visual Studio 2013，由于作者主要从事C/C++开发，所以是以Visual C++的工作环境配置来描述。

# 什么是vs的环境变量？

先看图吧，图中以美元符号$开头 + 一对括号，这样进行引用的就是我所谓的环境变量，

![vs_env.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/vs_env.jpg)

图中出现的几个环境变量含义如下：

|*环境变量名*|*含义*|
|:---------------|:----------------|
| $(SolutionDir)      | 解决方案目录：即.sln文件所在路径 |
|$(Configuration)            |当前的编译配置名称，比如Debug，或Release|
|$(ProjectName)        | 当前项目名称，图中即为Game|

**<font color="red">在中文版的VS中，环境变量翻译为“宏”，为了避免与C/C++语言中的宏(Macro)搞混，我在本文中把它叫做“vs环境变量”，简称环境变量。</font>**

# 环境变量有什么用？

<!--more-->

使用环境变量来组织工程目录

vs作为一个IDE，其天职在于帮开发者组织好工程，主要包括对工程中源文件、库文件的组织。（本质上是提供一个可视化的操作界面，让开发者方便的定义编译器和链接器的参数。）在使用vs来组织工程目录时候最常用到的两个目录是:

- 头文件包含目录 (对应于编译器命令的：-I 参数)

- 库文件搜索路径 (对应于编译器的：-l 参数)

vs中默认的头文件搜索路径是: `工程路径` -- 即，`.vcxproj`(不同版本的VC++后缀名称不同，如vs2010中后缀为.vcproj) 文件所在路径。比如如下的目录结构:

--Root/
----Test.vcxproj
----hello.cpp
----hello.h
----world.cpp
----world.h
----main.cpp
----/subdir
------sub.h

在Root目录包含了.vcxproj文件，所以Root就是`工程路径`，在vs中，这个目录下面的.h文件可以直接使用include包含进来, 比如在main.cpp中我可以写：

{% highlight c++ %}
#include "hello.h"
#include "world.h"
{% endhighlight %}

但是对于sub.h，我们就不能直接写`#include "sub.h"`, 因为`工程路径`下面不能搜索到这个文件，我要告诉编译器这个文件在哪里，通常有以下两种方法：

- 写成`#include "subdir/sub.h"`

- 把subdir目录加入到头文件搜索路径

Google的C++编程风格鼓励第一种做法，好处是可以看到文件相对完整的路径，如果头文件搜索路径只有一个根目录，那么这个路径就是文件的相对于根目录的物理路径，方便定位文件。

如果你觉得这样写很麻烦，并且路径深度可能有多层，不同深度的路径下又通常包含大量的文件，那么就可以选择第二种做法，把每个子目录统统加入到搜索路径中，这样，就可以不用带着路径，直接`#include "filename.h"`就可以了。具体在VS中要怎么合理的添加文件包含目录呢？由此，便引出了本节问题的答案：环境变量有什么用？用途之一就是用来编写头文件的搜索路径。

相信大家都知道如何在vs中添加一个头文件搜索路径这个常识，在此还是为初学者唠叨一下具体做法：工程属性 - 配置属性 - C/C++ - 常规 - 编辑右侧的"附加包含目录"取值即可。

具体如下图所示：

![include_setting.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/include_setting.jpg)

点击编辑之后，弹出如下图所示的编辑窗口：

![additional_searchpath.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/additional_searchpath.jpg)

在这里可以新建、删除包含路径、调整包含顺序。

点击新建按钮或者双击列表空白处即可添加一条包含路径，在编辑新添加的路径时，可以看到列表条目右侧有一个浏览按钮，

![include_scan.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/include_sacn.jpg)

点击按钮可以从打开文件对话框里选择路径，点击确定后，会看到新添加的路径名。虽然通过浏览来定位文件夹比较容易，免去了自己编写，但是你会发现，通过浏览添加的路径是绝对路径。

<font color="red">**如果你是项目的唯一开发者，并且仅仅使用这一台电脑来开发的话，那么使用绝对路径也没什么大问题。但是如果这个项目是个团队协作项目，或者你需要在好几台电脑之间切换，那么这个包含路径如果写绝对路径就不够灵活了，如果别人的路径配置或别的电脑的路径配置不同，那么要重新修改包含路径。**</font>

一个比较合理的编写包含路径的方法是: 使用相对路径。

相对谁呢？ 相对项目根目录或者解决方案根目录。

为什么呢？因为不管别人的电脑有什么盘符、不管别人的项目放在何处，要包含的文件都可以通过项目所在位置来计算出来。

当然前提是，项目开发者们事先约定好被包含文件相对于项目根目录的位置。通常是放在项目根目录（或者解决方案根目录）的某个子目录里。

具体怎么做呢？这就需要用到本文的主题：环境变量了。刚才提到的两个相对目录所对应的环境变量如下表所示：

|*目录*|*对应的环境变量名称*|
|:---------|:------------------|
|项目根目录|$(ProjectDir)|
|解决方案根目录|$(SolutionDir)|

要解决刚才小例子中的问题，

--Root/
----Test.vcxproj
----hello.cpp
----hello.h
----world.cpp
----world.h
----main.cpp
----/subdir
------sub.h

注意到.vcxproj所在目录即项目根目录，也就是$(ProjectDir)的取值等于Root/。所以要把subdir放在包含目录里，可以新建这样一条包含路径：

`$(ProjectDir)subdir`

这样，在main.cpp里就可以直接写`#include "sub.h"`了。不管项目被拷贝到哪里，都不用修改包含路径。

上面就是环境变量使用的一个小例子。使用环境变量来编写文件包含路径的好处是: 包含路径独立于工程所在的路径，无论工程被移动到哪里，都不需要重新修改包含路径，因为使用环境变量来编写的文件包含路径是一种相对路径。

# 其它vs环境变量

如何查看所有的环境变量值呢？

有好多个地方都可以查看，比如刚才在添加包含目录时候，弹出的窗口，注意其右下方，有个“宏”按钮

![additional_searchpath.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/additional_searchpath.jpg)

点击它就能看到所有的“宏” （即vs环境变量的值）：

![all_vs_env.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/all_vs_env.jpg)

在上方的输入框可以进行过滤。

下面的表格给出了常用的环境变量的含义：


|*环境变量名*|*含义*|
|:---------------|:----------------|
| `$(SolutionDir)`      | 解决方案目录：即.sln文件所在路径 |
| `$(ProjectDir)`      | 项目根目录:, 即.vcxproj文件所在路径 |
|`$(Configuration)`            |当前的编译配置名称，比如Debug，或Release|
|`$(ProjectName)`        | 当前项目名称|
|`$(SolutionName)`|解决方案名称|
|`$(OutDir)`        | 项目输出文件目录|
|`$(TargetDir)`        | 项目输出文件目录|
|`$(TargetName)` | 项目生成目标文件, 通常和`$(ProjectName)`同名, 如Game |
|`$(TargetExt)`|项目生成文件后缀名，如.exe, .lib具体取决于工程设置|
|`$(TargetFileName)`        | 项目输出文件名字。比如Game.exe, 等于 $(TargetName) + $(TargetExt)|
|`$(ProjectExt)`|工程文件后缀名，如.vcxproj|

在下一篇文章中，讲介绍如何合理使用这些环境变量来组织VC++工程。

# 进阶思考

- 如何定义、扩展VS的环境变量？

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

