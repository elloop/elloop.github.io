---
layout: post
title: "CSDN对祁宇的专访"
highlighter_style: solarizeddark
from_others: true
original_url: "http://www.csdn.net/article/2015-06-23/2825027-C++"
category: c++
tags: [interview]
description: ""
published: true
---

祁宇，资深C++技术专家，致力于C++11的应用、研究和推广。金山软件WPS资深工程师，负责Android服务端开发。精通OOP、OOD、设计模式和重构，主要研究方向为架构设计和业务重构，有丰富的开发和研发管理经验。爱好C++，爱好开源，乐于研究和分享技术，有多个开源项目（详见 GitHub），在《程序员》上发表多篇技术文章。2013年被评为珠海市优秀青年人才。

日前CSDN采访了祁宇，请他解读C++11的新标准、C++的现状以及未来的发展前景。 

<!--more-->

 
CSDN：怎么会想到编写《深入应用C++11：代码优化与工程级应用》这本书的？有没有什么故事可以分享下？

祁宇：我作为比较早使用C++11的开发者，在项目中应用C++11的时候，可以查阅的资料还很有限，主要是通过ISO标准（ISO/IEC 14882:2011），维基百科、MSDN和http://en.cppreference.com/w/等网站来学习C++11。然而，这些地方对新特性的介绍比较零散，虽然知道这些新特性的基本用法，但有时候不知道为什么需要这个新特性，在实际项目中该如何应用，或者说最佳实践是什么，这些东西网上可没有，也没有人告诉你，因为当时只有很少的人在尝试用C++11，这些都需要自己不断的去实践、去琢磨，当时多么希望能有一些指导C++11实践的资料啊。在不断实践的过程中，我对C++11的认识加深了，C++11不断地给人带来惊喜，在我窥探到C++11的妙处之后，我很想和更多人的分享，让更多的人更好地掌握C++11的用法和领略C++11的魅力。这是我把应用C++11的一些心得和经验放到我的技术博客上分享出来的初衷，也是我写作此书的初衷。

CSDN：这本书适合哪些读者？书中主要介绍了哪些内容？设计思路是怎样的？

祁宇：适合普通的C++开发者，无论是新手还是老手，都有必要学习和应用C++11，C++11的强大特性可以大幅提高生产力，让我们的项目开发更加得心应手。

本书分为两部分，前半部分侧重从如何去改进我们现有程序的角度去介绍C++11新特性 。这样一来可以让读者学习这些新特性的用法；二来还可以让读者知道这些特性是如何改进现有程序的，从而能更深刻的领悟C+11的新特性；后半部分通过丰富的开发案例来介绍如何使用C++11去开发项目，相信这些实战案例能给读者带来更深入的思考。

CSDN：代码优化的好处有很多，但并不意味着所有的代码都需要进行优化，有时过度的优化反而适得其反，对此，你怎么理解？在实践过程中，你是怎么操作的？

祁宇：确实，代码的过度优化可能会让代码变得更加晦涩，这是应该尽量避免的，另外过早的优化也是不提倡的。事实上，在实际的项目开发过程中，代码优化不是做多了而是做得太少了，很多情况下都是赶进度，赶任务，或者由于自己的水平有限，主观能动性不足，很少会有人花大量时间去考虑代码优化的事，更不会主动通过应用新技术或采用重构等手段去改进代码。

在项目开发中我会采用一些最佳实践来保证写代码不容易犯错，比如我不用裸指针，只用智能指针和guard手法，这样我根本不用担心内存泄漏的问题，通过type_traits在编译期做一些约束确保我们在编译期就能及早地发现问题。项目开发到一定时候我会用一些第三方工具来审查代码，比如Source moniter和Simian，看看我的代码有没有重复代码，有没有深层嵌套，圈复杂度是不是太高等等，然后重构。做这些事情虽然看起来可能会拖慢开发进度，甚至对你的KPI没有任何帮助，但它对你的项目质量却有很大帮助，也许在项目交付后别人忙着改Bug，而你却可以悠闲地喝咖啡了。

CSDN：你怎么看C++新标准？有没有哪些新特性让你印象深刻？它会影响API的设计吗？现存的库如何保持更新呢？

祁宇：C++新标准意味着更强的生产力，让C++更加强大，让你写C++更爽。据说重要的话要说三遍，这句话请重复三遍。

C++新标准有很多特性让人印象深刻，比如，右值引用可以避免无谓的拷贝，提高程序性能；可变模板参数使C++的泛型编程的能力更加强大； type_traits可以使我们方便地在编译期对类型进行计算；智能指针使我们不用担心内存泄露的问题了；线程库让我们能方便地编写可移植的并发程序；auto+decltype不仅让我们写代码更加简洁还让推断模板函数的返回类型更加便利，lambda让算法更清晰等等，不一而足。难怪Bjarne Stroustrup说C++11看起来像一门新的语言了，相信学习和使用过C++11的朋友一定心有戚戚焉。

新标准会让API变得更合理——API的设计会向着更加简洁、清晰、减少语法和语义噪音的方向上演进。当然，更主要的还是取决于使用这些特性的用户。

