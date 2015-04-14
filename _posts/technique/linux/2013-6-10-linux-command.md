---
layout: post
title: linux commands
category: linux
---
# Linux 常用命令行
---
## linux按照时间查找文件
需要用到一个根据最后修改时间来处理的脚本。 

linux 文件的三种时间(以 find 为例): 
atime 最后一次访问时间, 如 ls, more 等, 但 chmod, chown, ls, stat 等不会修改些时间, 使用 ls -utl 可以按此时间顺序查看; 
ctime 最后一次状态修改时间, 如 chmod, chown 等状态时间改变但修改时间不会改变, 使用 stat file 可以查看; 
mtime 最后一次内容修改时间, 如 vi 保存后等, 修改时间发生改变的话, atime 和 ctime 也相应跟着发生改变. 
 
综上，只要文件有修改，那么ctime就会变。 
find ./ -ctime -1 当前目录一天之内修改过的文件 
find ./ -cmin -5 当前目录5分钟内修改过的文件 
 
再加强下，统计当前目录20分钟内修改过的css文件的行数 
find ./ -cmin -20 -name "*.css" |wc -l 
 
然后有时候，你在find的时候，不想查找某些子目录，比如图片 
单个目录   www.2cto.com  
find /web -path "/web/picture"  -prune -o -name "*.jsp" 
两个目录 
find /web \( -path /web/picture -o -path /web/p2 \) -prune -o -name "*.jsp" 
多个目录 
find /web \( -path /web/picture -o -path /web/p2 -o -path /web/p3 \) -prune -o -name "*.jsp"

---
