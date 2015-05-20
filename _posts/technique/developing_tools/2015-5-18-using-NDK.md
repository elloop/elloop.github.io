---
layout: post
title: using NDK
---
# 未解决问题
- rmdir 
- CCLog
- build/Debug.android/下面的静态库有什么用
- ndk会自动扫描目录下的cpp？为什么测试用的TestCcbContainer.cpp也被编译了?

#常见错误和注意事项
- multiple definitions symbols
    检查mk里面是否不是源文件写重复了, 如
    LOCAL_SRC_FILES := hello.cpp \
                        world.cpp \
                        ... \
                        hello.cpp
- apk安装失败提示：“已安装更高版本的”
    修改AndroidManifest.xml: 修改`versionCode`, `versionName`是显示用，不起到比较大小的作用。


# 编写Android.mk

# 编写Application.mk
- 使用c++11 thread, mutex
  以ndk-r8e为例：在Application.mk中加入：NDK_TOOLCHAIN_VERSION = 4.7 


# Install and Update
