---
layout: post
title: "C++正则表达式使用实例--实现一个markdown代码标记转换工具"
category: c++
tags: [tools]
description: ""
---

#前言

这个需求起源于github官方升级了Jekyll引擎到3.0，markdown引擎受到了一定的影响，比如代表标记由原来的

"```c++```"

变成了`{%highlight c++%} {%endhighlight%}`

如果不进行转换的话，那么原来博客里的代码片段排版将会发生错误：失去高亮，且布局错乱。

这个问题本质上就是字符串的替换，应该有很多现成的工具可以完成这个任务，或者我可以直接在`.vimrc`中添加一个命令，实现一键替换当前文件中的代码标记。

我习惯于抓住任何可以实践c++的机会，因此第一想法就是使用c++来做这个功能，虽然它并不是最好的选择。

<!--more-->

# 准备工作：掌握c++正则表达式基本用法



# 代码实现

```c++
size_t convertHighlight(vector<string>& content, char* cmd) {
    string patternBegin;
    string patternEnd;
    regex regexBegin;
    regex regexEnd;
    string replaceBegin;
    string replaceEnd;

    if (string(cmd) == "--to-dot") {
        // match {% highlight <lan> %} and {% endhighlight %}, then replace with ```<lan> and ```.
        patternBegin = "[\\s\\t]*\\{[\\s\\t]*%[\\s\\t]*\\bhighlight[\\s\\t]*(\\S+)[\\s\\t]*%[\\s\\t]*\\}[\\s\\t]*";
        regexBegin = patternBegin;
        patternEnd = "[\\s\\t]*\\{[\\s\\t]*%[\\s\\t]*endhighlight[\\s\\t]*%[\\s\\t]*\\}";
        regexEnd = patternEnd;
        replaceBegin = "```$1";
        replaceEnd = "```";
    }
    else {
        // match ```<lan> and ```, then replace with {% highlight <lan> %} and {% endhighlight %}.
        patternBegin = "[\\s\\t]*```(\\S+)[\\s\\t]*";
        regexBegin = patternBegin;
        patternEnd = "[\\s\\t]*```[\\s\\t]*";
        regexEnd = patternEnd;
        replaceBegin = "{% highlight $1 %}";
        replaceEnd = "{% endhighlight %}";
    }

    // check every line, try to match begin and end.
    vector<string> backup;
    backup.swap(content);

    size_t matchCount(0);
    for (auto & line : backup) {
        smatch sm;
        // try to match begin.
        regex_match(line, sm, regexBegin);
        if (sm.size() == 2) {
            cout << "replace: " << line << endl;
            line = regex_replace(line, regexBegin, replaceBegin);
            ++matchCount;
            continue;
        }

        regex_match(line, sm, regexEnd);
        if (sm.size() == 1) {
            cout << "replace: " << line << endl;
            line = regex_replace(line, regexEnd, replaceEnd);
            ++matchCount;
        }
    }

    cout << "================ total replace: " << matchCount << "================ " << endl;
    if (matchCount > 0) {
        // write back to contents.
        content.swap(backup);
    }

    return matchCount;
}
```

# 参考链接

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



