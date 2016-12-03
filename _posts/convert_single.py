#! /usr/bin/env python
#coding=utf8
import os
import sys
import platform

reload(sys)
sys.setdefaultencoding('utf8')

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

if __name__ == "__main__":
    # compile binary tool from convert_code_highlight.cpp.
    execute_name = os.path.join(os.getcwd(), "convert_highlight_style")
    compile_cmd = "g++ -std=c++11 convert_code_highlight.cpp -o {out}".format(out = execute_name)
    print(compile_cmd)
    os.system(compile_cmd)

    
    default_override_flag = "--override"    # or "--backup"
    default_to_style      = "--to-rouge"        # or "--to-dot"

    override_flag = raw_input("input flag [%s]: " % default_override_flag)
    override_flag = override_flag or default_override_flag

    to_style = raw_input("to style [%s]:" % default_to_style)
    to_style = to_style or default_to_style

    file_name = raw_input("file name:")

    cmd = "{exe} {override} {style} {file}".format(exe = execute_name, override = override_flag, style = to_style, file = file_name)
    print(cmd)
    os.system(cmd)

    # remove binary tool.
    rm_cmd = "del {execute}.exe".format(execute = execute_name) if platform.system() == "Windows" else "rm {execute}".format(execute = execute_name)
    os.system(rm_cmd)
    print("OK, done")
    raw_input("press RET to quit.")

