---
layout: post
title: "【APUE 学习笔记】4: Unix Process Control 进程控制"
category: [unix, c++]
tags: [unix, shell]
description: ""
---

# 前言

本文是APUE第四章：文件和目录知识点的总结和代码实践的总结。

<!--more-->

# 关键点

- fork

- vfork

- exit

- exec系列

- wait, waitpid, waiid




# 实践代码

**`process_controll.cpp`**

```c++
#include "include/inc.h"
#include "include/apue.h"
#include <string>
using std::string;

NS_BEGIN(elloop);


// demonstrate sub-process holds a copy of parent process.
int globalVar = 100;
BEGIN_TEST(ProcessControll, Fork, @@);

string buff("content from buff\n");

int localV = 1;
ERR_IF(write(STDOUT_FILENO, buff.c_str(), buff.length()) != buff.length(), err_ret, "fail to write buff");

// printf("before fork!");
printf("before fork!\n");    // \n will flush stdout.

// fflush(STDOUT_FILENO);       // fflush(FILE*), not fd.
// fflush(stdout);              // flush stdout so the "before fork" won't be copied into sub-process.

pid_t pid(0);
if ((pid = fork()) < 0) {
    err_sys("fail to fork");
}
else if (pid == 0) {
    // child process.
    ++globalVar;
    ++localV;
}
else {
    // > 0, parent process.
    sleep(2);
}

printf("pid: %ld, globalVar: %d, localV: %d\n", (long)getpid(), globalVar, localV);

END_TEST;


int globalVar2 = 10;
BEGIN_TEST(ProcessControll, Vfork, @@);

int localV = 1;
printf("before vfork!\n");
pid_t pid(0);
if ((pid = vfork() ) < 0) {
    err_sys("fail to vfork");
}
else if (pid == 0) {
    // child
    ++globalVar2;
    ++localV;
    _exit(0);
    // exit(0);        // 60338 Segmentation fault: 11
}

printf("pid: %ld, globalVar2: %d, localV: %d\n", (long)getpid(), globalVar2, localV);
// pid: 60416, globalVar2: 11, localV: 2

END_TEST;

void printExit(int status) {
    if (WIFEXITED(status)) {
        printf("normal termination, exit status = %d\n", WEXITSTATUS(status));
    }
    else if (WIFSIGNALED(status)) {
        printf("abnormal termination, signal number = %d%s\n", WTERMSIG(status),
#ifdef WCOREDUMP
                WCOREDUMP(status) ?  " (core file generated)" : "");
#else
                "");
#endif
    }
    else if (WIFSTOPPED(status)) {
        printf("child stopped, signal number = %d\n", WSTOPSIG(status));
    }
}

BEGIN_TEST(ProcessControll, ExitStatus, @@);

pid_t pid;
int st;

pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (pid == 0) {
    exit(7);
}
ERR_IF(wait(&st) != pid, err_sys, "wait error");
printExit(st);

pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (pid == 0) {
    abort();
}
ERR_IF(wait(&st) != pid, err_sys, "wait error");
printExit(st);


pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (0 == pid) {
    st /= 0;
}
ERR_IF(wait(&st) != pid, err_sys, "wait error");
printExit(st);

END_TEST;

BEGIN_TEST(ProcessControll, Waitpid, @@);

pid_t pid;
pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (0 == pid) {
    // first child
    pid = fork();
    ERR_IF_NEG(pid, err_sys, "fail to fork");
    if (pid > 0) {
        exit(0);    // first child terminate.
    }

    // second child continuing... will be inherited by init process.
    sleep(2);
    printf("parent pid: %ld\n", (long)getppid());
    exit(0);
}

// parent process, wait for the first child.
ERR_IF(waitpid(pid, NULL, 0) != pid, err_sys, "waitpid error");     // NULL means don't care about the termination status of the child process.
exit(0);

END_TEST;


BEGIN_TEST(ProcessControll, RaceCondition, @@);

auto printChar = [](char* str) {
    char*   ptr;
    int     c;
    setbuf(stdout, NULL);
    for (ptr = str; (c = *ptr++) !=0; ) {
        putc(c, stdout);
    }
};

pid_t pid;
pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (0 == pid) {
    printChar("print char in child process\n");
}
else {
    printChar("print char in parent process\n");
}

END_TEST;


RUN_GTEST(ProcessControll, Exec, @@);

pid_t pid;
pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");

const char    *envInit[] = {"USER=nonono", "PATH=/tmp", NULL};
if (0 == pid) {
    int ret = execle("/Users/elloop/codes/temp/echoall", "echoall-elloop", "arg1", "arg-2", (char*)0, envInit);
    ERR_IF_NEG(ret, err_sys, "execle error");
}

ERR_IF_NEG(waitpid(pid, NULL, 0), err_sys, "wait error");

pid = fork();
ERR_IF_NEG(pid, err_sys, "fail to fork");
if (0 == pid) {
    int ret = execlp("echoall", "echoall-arg0", "only 1 arg", (char*)0);
    ERR_IF_NEG(ret, err_sys, "execlp error");
}

END_TEST;

NS_END(elloop);

```

# 错误总结

```c++
/*
 * error committed:
 *
 *      1. use int as pid type. 
 *          should be pid_t.
 *
 *      2. use (pid>0) as the fork() and vfork() return value to the child process.
 *          should be (pid == 0) to the child process.
 *
 *      3. use getpid() to get parent pid in Waitpid test case.
 *          should use getppid().
 *
 *      4. RaceCondition test case, don't act as book say. there is no intermixing of output from the two processes.
 *          should be tested in single core cpu machine.
 */

```



---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

