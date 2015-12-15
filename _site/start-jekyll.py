#!/usr/bin/env python
#!/sh/bin

import os

def jekyllBuild():
    cmd = "jekyll build"
    os.system(cmd)

def jekyllStart():
    cmd = "jekyll serve --watch"
    os.system(cmd)

def restartJekyll():
    jekyllBuild()
    jekyllStart()

restartJekyll()
