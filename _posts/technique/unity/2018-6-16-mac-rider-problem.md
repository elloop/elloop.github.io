---
layout: post
title: "Mac版Rider加载、编译.Net失败，Unity插件安装失败问题"
highlighter_style: solarizeddark
category: [unity]
tags: [unity, rider]
description: ""
published: true
---

# 前言

本文记录了mac上解决Rider加载、编译.Net项目失败的问题, 以及Rider的Unity插件安装失败，导致Rider中无法正确加载Unity solution，无代码提示问题。

# 总结

出现的问题及原因

- 1). 提示MSBuild无法正确加载 Console Application

<!--more-->

![load project error](http://7xi3zl.com1.z0.glb.clouddn.com/load_project_error.png)

<font color="red">解决</font>: 安装了dotnet sdk，重启Rider , 设置(Build, Execution, Deployment --> Toolset and Build)中MSBuild会被自动设置为新安装的dotnet sdk里面的MSBuild，此时可以在Rider中成功新建、运行 .Net Core类型的 Console Application

- 2). 上面只是解决了使用Rider无法创建 .Net Core Console Application的问题，其实 此时，使用 Rider 打开 Unity 的 sln 文件，会一直在 loading project， 无法自动安装 Rider 的 Unity 插件(成功安装的话，会在 Unity 工程的 Assets/plugins/Editor/JetBrains 目录下看到 JetBrains Rider 的插件 JetBrains.Rider.Unity.Editor.Plugin.Repacked.dll)

<font color="red">解决</font>: [一番搜索之后](https://github.com/JetBrains/resharper-unity/issues/387)，定位到问题应该是MSBuild版本或者Mono Framework的版本问题，导致加载 Unity 项目失败 并且无法安装插件。观察Rider的设置中(Build, Execution, Deployment --> Toolset and Build) Mono 可执行路径为 /Library/Frameworks/Mono.framework/Versions/Current/bin/mono 看到Mono.framework 是装在 /Library/Frameworks/ 下， 我卸载unity 和 MonoDevelop 都不会 删掉它，看文件创建日期也是很久以前，这个 Mono.framework 应该是在第一次安装unity的时候装上的, 这里是个坑，我手动干掉了 Mono.Framework, 然后到 Mono 官网下了最新的 [stable release Mono.framework](http://www.mono-project.com/download/stable/) 。 安装、重启Rider，此时可以看到 Toolset and Build 设置下面已经更新了MSBuild的路劲为最新Mono版本。Rider打开unity的sln，此时已经看到Rider自动安装unity插件了，功能运转正常了。

## 结论
    
- 1) **更新升级Unity并不会自动更新 /Library/Frameworks/下的 Mono.Framework，记得跟进 Mono.framework 版本是否需要更新，建议更新 Mono Framework 到最新的稳定版** 


- 2) **在 Rider 的构建设置中(Build, Execution, Deployment --> Toolset and Build), 让Mono executable path 和 Use MSBuild version 两个地方的Mono路径一致，例如都在 /Library/Frameworks/Mono.Framework/的子目录下，以保证使用的工具链是同一套、同一个版本的Mono.framework.**


![Toolset and Build](http://7xi3zl.com1.z0.glb.clouddn.com/toolset_and_build.png)


---------------------------

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

