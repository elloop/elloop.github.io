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

**fix：**

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

# style error

>[2016-02-11 08:41:50] ERROR `/assets/themes/bootstrap/css/bootstrap.min.css' not found.</br>
[2016-02-11 08:41:50] ERROR `/assets/themes/css/style.css' not found.</br>
[2016-02-11 08:41:50] ERROR `/assets/themes/bootstrap/js/bootstrap.min.js' not found.</br>
[2016-02-11 08:41:50] ERROR `/assets/themes/bootstrap/css/colors-dark.css' not found.</br>

**fix:**

copy 

~/assets/themes/bootstrap-3/bootstrap
~/assets/themes/bootstrap-3/css

to

~/assets/themes/bootstrap
~/assets/themes/css


