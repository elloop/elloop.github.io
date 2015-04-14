---
layout: post
title: Git Skills
---
{{page.title}}
=======

##  git 错误 fatal: loose object...is corrupt
questions:
```
error: object file .git/objects/9a/83e9c5b3d697d12a2e315e1777ceaf27ea1bab is empty
fatal: loose object 9a83e9c5b3d697d12a2e315e1777ceaf27ea1bab (stored in .git/objects/9a/83e9c5b3d697d12a2e315e1777ceaf27ea1bab) is corrupt
```
solution:
```
$ rm -fr .git
$ git init
$ git remote add origin your-git-remote-url
$ git fetch
$ git reset --hard origin/master
$ git branch --set-upstream-to=origin/master master 
```

---
## Branch
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

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

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

---
## how to stage deleted files?
git add -u
or
try to enter sub-system of git add by typing : git add -i and following the prompt.

---
## git pull conflict
solve:
>
1. git stash (solve: commit your changes or stash them before you can merge)
2. git pull
3. git stash pop [stash@{0}]
4. git add <modified files> (sovle: 'commit' is not possible because you have unmerged files)
5. git commit

---
## difference between `git pull` and `git fetch`
solve:
- `git pull` == `git fetch` && `git merge`

# Useful Command
1. git log --pretty=oneline
2. git remote show [remote-name]
3. git branch
    -no params: show all branches.
    -v: show recently records.
    -merged/-no-merged: show those branches which has been merged or (not merged) to current branch.
