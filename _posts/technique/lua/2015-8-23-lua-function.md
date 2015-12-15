---
layout: post
title: "lua中的函数-function"
category: lua
tags: [lua]
description: ""
---

## 认识lua的function
function是lua基本类型之一, 看下面一小段代码如何来定义一个函数，并且如何来确定一个东西是一个函数：

```lua
-- define a function type variable f.
function f()
    print("hello")
end

-- output type of variable f.
print(type(f))          -- output: function

-- call function f.
f()                     -- output: hello
```

通过上面的代码可以看出：

- 使用function关键字来定义一个函数
- 使用type来返回一个变量的类型(string), "function"返回值即代表它是一个函数
- 使用函数名加一对括号的形式来调用函数，这与其他语言是一样的

>type是个什么东西？使用过c系语言的同学可能认为它是个操作符，像sizeof那样。其实，type是一个函数，可以使用print(type(type))检查，你会看到输出会是"function".

<!--more-->

上面代码中的函数f, 其实就是一个变量，类似c语言里的函数指针变量，除了上面的写法我们还可以使用显示的定义变量的形式来定义函数：

```lua
-- 第二种定义函数的语法形式
f = function() 
    print("hello")
end
print(type(f))  -- 输出： function
f()             -- 输出：hello
```

这两种定义的写法是等价的

### table中的function
当函数变量是table中的一个字段的时候，我们使用下面的形式来定义函数：

```lua
local t = { x = 10 }
function t.f()
    print(t.x)
end

--[[ or
t.f = function() 
    print(t.x) 
end
--]]

t.f()   -- output: 10
```

## 面向对象风格的function
lua可以借助table实现面向对象编程，而面向对象的基本要素就是类，学过c++的同学都知道类是有成员变量和成员函数组成的。那么lua里面的成员函数是怎么实现的呢？

当然是使用function了，只不过这里又多了一种定义function的语法形式：

```lua
local t = { x = 10 }

function t:f()
    print(self.x)
end

t:f()
```

上面的代码使用了表名+冒号的形式定义了一个函数f，调用的时候也是使用冒号t:f()的形式. self是调用者传给f的第一个参数（隐含的）, 就像c++里的this，它代表了调用此函数的table本身，比如在上面的代码中，使用t:f()的方式调用f, self就等于t，self.x就是t.x

不过，如果使用t.f()这种形式来调用f会是什么结果？答案是会报错。

```lua
t.f()

-- error:
stdin:1: attempt to index local 'self' (a nil value)
stack traceback:
    stdin:1: in function 'f'
    stdin:1: in main chunk
    [C]: ?
```

可以看到，lua解释器说self是nil。这是因为t.f()这种形式并没有传递任何参数到f，因此在f函数体内的self没有被赋值，即为nil。而t:f()这种形式其实等价于：t.f(t), 把自己传入了f函数，这样f就会把第一个参数绑定到self，这样就不会报错了。下面我们使用t.f(t)试一下：

```lua
t.f(t) -- output: 10
```

这回没有报错了。综上所述，我们得到以下结论：

- `结论1`：当使用function t:f(args) end这种形式定义函数f的时候，合法的调用形式有两种：1. t:f(args); 2. t.f(t, args)

如果table中的函数不是使用冒号的定义形式呢？即如果t.f是如下的定义形式，但是使用t:f()的方式调用呢？

```lua
local t = { x = 10 }
function t.f()
    print(t.x)
end

t:f() -- what will happen?
```

上面这段代码会正确的输出10，相信你已经想到了，见到t:f()翻译成t.f(t)就ok了，因此这个调用不会报错，只不过是多传了一个没用的参数到f而已

这是不是代表能使用t.f调用的地方都可以使用t:f代替呢？答案是不能完全代替，看下面的例子：

```lua
local t = { x = 10 }
function t.add(a)
    t.x = t.x + a
end

t.add(100)
print(t.x)  -- output: 110

t:add(100)    -- is this ok?
print(t.x)
```

你能想到上面t:f(100)之后的输出结果吗？ 答案是：

```lua
stdin:1: attempt to perform arithmetic on local 'a' (a table value)
stack traceback:
    stdin:1: in function 'add'
    stdin:1: in main chunk
    [C]: ?
```

>请忽略报错信息中的行号，因为我是使用终端交互方式测试的lua代码。

我们把t:add(100)展开一下，结果是t.add(t, 100), 这意味着add的形参a会被赋值为t，而不是100，结果add的函数体被替换为t.x = t.x + t, 并不是我们想要的t.x = t.x + 100. t.x和t相加就会得到上面的报错信息(通常情况下，一个number和一个table是不能相加的)

通过上面这个例子，我们知道t:f这种调用方式的使用范围是有一定的限制的，它强行把t绑定到f的第一个形参，因此一旦f是一个带参数的函数，使用t:f这种调用方式是肯定会出错的（除非f的第一个形参就是想要用t）

- `结论2`：当使用function t.f(args) end这种形式定义函数f的时候，应该使用t.f(args)这种调用形式.

只要记住t:f() == t.f(t)就不会出现上面提到的调用问题了。

>**t:f()这种调用方式是为了实现面向对象风格程序设计而提供的语法糖，本质上的函数调用方法只有一种：t.f(args)**

要意识到一个事情，function t.f() end 这种形式的函数定义，其函数体内部是没有self这个变量的。而function t:f() end 这种形式，只要是合理的调用，其内部是有一个self变量的。

```lua
local t = { x = 10 }
function t.f()
    if self then
        print(self.x)
    else
        print("self is nil in t.f() ")
    end
end

function t:g()
    if self then
        print(self.x)
    else
        print("self is nil in t:g()")
    end
end

t.f(t)              -- output: self is nil in t.f()
t.g(t)              -- output: 10
t.g()               -- output: self is nil in t:g()
```

通过上面的例子可以看出，t:g()形式的函数定义，其实是有一个隐含的形参self的, 而t.f()形式的定义则没有这个形参. 下面的代码就是t:g()的等价定义形式.

```lua
function t.g(self)
    if self then
        print(self.x)
    else
        print("self is nil in t:g()")
    end
end
```

### 定义和调用形式总结
- `定义中，t:f(args) 可以用 t.f(self, args) 来等价代替`
- `调用中，t:f(args) 可以用 t.f(t, args) 来等价代替`

