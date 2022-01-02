---
layout: post
title: "Visual Studio环境变量使用实例：使用环境变量来组织工程"
category: tools
tags: [visual studio]
description: ""
---

# 前言 #

在前一篇文章[Visual Studio中的环境变量(以Visual Studio 2013为例)](http://blog.csdn.net/elloop/article/details/51010151)中介绍了VS中的环境变量，本文将以实际例子说明如何合理使用这些环境变量来组织VC++工程。

# 使用vs环境变量来组织工程

通常一个解决方案包含多个项目，这些项目相互之间可能存在依赖关系，以下面这个解决方案为例：

<!--more-->

![my_soulution.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/my_solution.jpg)

这个解决方案叫：CS.cpp, 包含了7个项目:

|*项目名*|*生成目标*|*描述*|
|:-------|:----|:----|
|`Algorithm`|.exe|算法和数据结构实践|
|`c_language`|.exe|c语言实践|
|`TotalSTL`|.exe|STL实践|
|`TrainingGround`|.exe|C++语法自由训练场|
|`UnderstandingCpp11`|.exe|深入理解C++11代码实践|
|`gtest`|.lib|google c++单元测试框架，给其他几个项目作为测试框架|
|`util`|.lib|个人积累工具类，为其他几个项目提供util函数|

其中五个项目是生成.exe文件的应用程序，另外两个`gtest`和`util`是服务于其他五个项目的，它俩生成的是.lib库文件，来为其他五个项目链接使用。

下图是这个解决方案文件的物理路径：

![sln_tree.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/sln_tree.jpg)

可以看到，每个项目名称对应一个同名文件夹。（Algorithm项目对应CS.cpp文件夹，因为Algorithm这个项目名字是中途修改的。)

除了7个项目名对应的目录，其他几个文件夹的作用如下表所示：

|*文件夹*|*作用*|
|:-------|:----|
|`include`|项目中使用到的头文件存放于此|
|`libs`|项目中使用到的库文件存放于此, gtest和util这种库工程的输出文件也存放于此，如各种.lib文件|
|`intermediate`|所有项目的"中间目录"集中存放于此|
|`output`|所有应用程序项目的"输出文件"存放于此，如各种.exe文件|
|`res`|项目中用到的资源文件存放于此，比如.txt, .json等文件|
|`_build`|与VC++项目无关，不需留意。|

下面介绍下我是如何把这7个项目组织起来协同工作，并且做到没有冗余文件。

**其实，组织项目很简单，仅需掌握C++程序构建的本质，关键的两个阶段：编译和链接。**

## 第一步，让项目编译通过

这一步的目标是：让5个生成.exe的项目编译通过。以其中任意一个为例讲解，其他的与之类似。那么我就以TotalSTL为例吧，

先保证TotalSTL其内部代码没有语法错误。

其次，因为代码中使用了gtest和util两个项目中的代码，因此需要确保TotalSTL项目能够搜索到gtest和util的头文件。也就是说把gtest和util的头文件所在目录添加到TotalSTL项目的包含路径里即可。增加项目包含目录的操作在上一篇文章中已经提到，这里不再细说。

需要注意的一点是，由于gtest和util属于公共使用的库，所以最好是把它们的头文件放在一个公共的路径下，比如放在常见的以include命名的目录。这正是前面表格中提到的include文件夹的作用，其物理结构如下图所示：

![include_tree.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/include_tree.jpg)

可以看到，在include目录下包含了gtest和util等子目录，他们是按照项目来分类，除了gtest和util这两个项目，还有其他的包含文件也集中放在此处。

我要做的是把include添加到TotalSTL包含目录中，运用上一篇文章学到的环境变量`$(SolutionDir)`，我可以这样编写这个包含目录：

`$(SolutionDir)include/`

添加完包含目录，在TotalSTL项目的main.cpp中，就可以这样引用gtest和util的头文件：

**main.cpp**

{% highlight c++ %}
#include "gtest/gtest.h"            // gtest是include文件夹的子文件夹，gtest.h是在gtest文件夹下，因此要加上gtest/前缀
#include "util/FileReader.h"        // 同理，util是include的子文件夹，FileReader.h是在util文件夹下，因此加上util/前缀

void dummyExitFunction() 
{
    elloop::FileReader::getInstance()->purege();
	char c = getchar();
}

