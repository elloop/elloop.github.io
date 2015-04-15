# genearte tasks for today, base on the data of dododo/year-month-day.md

import time, re
from datetime import date

# template dict.
templateDict = {}

def setTemplateDict():
    today = date.today()
    global templateDict 
    templateDict = dict(zip(["year", "month", "day"], [today.year, today.month, today.day]))

def formatTemplate(line):
    lastIndex = 0
    index = 0
    isAtPairBegin = False
    templateNames = []
    while index < len(line):
        index = str.find(line, "$", index)
        if index != -1:
            if isAtPairBegin:
                templateNames.append(line[lastIndex+1:index])
                isAtPairBegin = False
            else:
                isAtPairBegin = True
            lastIndex = index
            index = index + 1
        else:
            break
    # line = re.sub(r'[1-9]\.[0-9]+\.[0-9]+', newVersion, line)
    for template in templateNames:
        old = "${0}$".format(template)
        print(type(template))
        new = "%d" % (templateDict[template])
        print(type(new))
        line = str.replace(line, old, new)

    return line



def generateThinkingToday(templateFileName):
    fileObj = open(templateFileName, "r")
    allLines = fileObj.readlines()
    fileObj.close()
    #write
    outputFileName = "{year}-{month}-{day}-Thinking-{year}-{month}-{day}.md".format(year=templateDict["year"], month=templateDict["month"], day=templateDict["day"])
    fileObj = open(outputFileName, "w")
    for line in allLines:
        line = formatTemplate(line)
        fileObj.write(line)
    fileObj.close()


def doGenerate():
    setTemplateDict()
    generateThinkingToday("thinking_template.md")


doGenerate()


