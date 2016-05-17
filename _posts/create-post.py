#!/usr/bin/env python

import os
from datetime import date

post_template = "post-template.md"
predefined_template_tags = [ \
        {"key":"year",              "default":""},
        {"key":"month",             "default":""},
        {"key":"day",               "default":""},
        {"key":"file_name",         "default":""},
        {"key":"title",             "default":""},
        {"key":"category",          "default":""},
        {"key":"tags",              "default":""},
        {"key":"description",       "default":'""'},
        {"key":"highlighter_style", "default":"solarizeddark"},
        {"key":"published",         "default":"true"} 
        ]

def setDefaultDate():
    today = date.today()
    for item in predefined_template_tags:
        if item["key"] == "year":
            item["default"] = today.year
        elif item["key"] == "month":
            item["default"] = today.month
        elif item["key"] == "day":
            item["default"] = today.day


def printTags():
    for item in predefined_template_tags:
        print(item["key"] + ": " + str(item["default"]))

# template dict.
templateDict = {}



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

    for template in templateNames:
        old = "${0}$".format(template)
        new = templateDict[template]
        line = str.replace(line, old, new)

    return line

def addTemplate(item):
    '''
    add template variable into global template dict
    '''
    if item["default"] == "":
        prompt = ":".join([item["key"], ""])
    else:
        prompt = "".join([item["key"], "(default:", str(item["default"]), "): "])

    v = raw_input(prompt)
    global templateDict
    if v == "":
        templateDict[item["key"]] = item["default"]
    else:
        templateDict[item["key"]] = v

def loadPredefinedTemplate():
    global predefined_template_tags
    for item in predefined_template_tags:
        addTemplate(item)


def createPost():

    setDefaultDate()
    loadPredefinedTemplate()

    with open(post_template, "r") as fileIn:
        allLines = fileIn.readlines()

    subDir = raw_input("director:")
    savedFileName = "{year}-{month}-{day}-{name}.md".format( \
            year=templateDict["year"], month=templateDict["month"], \
            day=templateDict["day"], name=templateDict["file_name"])

    if subDir != "":
        savedFileName = "".join(["./", subDir, "/", savedFileName])
    with open(savedFileName, "w") as f:
        for line in allLines:
            line = formatTemplate(line)
            f.write(line)

    os.system("pause")


if "__main__" == __name:
        createPost()

