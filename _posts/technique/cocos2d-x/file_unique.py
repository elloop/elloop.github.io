#!/usr/bin/python
# coding=utf-8
# Author: fangsir
# Date: 2014.10.08
# Purpose: 该脚本用于检测出某个目录下重复的资源

import os
import time
import md5
import sys

python_version = sys.version_info[:2]

if python_version < (2, 6):
    raise Exception("This version of xlrd requires Python 2.6 or above. "
                    "For older versions of Python, you can use the 0.8 series.")

def Usgae(process_name):
	print("Usage: python %s direcotry " % process_name)

def listdir(dir, files):
	list = os.listdir(dir)

	for filename in list:
		filepath=os.path.join(dir, filename)
		if os.path.isdir(filepath) == True:
			listdir(filepath, files)
		elif filename[0] != '.':	# 过滤隐藏文件
			files.append(filepath)

	return None

# main 函数
if __name__ == "__main__":
	if len(sys.argv) != 2:
		Usgae(sys.argv[0])
		sys.exit(1)
	if os.path.isdir(sys.argv[1]) == False:
		Usgae(sys.argv[0])
		sys.exit(1)

	# 脚本开始执行时间
	time_begin=time.time()
	print("time_begin: %f" % time_begin)

	files = []
	listdir(sys.argv[1], files)

	file_md5_arr=[]
	file_md5_map={}
	# 重复的文件大小
	duplicated_size=0

	print("Getting everyfile`s md5 code.")
	for i in range(len(files), 0, -1):
		filepath=files[i-1]
		print(i)
		filesize = os.path.getsize(filepath)
		fp = open(filepath, "rb")
		filecontent = fp.read(filesize)
		fp.close()
		key = md5.new(filecontent)
		file_md5_arr.append((key.hexdigest(), filepath))

	for i in range(0, len(file_md5_arr)):
		status = file_md5_map.has_key(file_md5_arr[i][0])
		if status == True:
			value = file_md5_map.get(file_md5_arr[i][0])
			value.append(file_md5_arr[i][1])
		else:
			file_md5_map[file_md5_arr[i][0]] = [file_md5_arr[i][1],]

	for k in file_md5_map.keys():
		values = file_md5_map[k]
		arrsize = len(values)
		if arrsize > 1:
			filesize = os.path.getsize(values[0])
			for i in range(0, arrsize):
				if i == 0:
					print("----%s, filesize: %d" % (values[i][len(sys.argv[1]):], filesize))
					continue
				else:
					cmd_str = "/Users/fang/Desktop/fang_tools/FileCmp/moon_filecmp "
					cmd_str += values[0]
					cmd_str += " "
					cmd_str += values[i]
					result = os.system(cmd_str)
					if result == 0:
						duplicated_size = filesize + duplicated_size
						print("++++%s" % (values[i][len(sys.argv[1]):]))
					else:
						print("==================Oops! %s" % (values[i][len(sys.argv[1]):]))

	print("duplicated_size: %d " % duplicated_size)
	# 脚本结束执行时间
	time_end = time.time()
	# 打印出所花费时间
	print("Time cost: %d" % int(time_end - time_begin))
