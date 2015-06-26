---
layout: post
title: windows skills
highlighter_style: monokai
category: programming
tags: [programming, windows, shell]
description: ""
---
# 例子
## 1. visual studio -> 属性 -> 配置属性 -> 生成时间 -> 命令行

```bash
if not exist "$(OutDir)" mkdir "$(OutDir)"
xcopy /Y /Q "$(EngineRoot)external\websockets\prebuilt\win32\*.*" "$(OutDir)"
xcopy "$(ProjectDir)..\Resources" "$(OutDir)" /D /E /I /F /Y
```
