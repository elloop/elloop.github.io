---
layout: post
title: protobuf lua api
---
{% endhighlight %}
message Msg{
}
{% endhighlight %}

## Singular Fields - required or optional
##
##
## Merge / FromString
## ClearField

## 使用例子
- 清空message的某一个字段
    - required: 直接赋值
    - optional: 
    - repeated: m.filed:Clear()

##注意
- 不能对repeated字段调用HasField()
