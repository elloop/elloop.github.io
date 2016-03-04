#coding=utf8
import os;
import sys;

reload(sys)
sys.setdefaultencoding('utf8')

import os, sys

def walkDir(currentDir, coll):
    try:
        files = os.listdir(currentDir)
        for line in files:
            newFile = os.path.join(currentDir, line)
            if os.path.isdir(newFile):
                walkDir(newFile, coll)
            else:
                coll.append(newFile)
    except IOError:
        print("io error")

def compile_execute(name):
    compile_cmd = "g++ -std=c++11 convert_code_highlight.cpp -o {out}".format(out = name)
    print(compile_cmd)
    os.system(compile_cmd)

if __name__ == "__main__":
    execute_name = os.path.join(os.getcwd(), "convert_highlight_style.exe")
    compile_execute(execute_name)

    fileNames = []
    override_flag = "--override"    # or "--backup"
    to_style = "--to-rouge"        # or "--to-dot"
    walkDir(os.getcwd(), fileNames)
    for line in fileNames:
        if line.endswith(".md"):
            cmd = "{exe} {override} {style} {file}".format(exe = execute_name, override = override_flag, style = to_style, file = line)
            print(cmd)
            os.system(cmd)
    os.system("pause")

