---
layout: post
title: Git Skills
---
{{page.title}}

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

## git clone all branches.
$ git branch -a
* master
  origin/HEAD
  origin/master
  origin/v1.0-stable
  origin/experimental
如果你现快速的代上面的分支，你可以直接切换到那个分支：
$ git checkout origin/experimental
但是，如果你想在那个分支工作的话，你就需要创建一个本地分支：
$ git checkout -b experimental origin/experimental
现在，如果你看看你的本地分支，你会看到：
$ git branch
  master
* experimental
你还可以用git remote命令跟踪多个远程分支
$ git remote add win32 git://gutup.com/users/joe/myproject-linux-port
$ git branch -a
* master
  origin/HEAD
  origin/master
  origin/v1.0-stable
  origin/experimental
  linux/master
  linux/new-widgets
## how to stage deleted files?
git add -u
or
try to enter sub-system of git add by typing : git add -i and following the prompt.

## git pull conflict
solve:
>
1. git stash (solve: commit your changes or stash them before you can merge)
2. git pull
3. git stash pop [stash@{0}]
4. git add <modified files> (sovle: 'commit' is not possible because you have unmerged files)
5. git commit

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
