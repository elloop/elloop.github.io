---
layout: post
title: "从出错中学习Git"
highlighter_style: monokai
category: tools
tags: [git]
description: ""
---

## 从出错中学习Git

### Problem 1

```bash
error: object file .git/objects/9a/83e9c5b3d697d12a2e315e1777ceaf27ea1bab is empty
fatal: loose object 9a83e9c5b3d697d12a2e315e1777ceaf27ea1bab (stored in .git/objects/9a/83e9c5b3d697d12a2e315e1777ceaf27ea1bab) is corrupt
```

solution:

```bash
$ rm -fr .git
$ git init
$ git remote add origin your-git-remote-url
$ git fetch
$ git reset --hard origin/master
$ git branch --set-upstream-to=origin/master master 
```

<!--more-->

### Problem 2

今天忽然git push到github失败，报如下错误, 本地也没有修改git相关配置，一直没使用代理也是好好的，看到github的主页图标改版了，应该是它那边修改了什么，重新安装了Github For Windows也不起作用，尝试了别人说的关闭代理，`git config --global --unset http.proxy`也没有作用，最后通过切换连接方式解决了问题：HTTPS -> SSH.

```bash
fatal: unable to access 'https://github.com/elloop/TankPongPongPong.git/': Failed connect to github.com:443; No error
```

*solution*

```bash
#查看原来的URLs
git remote -v
#下面的输出是HTTPS
origin  https://github.com/<username>/<reponame>.git (fetch)
origin  https://github.com/<username>/<reponame>.git (push)

# 切换
git remote set-url origin git@github.com:<username>/<reponame>.git

#修改之后，查看是否生效
git remote -v
#看到下面的输出就是修改成SSH了
origin  git@github.com:<username>/<reponame>.git (fetch)
origin  git@github.com:<username>/<reponame>.git (push)
```

>[参考链接](https://help.github.com/articles/changing-a-remote-s-url/)

---

## Branch相关命令
从clone说起，git clone <url>, 

- 查看本地分支: 
    **git branch**

    \* master

    clone之后本地只有一个master分支. master自动被创建为跟踪分支(详见下面说明, 它跟踪了origin/master, 使用git remote -v 查看origin的定义).

    本地修改、提交内容之后，执行：

    **git push origin master**

    会把本地的master分支同步到remote.

- 查看所有分支
    **git branch -a**
    \* master
    remotes/origin/HEAD -> origin/master
    remotes/origin/develop
    remotes/origin/master

- 切换(建立)分支：
    **git checkout origin/develop**
    Note: checking out 'origin/develop'.

    You are in 'detached HEAD' state. You can look around, make experimental changes and commit them, and you can discard any commits you make in this state without impacting any branches by performing another checkout.

    If you want to create a new branch to retain commits you create, you may do so (now or later) by using -b with the checkout command again. Example:

    git checkout -b new_branch_name

    HEAD is now at 075e05b... update suffix_tree

    正如提示所说，这仅仅是experimental的，就是你可以切到这个临时分支玩一玩，等你checkout到别的分支，在这里的所有提交都会丢失（不影响任何分支）, 要想建立一个本地分支：

    **git checkout -b local_develop**

    Switched to a new branch 'local_develop'

- 跟踪远程分支
    从远程分支 checkout 出来的本地分支，称为 跟踪分支 (tracking branch)。跟踪分支是一种和某个远程分支有直接联系的本地分支。在跟踪分支里输入 git push，Git 会自行推断应该向哪个服务器的哪个分支推送数据。同样，在这些分支里运行 git pull 会获取所有远程索引，并把它们的数据都合并到本地分支中来。

    在克隆仓库时，Git 通常会自动创建一个名为 master 的分支来跟踪 origin/master。这正是 git push 和 git pull 一开始就能正常工作的原因。当然，你可以随心所欲地设定为其它跟踪分支，比如 origin 上除了 master 之外的其它分支。刚才我们已经看到了这样的一个例子：git checkout -b [分支名] [远程名]/[分支名]。如果你有 1.6.2 以上版本的 Git，还可以用 --track 选项简化：

    **git checkout --track origin/develop**

    Branch develop set up to track remote branch develop from origin.
Switched to a new branch 'develop'

    要为本地分支设定不同于远程分支的名字，只需在第一个版本的命令里换个名字：

    **git checkout -b dev origin/develop**

    Branch dev set up to track remote branch develop from origin.
Switched to a new branch 'dev'

    现在你的本地分支 dev 会自动将推送和抓取数据的位置定位到 origin/develop 了。

- 推送到远程分支
    本地的visual-studio 分支推送到远程仓库，新建了一个远程分支

    **git push origin visual-studio:visual-studio**

    Total 0 (delta 0), reused 0 (delta 0)
    To https://github.com/elloop/TotalSTL.git
    * [new branch]      visual-studio -> visual-studio

- 删除远程分支
    手误创建了一个origin/visual-studio远程分支，现在想把它删掉

    **git push origin :origin/visual-studio**

    To https://github.com/elloop/TotalSTL.git
    - [deleted]         origin/visual-studio

    linadeMacBook-Pro:TotalSTL lina$ 

- 使用某分支(如：develop)直接覆盖另一分支(如：master)
    **git push origin develop:master -f**
---

## 其他使用Git中遇到的问题

### how to stage deleted files?
git add -u
or
try to enter sub-system of git add by typing : git add -i and following the prompt.


### git pull conflict
solve:

>
1. git stash (solve: commit your changes or stash them before you can merge)
2. git pull
3. git stash pop [stash@{0}]
4. git add <modified files> (sovle: 'commit' is not possible because you have unmerged files)
5. git commit

### difference between `git pull` and `git fetch`
solve:

- `git pull` == `git fetch` && `git merge`

### Useful Command

1. git log --pretty=oneline
2. git remote show [remote-name]
3. git branch
    -no params: show all branches.
    -v: show recently records.
    -merged/-no-merged: show those branches which has been merged or (not merged) to current branch.

