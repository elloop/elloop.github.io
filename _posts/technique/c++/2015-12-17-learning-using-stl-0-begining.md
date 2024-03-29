---
layout: post
title: "【C++ STL应用与实现】0: 感恩STL——STL, ACM和年轻的我们"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文是一篇洗脑文，鼓吹STL的好处, 回忆作者第一次认识STL，并给出STL的学习路线。

<!--more-->

# 初见STL

第一次接触STL还是在我的大学时代，大一下学期刚刚学完了C++， 真的仅仅是把C++当做“带类的C”来使用，对当时的我来说C++只是比C多了个class，多了个继承和virtual，写一些Circle和Rectangle继承自Shape之类的玩具作业，感觉没什么吊炸天的感觉。当老师布置《数据结构》期末的课程设计作业的时候，我还傻傻的选了用C语言设计一个行编辑程序。直到一次有个同学发给我一个C++的程序，他在网上下的想自己改改作为课程设计但不会改，就让我帮他改。我一看main.cpp也傻了，这开头的一堆`#include`是啥？

{% highlight c++ %}
#include <vector>
#include <algorithm>
#include <functional>
{% endhighlight %}

印象最深的是一句代码里有：`for_each(files.begin(), files.end(), mem_fun(&File::print))`

“这是在搞啥？”

稍微看一眼File的定义，奥，明白了(STL之所以好，还在于其使用和表达方式的直白，新手都很容易理解), 这是在遍历容器里的File指针，并调用它的成员方法print。我当时心里的想法是：“cao，还可以这么写C++？好牛！” 于是开始百度搜索(那时候第一想法还不是用google -_-)for_each, algorithm, mem_fun, functional ... 。

终于知道在C++语言中还有这么一座宝藏，好tm激动。从图书馆借回来那本丑丑的灰绿色的《C++标准程序库》（侯捷译）第一版(人气不高, 好几本都没人借), 看这本书的时候经常看到高潮迭起。印象最深的是有一节讲到容器和算法的配合，可以用两行代码实现从输入流读取一堆字符串，排序，输出，我靠，简直不能更酷:

{% highlight c++ %}
#include <iostream>
#include <set>
#include <iterator>
#include <algorithm>
#include <string>
using namespace std;

int main() 
{
    set<string> coll((istream_iterator<string>(cin)), (istream_iterator<string>()));
    copy(coll.begin(), coll.end(), ostream_iterator<string>(cout, "\n"));
    return 0;
}
// 提示初学者：你在测试这段代码时，输入字符串的时候，回车分隔不同的字符串，在windows上用ctrl + z来结束输入. linux上用ctrl+d结束
{% endhighlight %}

还有一个例子是那本书的作者用来展示STL威力的代码，用三条语句实现从输入流读取一堆字符串，排序，去掉重复，并输出：

{% highlight c++ %}
#include <iostream>
#include <vector>
#include <iterator>
#include <algorithm>
#include <string>
using namespace std;

int main() 
{
    vector<string> coll;

    // 读取字符串，直到EOF（windows上使用ctrl+z输入） ，逐个插入到coll的结尾
    copy(istream_iterator<string>(cin), istream_iterator<string>(), back_inserter(coll));

    // 字符串排序
    sort(coll.begin(), coll.end());

    // “唯一化”输出到标准输出流
    unique_copy(coll.begin(), coll.end(), ostream_iterator<string>(cout, "\n"));

    return 0;
}
{% endhighlight %}

从此以后，STL在方便我生活的同时也成为了我的一个装b利器，

![LifeIsBoringWithoutZB.jpg](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/LifeIsBoringWithoutZB.jpg)

每当遇到谁让我帮忙写代码的时候, 尤其是知道他大概不认识STL的时候，我必须在代码里“强行”使用STL，就为了能够让他在看到代码时候，有种: “cao，这是啥, 这tm是啥...？跟这小子比，我的C++真是白学了。”的想法。

# STL与ACM

后来开始参加ACM比赛，拿了省赛和东北赛区的奖，可以说STL至少有一半的功劳。

每次参加练习赛和正式比赛，我都必须随身携带那本厚厚的灰绿书，就为了看STL到底有没有为我提供想要的接口来解决手头的问题。就在这种现学现卖的情况下，我慢慢的加深对STL的了解。比赛中不仅对解题时间有限制，同时对程序的时间复杂度和空间复杂度也都有限制，这也强迫我开始去关心STL的时间和空间复杂度问题，开始关心STL的实现方式。

到了参加省赛的时候，我基本上已经可以做到不看书，熟练的使用常见的STL容器和算法了。还记得省赛的最后5分钟，我们只AC了3道题，排名几乎已确定不能参加东北区赛了。我和两个学弟最后一起看一道题，经过我们仨讨论，突然发现我一开始理解错题意了，这道题很简单，我们马上有了思路，我们仨相互对视了一眼