现存的库升级到新标准的代价是非常小的，希望广大C++开发者及时升级编译器，在新项目中使用新标准，你们失去的仅仅是一个老旧的编译器，而得到的却是巨大的生产力！

CSDN：C++的应用领域变得越来越小，你认为C++的演进方向是什么样的？ C++的强势领域在哪里？它未来会有什么样的发展？

祁宇：随着Web和移动的崛起，C++的应用领域相对来说变小了，当一个领域下出现了一门专门的语言能够实现更加简洁的封装，又很容易上手，并且也不再那么需要强调效率的时候，C++被取代是很正常的。事实上，C++是一个通用的语言，它在尽量保证高效的前提下，来实现足够优雅的抽象概念的封装。所以同样的，我们可以看到在前台花样迭出的情况下，后台使用C++来做关键的性能部分是很自然的选择。对于核心的算法，使用C++可以实现一次编码多处编译，从而在任何平台下都有最佳的性能，而上层部分则可根据实际情况及平台选择专门的语言来高效的撰写。另外，在服务器、安全、游戏、嵌入式等领域里，C++依然是不二的选择，随着新标准的出现，现代C++将出现在更多的领域。

虽然C++11相比C++98/03来说已经有了脱胎换骨的变化，但C++仍然在持续发展，充满活力，比如已经出来的C++14和即将到来的C++17， C++17将引入concept、文件库、并行库、网络库和coroutine，这些是非常值得期待的，可以预见的未来，C++的发展会越来越好。随着C++新标准的不断发展，引入越来越多的现代编程语言的特性，C++将越来越受欢迎，C++11的出现已经印证了这一点，在StackOverflow的最近一次调查中，C++11在所有的编程语言中排名第二，这是毫不意外的。

CSDN：Go语言的语法与C++相似，国内外的推崇者也比较多，你认为未来它会取代C/C+吗？

祁宇：二者有一定的相似度，从语法上来说，Go就像一个被重度语法糖包裹的C++，还去掉了编译期/预编译期计算的能力。对于我个人而言，C++的模板和模版元很有趣，也是我喜爱C++的一个重要原因，对于没有模板和模版元的编程语言无疑少了很多乐趣。

我认为未来Go不会取代C/C++，因为它们的应用范围并不相同。Go语言的一些不足也影响了Go的推广，例如，不能忽略import的错误，一些关键实现（如GC）改进迟缓导致生产的软件的缺陷等等。 Go语言相比C/C++可能更擅长并发与分布式（这一点将在即将到来的新标准C++17中得到弥补，实际上C++11已经具备这方面的基础了），而C/C++则更为严谨、朴实和通用，对于C++来说，可以在保证更高效率的同时实现比Go更丰富和简洁的抽象。只要想做，C++完全可以实现Go里的大部分关键字（比如go/defer/switch）。

其实无论什么语言，只要你喜欢并享受它带来的乐趣就够了，与其加入满是口水的语言之争不如为喜欢的语言的发展做一点实际的事情。

CSDN： 除了C++，你还喜欢什么语言？在日常工作中你常用的工具有哪些？

祁宇：我还喜欢C#语言，常用开发工具是VS2013、VIM、Eclipse，intelij；UML设计工具是EA；代码检查的工具是source moniter和simian。

CSDN：你开源了多个项目，这些项目还会经常维护吗？你设计的初衷是什么？你怎么看待开源社区的演进？

祁宇：现在还在维护，而且还在不断增加新的项目，并且有越来越多的人参与进来。

在用C#和Java开发了一些项目之后再回到C++时，不免感慨C++相比C#和Java来说少了很多有用的库，比如AOP、IOC、ORM、steam API等等，所以我希望我能做点事，让C++的世界变得更美好，让C++开发者的日子变得更美好，尤其是这么给力的C++11出来之后，这种愿望就更强烈了，这是我将我工作中开发的一些基础库开源出来的初衷，也是我投入开源社区的动力。

我理解的开源社区是没有功利性的，靠的是一大批编程爱好者对编程的热爱，靠的是一点梦想。除了这些之外，开源社区的发展应该切合现实实际需求，让更多的人愿意参与进来。现在对于C++社区而言是一个黄金时代，因为新标准的不断发展，以前的一些难做之事用现代C++去做都变得很简单，用现代C++去做前人未做之事，弥补以往C++世界的缺憾正当其时。我创建的C++社区（purecpp.org）正是在这个背景下诞生的，社区里不仅有高质量的原创技术文章，还有线下技术沙龙（最近组织了一次主题为C++魔法的技术沙龙，详细信息在这里：http://purecpp.org/?p=202），还有活跃的开源项目，在这里透露一下我们现在正在做的一件有趣的事情，是我们社区的一个开源项目，用现代C++做一个灵感来源于sinatra的现代Web Framework，我们的社区后面升级会采用这个框架，社区网站也将用现代C++开发，敬请关注。

CSDN：给C++爱好者分享些经验和心得感悟。

祁宇：兴趣是最好的老师，享受现代C++带来的乐趣会让你学习C++变得更容易。任何书或资料都只能让你入门，最重要的是实践。在你享受你喜爱的编程语言的时候，心怀感恩，业余之时为这个语言的发展做一点事，生活将会增加更多乐趣。