---
layout: post
title: Windows Programming Accumulation
category: c++
tags: [c++, programming skills, windows]
description: "windows programming summary"
---

# Unicode in windows
## _T and __T

```c++
#ifdef UNICODE
#define __T(x)      L ## x
#else
#define __T(x)      x
#endif

#define _T(x) __T(x)
```

## how to define UNICODE in VS.
In Project setting -> common -> character set : Unicdoe or Mutibytes.

## an example of command line args parsing, with Unicode support.

 ```c++
 auto args = elloop_test::StringUtil::split(cmd_line, ' ');
    //auto args = GameMaths::tokenize(cmd_line, _T" ");
    auto iter = args.begin();
    while (iter != args.end())
    {
        if (*iter == _T("--no-console")) {
            use_console = false;
            ++iter;
        }
        else if (*iter == _T("--window-size")) {
            if ((iter + 1) != args.end() && (iter + 2) != args.end()) {
                auto width = *(iter + 1);
                #ifdef UNICODE
                DWORD len = WideCharToMultiByte(CP_OEMCP,NULL,width.c_str(),-1,NULL,0,NULL,FALSE);
                char *width_val;
                width_val = new char[len];
                WideCharToMultiByte(CP_OEMCP, NULL, width.c_str(), -1, width_val, len, NULL, FALSE);
                int w = StringConverter::parseInt(width_val, 0);
                if (w > 0) {
                    win_width = w;
                }
                delete [] width_val;
                #else
                int w = StringConverter::parseInt(width, 0);
                if (w > 0) {
                    win_width = w;
                }
                #endif

                auto height = *(iter + 2);
                #ifdef UNICODE
                len = WideCharToMultiByte(CP_OEMCP, NULL, height.c_str(), -1, NULL, 0, NULL, FALSE);
                char * height_val = new char[len];
                WideCharToMultiByte(CP_OEMCP, NULL, height.c_str(), -1, height_val, len, NULL, FALSE);
                int h = StringConverter::parseInt(height_val, 0);
                if (h > 0) {
                    win_height = h;
                }
                delete[] height_val;
                #else
                int h = StringConverter::parseInt(height, 0);
                if (h > 0) {
                    win_height = h;
                }
                #endif

                iter += 2;
            }
        }
        else {
            ++iter;
        }
    }
 ```

## 获得当前可执行文件路径

```c++
// 获取 _wpgmptr 全局变量的当前值, 
// _wpgmptr 全局变量以宽字符字符串形式包含通向与该过程关联的可执行文件的完整路径
errno_t _get_wpgmptr(     wchar_t **pValue  );

// example: cocos2d-x CCFileUtils-win32.cpp, 初始化win32资源搜索根目录
static void _checkPath()
{
    if (0 == s_resourcePath.length())
    {
        WCHAR *pUtf16ExePath = nullptr;
        _get_wpgmptr(&pUtf16ExePath);

        // We need only directory part without exe
        WCHAR *pUtf16DirEnd = wcsrchr(pUtf16ExePath, L'\\');

        char utf8ExeDir[CC_MAX_PATH] = { 0 };
        int nNum = WideCharToMultiByte(CP_UTF8, 0, pUtf16ExePath, pUtf16DirEnd-pUtf16ExePath+1, utf8ExeDir, sizeof(utf8ExeDir), nullptr, nullptr);

        s_resourcePath = convertPathFormatToUnixStyle(utf8ExeDir);
    }
}
```

## 获得当前工作目录

```c++
// GetCurrentDirectoryW (Unicode) and GetCurrentDirectoryA (ANSI)

// example: cocos2d-x CCFileUtils
static void _checkPath()
{
    if (! s_pszResourcePath[0])
    {
        WCHAR  wszPath[MAX_PATH] = {0};
        int nNum = WideCharToMultiByte(CP_ACP, 0, wszPath,
            GetCurrentDirectoryW(sizeof(wszPath), wszPath),
            s_pszResourcePath, MAX_PATH, NULL, NULL);
        s_pszResourcePath[nNum] = '\\';
    }
}
```
