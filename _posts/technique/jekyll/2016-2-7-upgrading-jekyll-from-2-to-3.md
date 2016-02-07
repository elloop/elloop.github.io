---
layout: post
title: "Problems I met during upgrading jekyll from 2 to 3"
category: blog
highlighter_style: monokai
tags: [jekyll]
description: ""
---

# 2.x to 3.x 主要变化

- redcarpet `--->` kramdown (the only markdown engine)

- pygments `--->` rouge

<!--more-->

# 升级本地jekyll版本 upgrade local jekyll

```bash
gem jekyll update
```

如遇更新失败，更改gem sources或者翻墙

# deprecated paginate 

>Deprecation: You appear to have pagination turned on, but you haven't included the `jekyll-paginate` gem. Ensure you have `gems: [jekyll-paginate]` in your configuration file.

fix：

**step1:**

```bash
gem install jekyll-paginate
```

**step2:**

修改`_config.yml`:

```bash
gems:
  - jekyll-paginate
```



