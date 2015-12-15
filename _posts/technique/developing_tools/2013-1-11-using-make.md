---
layout: post
title: Learning Make (GNU make)
highlighter_style: monokai
category: c++
tags: make
description: ""
---

## questions:
- difference between CPPFLAGS and CXXFLAGS ?
  CPPFLAGS is supposed to be for flags for the C PreProcessor; CXXFLAGS is for flags for the C++ compiler.
  The default rules in make (on my machine, at any rate) pass CPPFLAGS to just about everything, CFLAGS is only passed when compiling and linking C, and CXXFLAGS is only passed when compiling and linking C++.

<!--more-->

## compile cpp program with make
- Implicit Rules
  - predefined variables.
    To see the complete list of predefined variables for your instance of GNU make you can run `make -p` in a directory with no makefiles.

  - Compiling C++ programs
    n.o is made automatically from n.cc, n.cpp, or n.C with a recipe of the form ‘$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c’. We encourage you to use the suffix ‘.cc’ for C++ source files instead of ‘.C’.

  - Assembling and preprocessing assembler programs
    n.o is made automatically from n.s by running the assembler, as. The precise recipe is ‘$(AS) $(ASFLAGS)’.
    n.s is made automatically from n.S by running the C preprocessor, cpp. The precise recipe is ‘$(CPP) $(CPPFLAGS)’

  - Yacc for C programs
    n.c is made automatically from n.y by running Yacc with the recipe ‘$(YACC) $(YFLAGS)’.

  - Lex for C programs
    n.c is made automatically from n.l by running Lex. The actual recipe is ‘$(LEX) $(LFLAGS)’.

## Implicit Rules
- forbidden Implicit Rules: -r or --no-builtin-rules option.

## automatic variables.
they are used in recipes normally. do not use them in targets, because they are empty in targets. if you want to use them in prerequesites , you need know something about second expansion.

- $@ : target name, when the target is an archive (foo.a) use $%.
- `$<` : first prerequesite.
- $^ :  all prerequesites, no repeat.
others see GNU Make Manual.

## vpath - searching for source files
- what people say

> [GNU make](http://make.mad-scientist.net/papers/how-not-to-use-vpath/)
Well, then, what the heck is VPATH good for, anyway? As described in Paul's Third Rule of Makefiles, VPATH is good for finding sources, not for finding targets.

- examples:
  - vpath 
    vpath %.cpp ./src
    vpaht %.c ./c-src
    ...
  - VPATH
    VPATH = ./src

## variables
- the two flavors of variables
  - var = val

  - var := val, var::=val (::== is the posix standard form).

  - difference:

    - foo = $(foo) bar will cause a dead loop. because $(foo) will be expanded recursively.
      "=" form also has some performance problems.

    - foo := $(foo) bar will be expanded verbatim.
      "::=" form is useful when use shell function in makefile.

