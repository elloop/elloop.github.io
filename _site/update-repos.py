#!/usr/bin/env python

import os

def updateRepo(directory):
    oldDir = os.getcwd()
    os.chdir(directory)
    cmd = "git pull"
    os.system(cmd)
    os.chdir(oldDir)
    os.system("pause")

def commitRepo(directory):
    oldDir = os.getcwd()
    os.chdir(directory)

    # add
    cmd = "git add ."
    os.system(cmd)

    # commit
    msg = raw_input("commit log:")
    cmd = "git commit -m {msg}".format(msg = msg)
    os.system(cmd)

    # push
    cmd = "git push"
    os.system(cmd)

    os.chdir(oldDir)
    os.system("pause")

def mainMenu():
    choice = raw_input("c(Commit) or u(Update):")
    if choice == "c":
        repo = raw_input("b(Blog) or p(Project) or a(All):")
        if repo == "b":
            commitRepo("nblog")
        elif repo == "p":
            commitRepo("../codes/3.6/pTank")
    elif choice == "u":
        repo = raw_input("b(blog) or p(project):")
        if repo == "b":
            updateRepo("nblog")
        elif repo == "p":
            updateRepo("../codes/3.6/pTank")

mainMenu()
