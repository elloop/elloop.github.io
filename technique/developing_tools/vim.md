#Vim Skills

# Learning VimScript
---
*following codes will ignore the `:` precede every command*.
## 1. Prerequisites
0. :help *command*
1. echo / echom (leave in :messages, useful for debuging.)

## 2 ~ 3. Echoing Messages & Setting Options
1. boolean options: :set *name* / :set no*name* / set *name*!
2. query: :set *command*? (e.g. :set numberwidth? can check the width of line number.)
3. multiple options - :set number numberwidth=6

## 4. Basic Mapping
1. map - x / map - dd     = basic
2. map \<space\> viw        = use name to call speical key
3. map \<c-d\> dd           = modifier keys {ctrl          = c, alt = m}
4. map - ddp / map - ddkP = move line down/up

## 5. Modal Mapping
1. nmap / vmap / imap     = modal mapping.
2. vmap \ U               = upper selected text in visual mode.
3. imap \<c-u\> \<esc\>viwUae = upper word under the cursor in insert mode and back in insert mode

## 6. Strict Mapping
1. donwside of common mapping = nmap - dd then nmap \ -, will make \ =  = dd
2. nunmap - / nunmap \        = remove mapping.
3. recursive mapping = try this nmap dd O\<esc\>jddk.
4. nonrecursive mapping

*recursive version*|*nonrecursive version*
---------------------|-----------------------
 map    |   noremap    
 nmap   |   nnoremap   
 imap   |   inoremap   
 vmap   |   vnoremap   
 
*Remember*: always use nonrecursive version. Save yourself the trouble when you install a plugin or add a new custom mapping.

## 5. Leaders
1. `mapleader`                = use in .vimrc, e.g. nnoremap \<leader\>- dd
2. `maplocalleader`           = can be same with `mapleader`, better not same, use in local .vim file in case to conflict with global `mapleader`
3. an example of leader value = let `mapleader` = "," / let `maplocalleader` = "\\"

## 6. More Mapping
1. `< / `> = go to last selected content's first char or last char
2. '< / '> = go to last selected content's first line or last line
---

## 7. Training your fingers
to force you use shortcut, map occord keys to <nop>
1. noremap <esc> <nop>

## 8. Buffer-Local Options and Mapping
1. nnoremap  <leader>d dd
   nnoremap <buffer> <leader>x dd
   <leader>x mapping will only take effect in current buffer.

2. nnoremap <buffer> <leader>x dd is a bad habit, in local buffer you shoul use <localleader>

3. `setlocal` can change setting of current buffer.

4. shadowing: like program in c,
```
int flag = 1;
void f(int flag)
{
    if (flag == 1) 
    {

    }
}
```
flag in f() will hide the global flag.
in vim, you set following mapings:
:noremap <buffer> Q dd
:noremap          Q x

when you type Q, first Q will take effect, because <buffer> is more specific than no <buffer>.

5. setl[ocal] all : show all local settings. if it uses a global value, there will be -- before the option.
   setl[ocal] : (no parameter) show local settings that different its default value.
   setl[ocal] {option}< : use global value for {option}.
   se[t] {option}< : use global value for {option} (option is global-local option : use help global-local to learn more)

6. 
   use of <buffer>
   :map <buffer> ,w dd
   :unmap <buffer> ,w
   :mapclear <buffer>

   map-precedence
   :map <buffer> <nowait> \a   :echo "Local \a"<CR>
   :map                   \abc :echo "Global \abc"<CR>

   <nowait> will make \a work immediately ignore longer mapping \abc

## 9. Autocommands.
1. :autocmd BufNewFile *.txt :write
2. :autocmd BufWritePre, BufRead *.html :normal gg=G
3. :autocmd BufNewFile, BufRead *.html setlocal nowrap
4. :autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
more events: help autocmd-events.

## 10. Autocommand Groups
1. in order to avoid duplicate cmds, define autocmd using Autocommand Groups, like this:
```
:augroup group_name
:autocmd!
:autocmd BufWrite * :echom "write success"
... lots of other commands.
:augroup END
```

another example:
```
:augroup filetype_html
:autocmd!
:autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
:augroup END
```

## 11. Operator-Pending Mappings
1. :onoremap p i( = cp will be same with ci(, that is cp will change content in parentheses and dp will be same with di(......
2. :onoremap <buffer> b /return<cr> = notice <buffer> used like inoremap, nnoremap and vnoremap.

```
void f() {
    int i(0);
    int j(1);
    int k(0);
    return 0;
}
```
put cursor in i, and press db, will delete lines until return.

3. Change the Start
:onoremap in( :<c-u>normal! f(vi(<cr> = will select the content in next pair of parentheses
e.g.: void func(int & hello); put cursor somewhere in the word void, and type `cin(`, it will delete the content in the parentheses, and place you in insert mode between them.
or 
:onoremap il( :<c-u>normal! F)vi(<cr> = select last parentheses 

see :help omap-info

## 12. Abbreviations
vim will substitute `non-keyword` characters. (see :set iskeyword?)
1. :iabbrev adn and, :iabbrev taht that, :iabbrev @@ jacysun@gmail.com
2. why not use `map` ? 
`map` cannot take context into account when replace the target.
`abbrev` will pay attention to the characters before and after the target.
3. :iabbrev <buffer> --- &mdash = use <buffer> option.
4. :autocmd FileType python :iabbrev <buffer> iff if:<left> = remember to use augroup. 
   :autocmd FileType javascript :iabbrev <buffer> iff if()<left> = remember to use augroup

## 13. More Operator-Pending Mappings
1. :onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
type `cih`, vim will change title of markdown file.
`execute`: execute the string as a vim command script.
2. :onoremap ih :<c-u>execute "normal! ?^[\-=]\\+$\r:nohlsearch\rkvg_"<cr>
type `cih`, vim will change title of markdown both =========== or ----------- are supported.


## Useful Command
1. echo $MYVIMRC


## 1. 常用快捷键
- 1. 折叠  

    > zR : 打开所有折叠
