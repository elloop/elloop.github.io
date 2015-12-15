import os

def getAllFiles(fileDir):
    allFiles = os.listdir(fileDir)
    for file in allFiles:
        print(file)
        npos = file.find(".py")
        if npos == -1:
            os.rename(file, "2014-6-15-" + file)

getAllFiles(os.getcwd())
