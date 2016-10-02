#!/usr/bin/env python
#!/sh/bin

import os

def jekyllBuild():
    #  cmd = "jekyll build"
    cmd = "bundle exec jekyll build"
    os.system(cmd)

def jekyllStart():
    cmd = "bundle exec jekyll serve --watch"
    os.system(cmd)

def restartJekyll():
    jekyllBuild()
    jekyllStart()

restartJekyll()