int main(int argc, char** argv) {

#if defined(_MSC_VER) && defined(_DEBUG)
	// make program stop when debug.
	atexit(dummyExitFunction);
	turnOnMemroyCheck();
#endif

	testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
{% endhighlight %}

其中，`#include "gtest/gtest.h"`, gtest是include文件夹的子文件夹，gtest.h是在gtest文件夹下，因此要加上gtest/前缀
同理，`#include "util/FileReader.h"`, util是include的子文件夹，FileReader.h是在util文件夹下，因此加上util/前缀

包含目录配置完毕，项目就能够顺利通过编译了。其他四个项目的配置与TotalSTL的配置一样，也把include加入到包含目录即可。

## 第二步：让项目链接通过

在配置完包含目录，编译通过之后，我如果点“生成”项目，在链接阶段会报错的，是因为五个.exe项目在链接时，没有找到它们依赖的gtest和util库文件。

这一步就是配置库搜索路径：

思路是，先确定gtest和util两个项目生成的库文件存放在何处，然后把库文件所在路径加入到其他五个项目的库搜索路径即可。

**1. 确定库文件位置**

跟前面讲的把公共头文件统一放在include目录类似，公共的库文件一般是放到名为lib或者library的文件夹下，正如前文的目录结构图所示，我把它们统一放到了`$(SolutionDir)libs`目录下，如图，gtest.lib和util.lib就是gtest和util两个项目生成的库文件：

![libs_tree.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/libs_tree.jpg)

要想做到让gtest和util这俩项目"把蛋下到libs这里"是需要设置的。以gtest项目为例，进行如下的设置：项目属性 - 库管理器 - 常规 - 输出文件 :

![gtest_output.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/gtest_output.jpg)

注意到其中对环境变量的使用，`$(SolutionDir)libs/` 就是我的目的地，`$(TargetFileName) == gtest.lib`

**2. 把库文件所在目录加入到库搜索路径**

现在确定了库文件路径为：

`$(SolutionDir)libs/`

下面把它加入到项目的库搜索路径，还是以TotalSTL项目为例，进行如下操作：项目属性 - 配置属性 - 链接器 - 常规 - 附加库目录

![lib_dir.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/lib_dir.jpg)

经过这两个小步骤，就完成了库文件搜索路径的设置。其他的4个项目也按照TotalSTL这样设置一下库搜索目录也就完成了第二步，至此即可保证项目链接通过了。

## 调整项目生成顺序

在设置完文件包含目录和库文件搜索目录之后，当我点击“生成解决方案”的时候，还是可能发生有些项目生成失败的情况。在生成失败之后，我什么也不改，再点一次“生成解决方案”，第二次就生成成功了。这是为什么呢？

这是因为项目生成顺序问题造成的。我们知道，5个.exe项目依赖gtest和util这俩项目，如果在生成gtest和util之前，就开始生成其他项目，比如TotalSTL, 那么当TotalSTL链接时，发现gtest.lib和util.lib还没有生成，此时就生成失败了。

而第二次点击生成的时候，此时，gtest和util在第一次生成时已经成功产生gtest.lib和util.lib，第二次生成时，TotalSTL等其他失败的项目重新重试链接，这次找到了两个.lib文件，于是生成成功了。

怎么能让解决方案一次就生成成功呢？

这就需要调整项目的生成顺序，很简单，还是以TotalSTL为例，进行如下操作：项目属性 - 通用属性 - 引用 - 添加新引用

![add_ref.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/add_ref.jpg)

在弹出的列表中，选择其依赖的项目。选择gtest和util，确定即可。

其他四个.exe项目也做相应处理。设置完毕即可一次生成成功了。

## 管理项目的中间目录和输出目录

在上文的解决方案物理路径图中，还有两个文件夹：intermediate和output 值得介绍一下。

- intermediate: 项目的中间目录，生成过程中产生的一些中间文件存放于此

- output: 项目的输出目录，生成的结果文件存放于此，比如TotalSTL.exe, TotalSTL.pdb, TotalSTL.ilk这些类型的文件

设置这两个目录是为了方便所有项目统一管理，避免混乱。

下面是这两个目录的设置过程：项目属性 - 配置属性 - 常规 - 输出目录/中间目录

![outdir.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/outdir.jpg)

输出目录的值为： `$(SolutionDir)output/$(Configuration)/$(ProjectName)`

中间目录的值为：`$(SolutionDir)intermediate/$(Configuration)/$(ProjectName)`

注意其中环境变量的使用：`$(SolutionDir)/intermediate` 和 `$(SolutionDir)output` 分别定为到上面提到的两个文件夹，然后按照编译配置, 即`$(Configuration)`(通常为Debug或者Release)来分目录，最后以项目名称来分目录。

生成之后的目录结构如下图所示, 可以看到图中路径正是把`$(Configuration)`(值为Debug)， `$(ProjectName)`（项目名字）代入之后的结果：

![inter_tree.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/inter_tree.jpg)

## 管理可执行文件生成位置

上面在讲到gtest和util这两个项目的生成.lib的位置时，提到了改变项目的生成文件位置。与之类似，其他5个生成.exe的项目，也可以做设置，使生成的.exe按照统一的目录存放，方便查找和管理。

以TotalSTL项目为例，具体操作如下：项目属性 - 配置属性 - 链接器 - 常规 - 输出文件

![output_exe.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/output_exe.jpg)

其值设置为：`$(OutDir)$(TargetFileName)`

注意到其中环境变量的使用，其中的`$(OutDir)`就是上一小节提到的输出目录，其值刚才被设置为`$(SolutionDir)output/$(Configuration)/$(ProjectName)`，把它代入到上面，展开为：

`$(SolutionDir)output/$(Configuration)/$(ProjectName)$(TargetFileName)`

生成之后的物理路径结构为：

![output.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/output.jpg)

可以看到输出的TotalSTL.exe的路径正是"输出目录"，文件名TotalSTL.exe即`$(TargetFileName)`。

## 管理工作目录

工作目录是程序运行时，搜索资源文件的路径，具体设置在：项目属性 - 配置属性 - 调试 - 工作目录：

以TrainingGround项目为例:

![workdir.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/workdir.jpg)

其值为：`$(SolutionDir)res/`, 即对应开篇解决方案图中的res文件夹。

# 总结

本文展示了如何借助Visual Studio的环境变量来组织一个VC++解决方案的工程目录结构。提到了如何使用环境变量来编写头文件包含路径、库文件搜索路径、中间目录、输出目录、输出文件位置、工作目录等。

# 解决方案代码地址：[CS.cpp](https://github.com/elloop/CS.cpp)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

