---
layout: post
title: Makefile Template Update
highlighter_style: monokai
category: make
tags: [c++, make]
description: ""
---

## new version of makefile on 1/12/2015

``` make
# this makefile shows how to locate src dependancies. use VPATH.
# src tree:
#
# common
#   print_util.h
#   inc.h
# stash
# 	stash.h
# 	stash.cpp (include "common/inc.h & common/print_util.h")
# main.cpp (include "common/inc.h & common/print_util.h")
# makefile
#
# execute make in current path.
#

TARGET = main.exe

OBJS = stash.o \
	   main.o

REBUILDABLE = $(TARGET) $(OBJS)

COMPILER = g++

LOCAL_CPP_FLAGS = -std=c++11

# "." is used for building stash.o to search for "common/print_util.h" and "common/inc.h"
INCLUDE_DIRS = -I"."  

# searching for stash.cpp
VPATH = ./stash
#or 
#vpath %.cpp ./stash

all : $(OBJS)
	$(COMPILER) -o $(TARGET) $^

%.o : %.cpp
	$(COMPILER) $(LOCAL_CPP_FLAGS) $(INCLUDE_DIRS) -g -o $@ -c $<

.PHONY : clean
clean:
		-rm $(REBUILDABLE)
```

## modified on the basis of this makefile
```
# This sample makefile is extracted from Eclipse's "C/C++ Development Guide -Makefile".
# A sample Makefile
# This Makefile demonstrates and explains 
# Make Macros, Macro Expansions,
# Rules, Targets, Dependencies, Commands, Goals
# Artificial Targets, Pattern Rule, Dependency Rule.

# Comments start with a # and go to the end of the line.

# Here is a simple Make Macro.
LINK_TARGET = test_me.exe

# Here is a Make Macro that uses the backslash to extend to multiple lines.
OBJS =  \
 Test1.o \
 Test2.o \
 Main.o

# Here is a Make Macro defined by two Macro Expansions.
# A Macro Expansion may be treated as a textual replacement of the Make Macro.
# Macro Expansions are introduced with $ and enclosed in (parentheses).
REBUILDABLES = $(OBJS) $(LINK_TARGET)

# Here is a simple Rule (used for "cleaning" your build environment).
# It has a Target named "clean" (left of the colon ":" on the first line),
# no Dependencies (right of the colon),
# and two Commands (indented by tabs on the lines that follow).
# The space before the colon is not required but added here for clarity.
clean : 
  rm -f $(REBUILDABLES)
  echo Clean done

# There are two standard Targets your Makefile should probably have:
# "all" and "clean", because they are often command-line Goals.
# Also, these are both typically Artificial Targets, because they don't typically
# correspond to real files named "all" or "clean".  

# The rule for "all" is used to incrementally build your system.
# It does this by expressing a dependency on the results of that system,
# which in turn have their own rules and dependencies.
all : $(LINK_TARGET)
  echo All done

# There is no required order to the list of rules as they appear in the Makefile.
# Make will build its own dependency tree and only execute each rule only once
# its dependencies' rules have been executed successfully.

# Here is a Rule that uses some built-in Make Macros in its command:
# $@ expands to the rule's target, in this case "test_me.exe".
# $^ expands to the rule's dependencies, in this case the three files
# main.o, test1.o, and  test2.o.
$(LINK_TARGET) : $(OBJS)
  g++ -g -o $@ $^

# Here is a Pattern Rule, often used for compile-line.
# It says how to create a file with a .o suffix, given a file with a .cpp suffix.
# The rule's command uses some built-in Make Macros:
# $@ for the pattern-matched target
# $< for the pattern-matched dependency
%.o : %.cpp
  g++ -g -o $@ -c $<

# These are Dependency Rules, which are rules without any command.
# Dependency Rules indicate that if any file to the right of the colon changes,
# the target to the left of the colon should be considered out-of-date.
# The commands for making an out-of-date target up-to-date may be found elsewhere
# (in this case, by the Pattern Rule above).
# Dependency Rules are often used to capture header file dependencies.
Main.o : Main.h Test1.h Test2.h
Test1.o : Test1.h Test2.h
Test2.o : Test2.h

# Alternatively to manually capturing dependencies, several automated
# dependency generators exist.  Here is one possibility (commented out)...
# %.dep : %.cpp
#   g++ -M $(FLAGS) $< > $@
# include $(OBJS:.o=.dep)
```

##  Learning from [GNU make](http://make.mad-scientist.net/papers/how-not-to-use-vpath/)
Well, then, what the heck is VPATH good for, anyway? As described in Paul's Third Rule of Makefiles, VPATH is good for finding sources, not for finding targets.

## Basic

### example 1

{% highlight make %}
objs = Vehicle.o LoadVehicle.o PassengerVehicle.o EmergencyEquipment.o EmergecyVehicle.o Decision.o main.o

v : $(objs)
	g++ -o v $(objs)

Vehicle.o : Vehicle.cpp
LoadVehicle.o : LoadVehicle.cpp
PassengerVehicle.o : PassengerVehicle.cpp
EmergencyEquipment.o : EmergencyEquipment.cpp
EmergecyVehicle.o : EmergecyVehicle.cpp
Decision.o : Decision.cpp
main.o : main.cpp

.PHONY : clean
clean : 
			-rm v $(objs) *.orig
{% endhighlight %}

