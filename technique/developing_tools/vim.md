#Vim Skills

# Learning VimScript
---
*following codes will ignore the `:` precede every command*.
## 1. Prerequisites
0. :help <command>
1. echo / echom (leave in :messages, useful for debuging.)

## 2 ~ 3. Echoing Messages & Setting Options
1. boolean options: :set <name> / :set no<name> / set <name>!
2. query: :set <command>? (e.g. :set numberwidth? can check the width of line number.)
3. multiple options - :set number numberwidth=6

## 4. Basic Mapping
1. map - x / map - dd     = basic
2. map <space> viw        = use name to call speical key
3. map <c-d> dd           = modifier keys {ctrl          = c, alt = m}
4. map - ddp / map - ddkP = move line down/up

## 5. Modal Mapping
1. nmap / vmap / imap     = modal mapping.
2. vmap \ U               = upper selected text in visual mode.
3. imap <c-u> <esc>viwUae = upper word under the cursor in insert mode and back in insert mode

## 6. Strict Mapping
1. donwside of common mapping = nmap - dd then nmap \ -, will make \ =  = dd
2. nunmap - / nunmap \        = remove mapping.
3. recursive mapping = try this nmap dd O<esc>jddk.
4. nonrecursive mapping

*recursive version*|*nonrecursive version*
---------------------|-----------------------
 map    |   noremap    
 nmap   |   nnoremap   
 imap   |   inoremap   
 vmap   |   vnoremap   
 
*Remember*: always use nonrecursive version. Save yourself the trouble when you install a plugin or add a new custom mapping.

## 5. Leaders
1. `mapleader`                = use in .vimrc, e.g. nnoremap <leader>- dd
2. `maplocalleader`           = can be same with `mapleader`, better not same, use in local .vim file in case to conflict with global `mapleader`
3. an example of leader value = let `mapleader` = "," / let `maplocalleader` = "\\"

## 6. More Mapping
1. `< / `> = go to last selected content's first char or last char
2. '< / '> = go to last selected content's first line or last line
---

## 7. Training your fingers
to force you use shortcut, map occord keys to <nop>
1. noremap <esc> <nop>

## Useful Command
1. echo $MYVIMRC


## 1. 常用快捷键
- 1. 折叠  

    > zR : 打开所有折叠
