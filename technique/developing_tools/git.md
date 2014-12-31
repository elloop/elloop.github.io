#
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


