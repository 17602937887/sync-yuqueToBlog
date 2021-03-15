---
title: Makefile使用总结
date: 2019年4月3日
mathjax: true
tags: 
	- Linux
	- 系统编程
categories: Linux系统编程
---
# **Makefile简介**
我们为什么要学习Makefile呢？因为他可以帮助我们节省时间，提升我们的工作效率.而且很多大型项目的编译都是通过 Makefile 来组织的, 如果没有 Makefile, 那很多项目中各种库和代码之间的依赖关系不知会多复杂.

<escape><!-- more --></escape>

# **Makefile的编写**
## **Makefile的命名方式:**
1.Makefile
2.makefile
这两者的区别就在于第一个字母是否大写，我们一般命名为Makefile；
## **Makefile的一般规则**
Makefile的最核心的内容有三部分；
1.生成目标
2.依赖文件
3.命令
![](/image/Makefile/规则.png)
如图所示，就是一个简单的Makefile；我们举一个例子来体会一下；
>main.c 
```c
#include <stdio.h>
#include "head.h"

int main()
{
    printf("%d + %d = %d\n", 1, 2, add(1, 2));
    printf("%d - %d = %d\n", 3, 4, sub(3, 4));
    printf("%d * %d = %d\n", 5, 6, mul(5, 6));
    printf("%d / %d = %d\n", 6, 3, div(6, 3));

    return 0;
}

```
>add.c
```c
#include <stdio.h>
int add(int a, int b)
{
    return a + b;
}
```
>sub.c
```c
#include <stdio.h>
int sub(int a, int b)
{
    return a - b;
}
```
>mul.c
```c
#include <stdio.h>
int mul(int a, int b)
{
    return a * b;
}
```
>div.c
```c
#include <stdio.h>
int div(int a, int b)
{
    return a / b;
}
```
这个程序的功能就是简单的实现以下加减乘除；
我们用命令
>gcc main.c add.c sub.c mul.c div.c -o mycalc

编译一下
![](/image/Makefile/编译.png)
我们可以看到，编译成功并且程序运行结果也是正确的，那么我们把这个写成Makefile；
>Makefile
```c
mycalc: main.c add.c sub.c mul.c div.c
	gcc main.c add.c sub.c mul.c div.c -o mycalc
```
然后我们重新试试能不能生成可执行程序;
![](/image/Makefile/make.png)
我们可以看到，我们在终端输入了make之后，就会自动的键入我们所指定的命令来完成编译；
那么我们分析一下这个Makefile文件;
<font color=red>mycalc</font>: main.c add.c sub.c mul.c div.c
	gcc main.c add.c sub.c mul.c div.c -o mycalc
mycalc就是目标文件，代表我这个Makefile就是要生成这个文件的;

mycalc: <font color=red>main.c add.c sub.c mul.c div.c</font>
	gcc main.c add.c sub.c mul.c div.c -o mycalc
这些.c文件是我生成目标文件的依赖项；
mycalc: main.c add.c sub.c mul.c div.c
	<font color=red>gcc main.c add.c sub.c mul.c div.c -o mycalc</font>
第二行是一个Tab缩进加一条命令，代表我生成目标所要执行的命令;

## Makefile执行命令的依据
那么Makefile如何判断自己啥时候执行命令呢？比如当我make了一次就是已经生成mycalc文件了，这时候我继续输入make，他还会重新编译嘛？答案是不会的。那么他是如何判定的呢？
>他是根据目标文件和依赖文件，最后修改时间来判定的；
比如，mycalc是在 12:00生成的，而几个依赖文件都是11:58创建的。此时我make，那么很显然，依赖文件并没有更新，则我的目标文件也就不需要更新了；反过来，只要我有一个依赖文件在12:00之后修改过，那么代表我程序的部分内容需要修改，此时就需要重新编译了;

# **Makefile的优化**
还是以上面的例子为例；当我们需要对某些函数进行修改时，如果还是刚才那样写Makefile的话，其他不需要修改的文件也需要进行重新编译，这无疑带来了很多没必要花费的时间，那我们如何解决这个问题呢？其实仔细想想也不难解决，我们只重新编译那些修改的文件，对于没有进行更新的文件我们不更新他；
![](/image/Makefile/tree.png)
我们重写一下Makefile;
```c
mycalc: main.o add.o sub.o mul.o div.o
	gcc main.o add.o sub.o mul.o div.o -o mycalc
main.o: main.c
	gcc main.c -c
add.o: add.c
	gcc add.c -c
sub.o: sub.c
	gcc sub.c -c
mul.o: mul.c
	gcc mul.c -c
div.o: div.c
	gcc div.c -c
```
然后我们重新make一下；
![](/image/Makefile/remake.png)
此时我们可以看到程序先将所有的.c编译分别为.o然后进行链接操作；
我们修改一下add.c然后重新make一下，看看他会不会只编译add.c
我们修改add，加了一条输出语句;
![](/image/Makefile/add.png)
然后make一下;
![](/image/Makefile/test.png)
我们可以看到，只是重新编译了add.c而其他的所有文件都没有进行重新编译：