（我们三个配合很默契，大一数学系的学弟负责分析数学类的难题, 或者写出公式，或者把思路描述给我; 大二软件工程的学弟负责综合类的问题分析，我由于更熟悉C++且敲代码速度很快，所以负责所有的代码编写和代码提交大权, 刚开始我先集中精力快速搞定简单题, 之后加入到他俩的分析工作，进度卡住时候大家就聚在一起研究问题，解决方案确定之后，我就把大家的想法翻译成C++代码、提交，然后三个人一起心脏狂跳, 扑通扑通扑通。。。）

, 他俩的眼神在说，“哥，我相信你”。我扯过键盘，在文件的开头加上一行 `#include <set>`之后，开始噼里啪啦一顿狂敲，赛场里其他队伍嗡嗡的讨论声和我紧张的心跳声混杂在一起，那感觉像是在做梦, 扑通扑通扑通。。。我能感觉到他俩像我一样，心脏也扑通的不行。大概不到三分钟后，编译&通过了题目的示例输入。没时间做边界测试了，我把代码贴到输入框，点击了submit。在这评判结果返回的几秒钟里，他俩左右手分别搭在我的肩膀上，我们仨就像在看世界杯决赛中队友主罚最后点球时候一样紧张。

几秒钟后，提交列表里我们看到了醒目的 “Accepted”, 在确认了确实是我们的提交之后，我们仨几乎是在同一时刻喊出来：“yeah！”, 不顾其他人诧异的目光，我们相互搂了搂肩膀，总算没有遗憾了。最后我们获得了省赛second prize并晋级了一个月后东北赛区的比赛。虽然这个成绩相对于那些ACM大牛来说太过一般，但是在这个过程中我们的成长是奖金和获奖证书所无法比拟的。而当时激动的最后五分钟，帮助我们晋级的正是STL，最后那道题我运用了std::set保持元素唯一且有序以及O(logn)的查找时间这些特性，才在不到三分钟内快速搞定了问题。

# C++11, C++14, C++17... 不，你tm等等我。

时光飞逝，眨眼间我已工作了好几年，STL伴随着C++11标准的发布有了比较大的变化，《C++标准程序库》第二版也已出版，我没有等到中文版的出版，慢慢啃着英文版的第二版。虽然没有看第一版时候那么激动，但看到STL变得更好用，心理还是很开心。我正在做到熟练运用STL这条路上稳步前行，希望我学习的速度能赶得上它发展的脚步。 我发现，把学到的东西写出来，描述出来，能加深对知识的理解和记忆，同时还能给初学者带来一个参考，也算自己为STL技术的发展和普及尽一份绵薄之力，作为它给我巨大帮助的回报。因此，我要把对STL的学习和应用总结出来，提高自己同时也给想了解STL的人提供参考, 希望STL能给更多人带去初见时那种“激动到尿裤子”的快感 ;)。

提到学习STL就不能不提到侯捷老师对学习STL划分的三个境界：

**境界一：熟用STL**

**境界二：了解泛型技术内涵和掌握STL的原理及实现**

**境界三：扩充STL**

有很多牛b的人，牛b的公司觉得STL不好用，甚至因为内存碎片、线程安全之类的问题在项目中明令禁止使用STL，自己来写或定制STL，也有测试数据表明，他们自己写的库确实在性能上会超出STL很多，某些特性甚至相差几个数量级。这些人已经站到了第三个境界里，我在第一境界里仰望着他们，同时希望自己早些达到他们的境界。

# STL学习路线

最后分享一个《C++标准程序库》上的STL和C++泛型编程的成长路线图：以要读的书来看，

1《C++标准程序库》`-->`2《Effective STL》`-->`3《Generic Programming and the STL》`-->`4《STL源码剖析》`-->`5《Modern C++ Design》`-->`6 《C++模板元编程》

第1, 2本都看完了，再多加练习，第一个境界就算OK了，就能升级了。

第3, 4本看完了，再多加实践、思考就算第二个境界合格了。

第5本，就开始教你怎么玩STL了，让你离第三境界更近一步。至于怎么升到第三境界，我想还是需要自己多思考实践吧，从量变到质变。

第6本是我加上去的，模板元编程就开始告诉你怎么玩转C++编译器了，让你的代码跑在编译时而不是运行时，教你用编译时多态，而不是运行时多态。你要写出能控制代码的代码，生成代码的代码。有点人工智能的感觉。

因为C++标准更新的原因, 如果不想停留在C++98时候的STL，你就得再看一些C++11或者更新标准的书，推荐《深入理解C++11新特性》这本书，由C++标准委员会成员和IBM C++编译器设计团队共同撰写，质量保证。最近祁宇也出了一本C++工程实践方面的书，值得一看。国内的C++新标准的书并不多。

下面这几个C++链接非常有用，C++语言和STL的官方参考.

- [isocpp.org](https://isocpp.org/)

- [cplusplus.com](http://www.cplusplus.com/)

- [cppreference.com](http://en.cppreference.com/w/)


---------------------------



**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**


