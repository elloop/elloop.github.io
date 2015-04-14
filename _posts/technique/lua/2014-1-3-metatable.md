---
layout: post
title: metatable
category: lua
---
# Metatable
- lua中的每一个表都有metatable
- 任何一个表都可以是其他一个表的metatable，一组相关的表可以共享一个metatable
- setmetatable, getmetatable 用来设置和获得表的metatable

---

## 1. 算数运算的Metamethod(`代码`: metatable_arithmetic.lua)
可以理解为是运算符重载，重新定义表的
> +
> - 
> * 
> /
> -
> 幂
> 连接



