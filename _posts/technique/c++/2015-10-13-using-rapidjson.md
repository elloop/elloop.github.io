---
layout: post
title: "rapidjson使用总结"
category: c++
tags: rapidjson
description: ""
---

## rapidjson简介

rapidjson是腾讯的开源json解析框架，用c++实现。由于全部代码仅用header file实现，所以很容易集成到项目中。

rapidjson的性能是很出色的，其作者[Milo Yipz](https://github.com/miloyip)做了28个C/C++ JSON库的评测，[这个链接](http://www.zhihu.com/question/23654513)里有测试的结果截图。

rapidjson的另一个特点是对json的标准符合程度是100%的(在开启了full precision选项的情况下)。

这里是官方教程：[rapidjson官方教程](http://rapidjson.org/zh-cn/md_doc_tutorial_8zh-cn.html)

这里是原作者对rapidjson代码的剖析：[rapidjson代码剖析](http://miloyip.com/rapidjson/)

<!--more-->

我之前的项目使用的是jsoncpp，最近在把解析json的代码交叉编译到iOS设备的时候，偶尔会出现crash的情况。虽然经过检查是代码写的有问题，不是jsoncpp的问题，在解决问题过程中尝试了rapidjson这个库，并顺便对比了一下jsoncpp和rapidjson对我项目中json文件的解析速度。

## Dom解析示例

下面是我写的一个小例子，从test.json文件中读取内容并解析。其他代码示例也可以查看我的github仓库中关于rapidjson的测试代码:[rapid_json_test.cpp](https://github.com/elloop/CS.cpp/blob/master/TrainingGround/third_party/rapid_json_test.cpp).

{% highlight json %}
// test.json
{
    "dictVersion": 1,  
    "content":  
    [   
     	{"key": "word1", "value": "单词1"} ,
     	{"key": "word2", "value": "单词2"} ,
     	{"key": "word3", "value": "单词3"} ,
     	{"key": "word4", "value": "单词4"} ,
     	{"key": "word5", "value": "单词5"} 
    ]
}
{% endhighlight %}

{% highlight c++ %}
// test.cpp
#include "rapid_json_test.h"
#include "rapidjson/document.h"
#include "rapidjson/reader.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/writer.h"
#include "util/FileReader.h"
#include <string>
#include <fstream>
#include <iostream>


#include <fstream>
#include <string>
#include <cassert>
#include <iostream>
#define psln(x) std::cout << #x " = " << (x) << std::endl

void testSimpleDoc() {
    using std::string;
    using std::ifstream;

    // read json content into string.
    string      stringFromStream;
    ifstream    in;
    in.open("test.json", ifstream::in);
    if (!in.is_open())
        return;
    string line;
    while (getline(in, line)) {
        stringFromStream.append(line + "\n");
    }
    in.close();

    // parse json from string.
    using rapidjson::Document;
    Document doc;
    doc.Parse<0>(stringFromStream.c_str());
    if (doc.HasParseError()) {
        rapidjson::ParseErrorCode code = doc.GetParseError();
        psln(code);
        return;
    }

    // use values in parse result.
    using rapidjson::Value;
    Value & v = doc["dictVersion"];
    if (v.IsInt()) {
        psln(v.GetInt());
    }

    Value & contents = doc["content"];
    if (contents.IsArray()) {
        for (size_t i = 0; i < contents.Size(); ++i) {
            Value & v = contents[i];
            assert(v.IsObject());
            if (v.HasMember("key") && v["key"].IsString()) {
                psln(v["key"].GetString());
            }
            if (v.HasMember("value") && v["value"].IsString()) {
                psln(v["value"].GetString());
            }
        }
    }

    pcln("add a value into array");

    Value item(Type::kObjectType);
    item.AddMember("key", "word5", doc.GetAllocator());
    item.AddMember("value", "单词5", doc.GetAllocator());
    contents.PushBack(item, doc.GetAllocator());

    // convert dom to string.
    StringBuffer buffer;
    Writer<StringBuffer> writer(buffer);
    doc.Accept(writer);

    psln(buffer.GetString());
}
{% endhighlight %}

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**






