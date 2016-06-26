---
layout: post
title: "升级Mac内置的vim"
category: tools
tags: vim 
description: ""
---

# 前言

经常使用Macvim的朋友可能会发现Mac系统自带的vim版本还是7.3+，而Macvim等主流vim版本都在7.4+了，好多强大的vim插件都要求7.4+，因此这导致了一个问题: 在命令行中敲vim，启动系统自带vim的时候，命令行会报警告信息，比如YouCompleteMe和Ultisnips插件，这意味着不能在命令行版本的vim中使用这些强大的插件，同时，每次启动都提示这些警告信息是很烦人的。

另外，好多朋友应该也会碰到的问题，那就是在Macvim中使用中文输入法的时候，在输入中文的同时，会混入大量的单引号，如果你同时开启了vim的单引号匹配功能，那么当你输入几个中文字符之后后面会跟了好大一串单引号，特别烦人（据说是因为中文输入法使用单引号分隔拼音单元造成的，我尝试了搜狗和百度等输入法均有此问题，在emacs中输入也存在此问题，系统自带的输入法没问题但是输入体验不好）。但是在命令行版本的vim中，使用中文输入法就不会出现这种问题，因此在一些需要输入大量中文的场合，系统自带（命令行）版本的vim还是很有用的。

今天刚好时间充裕，重装了系统，我就来搞定这个问题。思路其实很简单，从源码编译一个vim出来，安装到/usr/local/bin/vim或者覆盖到/usr/bin/vim即可。之前用brew安装Macvim时好像看到了安装目录里带了一个命令行版本的vim，把这个vim拷贝到/usr/local/bin或者覆盖到/usr/bin/里面应该也行，但是我没有试，现在brew上的Macvim已经被我干掉了。原因请见[安装Macvim](http://blog.csdn.net/elloop/article/details/51760992)

下面就开始从源码构建vim，过程很简单, 顺利的话5分钟之内即可搞定。只是需要踩几个坑，这里说一下，帮大家把这坑填了，O(∩_∩)O~。

如果想快速安装搞定，避开下面的废话，可以只看下面这一小段精华：

{% highlight c++ %}

# 下载Vim源代码
git clone https://github.com/vim/vim.git

# 进入源码的src目录
cd vim/src

# 如果需要开启python支持，执行这句;如果需要指定版本python路径，研究一下这个选项： ----with-python-config-dir
./configure --enable-pythoninterp 

make

make install

# 卸载的话 make uninstall 
{% endhighlight %}

<!--more-->

## 第一步，下载vim源代码

### 题外话

vim的github仓库很牛逼，牛逼在哪？

contributor只有一个人：Bram Moolenaar

分支仅有一个: master

这导致在SourceTree里看这个仓库的提交记录显得很。。。诡异？

![sourcetree_vim.png](http://7xi3zl.com1.z0.glb.clouddn.com/sourcetree_vim.png)

好了，抱歉，不啰嗦了，开始下载吧。

### 开始下载

我的代码都是放在: ~/codes目录，因此我在iterm2中切换到此目录，然后输入：

`git clone https://github.com/vim/vim.git`

稍等片刻后，vim源码就下载到~/codes/vim目录了。没记错的话，仓库大小是30~40M吧，总之不大。

## 开始安装

Mac版本的vim安装说明文件是 src/INSTALLmac.txt

仅需要切换到src目录然后执行make即可。因为我装了Xcode和CommandLineTool，因此安装过程很顺利。如果你没有安装它们，那么先运行`make --version`.

{% highlight c++ %}
cd src
make
{% endhighlight %}

make成功之后，你就会看到在src/目录下生成了vim可执行文件了。

## 可能会遇到的问题

在看到src/vim这个可执行文件生成后，我迫不及待的试验一下，看它是否还会有YCM和Ultisnips插件的vim版本过低提示，结果：

{% highlight c++ %}
➜  /Users/elloop/codes/vim/src git:(master) ./vim
Error detected while processing /Users/elloop/.vimrc:
line  432:
E484: Can't open file /usr/local/share/vim/syntax/syntax.vim
line  433:
E484: Can't open file /usr/local/share/vim/syntax/syntax.vim
YouCompleteMe unavailable: requires Vim compiled with Python (2.6+ or 3.3+) support
UltiSnips: the Python version from g:UltiSnipsUsePythonVersion (2) is not available.
Press ENTER or type command to continue
{% endhighlight %}

发现报了两个错误：

**1. 无法打开syntax.vim**

**2. YCM和UltiSnips报错vim不支持python**

第一个问题，vimrc中第432行是： `syntax enable`

提示找不到syntax.vim, 感觉上应该是路径配置的问题，比如工作路径之类的，暂时还不是很直观，暂时不管。先搞第二个问题。

第二个问题，很明显，是说编译vim的时候没有开启python支持。要确认这件事情，通过: `./vim --version`，可以看到输出信息中，python和python3前面都有一个减号 - ， 也就是说没有python support。

### 添加python support

仍然是在src/目录下：

- 清除上次的make设置：`make distclean`

- `./configure --enable-pythoninterp`

- `make`

等待片刻，构建完成，输入: `./vim --version`, 可以看到python前面有了+。代表安装python support成功。

{% highlight c++ %}
➜  /Users/elloop/codes/vim git:(master) vim --version
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Jun 26 2016 11:55:48)
MacOS X (unix) version
Included patches: 1-1952
Compiled by elloop@elloopdeMacBook-Pro.local
Huge version without GUI.  Features included (+) or not (-):
+acl             +farsi           +mouse_netterm   +tag_binary
+arabic          +file_in_path    +mouse_sgr       +tag_old_static
+autocmd         +find_in_path    -mouse_sysmouse  -tag_any_white
-balloon_eval    +float           +mouse_urxvt     -tcl
-browse          +folding         +mouse_xterm     +termguicolors
++builtin_terms  -footer          +multi_byte      +terminfo
+byte_offset     +fork()          +multi_lang      +termresponse
+channel         -gettext         -mzscheme        +textobjects
+cindent         -hangul_input    +netbeans_intg   +timers
-clientserver    +iconv           +packages        +title
+clipboard       +insert_expand   +path_extra      -toolbar
+cmdline_compl   +job             -perl            +user_commands
+cmdline_hist    +jumplist        +persistent_undo +vertsplit
+cmdline_info    +keymap          +postscript      +virtualedit
+comments        +langmap         +printer         +visual
+conceal         +libcall         +profile         +visualextra
+cryptv          +linebreak       +python          +viminfo
-cscope          +lispindent      -python3         +vreplace
+cursorbind      +listcmds        +quickfix        +wildignore
+cursorshape     +localmap        +reltime         +wildmenu
+dialog_con      -lua             +rightleft       +windows
+diff            +menu            -ruby            +writebackup
+digraphs        +mksession       +scrollbind      -X11
-dnd             +modify_fname    +signs           -xfontset
-ebcdic          +mouse           +smartindent     -xim
+emacs_tags      -mouseshape      +startuptime     -xsmp
+eval            +mouse_dec       +statusline      -xterm_clipboard
+ex_extra        -mouse_gpm       -sun_workshop    -xterm_save
+extra_search    -mouse_jsbterm   +syntax          -xpm
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
  fall-back for $VIM: "/usr/local/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H   -DMACOS_X_UNIX  -g -O2 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1
Linking: gcc   -L/usr/local/lib -o vim        -lm -lncurses  -liconv -framework Cocoa    -framework Python
{% endhighlight %}

### make install 安装Vim到/usr/local/bin 解决找不到syntax.vim的问题

运行./vim, 发现只剩下第一个问题了，google了一下，原因是VIMRUNTIMEDIR的问题，网上说的解决方法是创建symlink，但是我的情况和他们不太一样，我只是make生成了一个vim二进制文件，丢在了src目录下，还没进行安装，找不到配置文件应该是正常的，可能没安装之前，vim的资源文件还没有被拷贝到/usr/local/share/vim目录下，因此，

在src目录下，继续敲：`make install` , 可以看到vim安装程序在拷贝一些文件，完毕之后，退出终端，重新进如src目录，再执行./vim 就会发现这个错误不见了。

为了验证结果，执行: `find / -name "syntax.vim"` 可以看到/usr/local/share/vim/syntax/syntax.vim确实存在了。

此时执行：`which vim`也会看到当前的vim是/usr/local/bin/vim了，已经覆盖了系统自带的/usr/bin/vim了，也就意味着你在终端里随意输入vim，打开的就是升级后的vim了，如果非要把系统自带的那个覆盖掉，那就把/usr/local/bin/vim拷贝到/usr/bin里就行了，可能需要管理员权限，不推荐这样做。

## 如何卸载从源码编译安装的vim

在源码的src目录下，执行: `make uninstall` 即可。

如果你已经删掉了源码，那就得把它下载回来，再执行make uninstall了。或者不下载回来，但是你需要知道手动卸载需要删除哪些文件才行。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

