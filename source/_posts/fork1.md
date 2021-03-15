---
title: Linux下的进程浅谈（二）
date: 2019年4月5日
mathjax: true
tags: 
	- Linux
	- 系统编程
categories: Linux系统编程
---
# **进程共享**
父子进程之间在fork后。有哪些相同，那些相异之处呢？
刚fork之后：
父子相同处: 
>全局变量、.data、.text、栈、堆、环境变量、用户ID、宿主目录、进程工作目录、信号处理方式...

父子不同处: 
>1.进程ID   2.fork返回值   3.父进程ID    4.进程运行时间    5.闹钟(定时器)   6.未决信号集

子进程复制了父进程0-3G用户空间内容，以及父进程的PCB，但pid不同。
真的每fork一个子进程都要将父进程的0-3G地址空间完全拷贝一份，然后在映射至物理内存吗？
当然不是!父子进程间遵循<font color=red>读时共享写时复制</font>的原则。这样设计，无论子进程执行父进程的逻辑还是执行自己的逻辑都能节省内存开销。   
<escape><!-- more --></escape>

>验证父子进程是否共享全局变量和局部变量
```c
#include <stdio.h>
#include <unistd.h>

int a = 0; // a 为全局变量 测试 全局变量父子进程是否共享

int main()
{
    pid_t pid; // 定义返回值类型接受fork返回值
    int b = 0;// b为局部变量 测试局部变量父子进程是否共享

    pid = fork();
    if(pid == -1)// fork失败返回-1
    {
        perror("fork error:");
    }
    else if(pid == 0)// 子进程
    {
        a += 1;
        b += 2;
        printf("我是子进程 a = %d, b = %d\n", a, b);
    }
    else// 父进程
    {
        sleep(2);// 让父进程睡2s  保证子进程先结束
        a += 3;
        b += 4;
        printf("我是父进程 a = %d, b = %d\n", a, b);
    }

    return 0;
}

```
![](/image/fork/图片7.png)

由实验结果不难发现，父子进程既不共用全局变量也不共用局部变量;
# **exec函数族**	
fork创建子进程后执行的是和父进程相同的程序（但有可能执行不同的代码分支），子进程往往要调用一种exec函数以执行另一个程序。当进程调用一种exec函数时，该进程的用户空间代码和数据完全被新程序替换，从新程序的启动例程开始执行。调用exec并不创建新进程，所以调用exec前后该进程的id并未改变。
将当前进程的.text、.data替换为所要加载的程序的.text、.data，然后让进程从新的.text第一条指令开始执行，但进程ID不变，换核不换壳。
其实有六种以exec开头的函数，统称exec函数：
```c
int execl(const char *path, const char *arg, ...);
int execlp(const char *file, const char *arg, ...);
int execle(const char *path, const char *arg, ..., char *const envp[]);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
int execve(const char *path, char *const argv[], char *const envp[]);
```
## **execlp函数**
加载一个进程，借助PATH环境变量	     
```c
int execlp(const char *file, const char *arg, ...);		
```
>成功：无返回；失败：-1
    参数1：要加载的程序的名字。该函数需要配合PATH环境变量来使用，当PATH中所有目录搜索后没有参数1则出错返回。
    该函数通常用来调用系统程序。如：ls、date、cp、cat等命令。
**execlp函数示例**
```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid; // 定义返回值类型接受fork返回值

    pid = fork();
    if(pid == -1)// fork失败返回-1
    {
        perror("fork error:");
    }
    else if(pid == 0)// 子进程
    {
        execlp("ls", "ls","-l", "-a", NULL);
    }
    else// 父进程
    {
        sleep(2);// 保证子进程先结束
        printf("我是父进程\n");
    }
    printf("6666\n");

    return 0;
}
```
>运行结果

![](/image/fork/图片8.png)
我们可以发现，子进程确实执行了ls -l -a 这条命令，而且pintf("6666\n")这条语句只执行了一次，说明调用了exec函数后，里面的代码段全部更换了;
## **execl函数**
加载一个进程， 通过 路径+程序名 来加载。
```c
    int execl(const char *path, const char *arg, ...);		
```
>成功：无返回；失败：-1

对比execlp，如加载"ls"命令带有-l，-F参数
execlp("ls", "ls", "-l", "-F", NULL);使用程序名在PATH中搜索。
execl("/bin/ls", "ls", "-l", "-F", NULL); 使用参数1给出的绝对路径搜索。
也就是说execlp更换的一般都是系统的程序，而execl更换的是用户自己写的程序；
参数1用来指定程序的路径，绝对路径和相对路径都是可以的;
>hello.c
```c
#include<stdio.h>

int main()
{
    printf("Hello World!\n");
    return 0;
}

```
>fork.c
```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid; // 定义返回值类型接受fork返回值

    pid = fork();
    if(pid == -1)// fork失败返回-1
    {
        perror("fork error:");
    }
    else if(pid == 0)// 子进程
    {
        execl("hello", "hello", NULL);
    }
    else// 父进程
    {
        sleep(1);
        printf("我是父进程\n");
    }

    return 0;
}
```
我们将hello.c编译一下
>gcc hello.c -o hello

然后编译fork.c并运行 运行的结果
![](/image/fork/图片9.png)
## **exec函数族一般规律**
exec函数一旦调用成功即执行新的程序，不返回。只有失败才返回，错误值-1。所以通常我们直接在exec函数调用后直接调用perror()和exit()，无需if判断。
>l (list)			命令行参数列表
p (path)			搜素file时使用path变量
v (vector)			使用命令行参数数组
e (environment)	使用环境变量数组,不使用进程原有的环境变量，设置新加载程序运行的环境变量

# **孤儿进程与僵尸进程**
### **孤儿进程**
	孤儿进程: 父进程先于子进程结束，则子进程成为孤儿进程，子进程的父进程成为init进程，称为init进程领养孤儿进程。
```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid; // 定义返回值类型接受fork返回值

    pid = fork();
    if(pid == -1)// fork失败返回-1
    {
        perror("fork error:");
    }
    else if(pid == 0)// 子进程
    {
        while(1)
        {
            sleep(1);
            printf("我是子进程 我的PID = %d, 我父亲的PID = %d\n", getpid(), getppid());
        }
    }
    else// 父进程
    {
        sleep(5);
        printf("我是父进程, 我要去死了23333333\n");
    }

    return 0;
}
```
>程序运行结果

![](/image/fork/图片10.png)

## **僵尸进程**
僵尸进程: 进程终止，父进程尚未回收，子进程残留资源（PCB）存放于内核中，变成僵尸（Zombie）进程。 
```c
#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid; // 定义返回值类型接受fork返回值

    pid = fork();
    if(pid == -1)// fork失败返回-1
    {
        perror("fork error:");
    }
    else if(pid == 0)// 子进程
    {
        printf("我是子进程, 我的PID = %d, 我要去死了233333333333\n", getpid());
    }
    else// 父进程
    {
        while(1)
        {
            sleep(1);
            printf("我是父进程, 我很忙\n");
        }
    }

    return 0;
}
```
![](/image/fork/图片11.png)
![](/image/fork/图片12.png)
程序是想要子进程结束后，父进程一直在忙，没时间回收子进程的PCB，所以子进程就变成了僵尸态;
我们可以使用
>ps aux 

命令来查看当前运行的程序的状态 S 代表运行 Z代表僵尸态
# **wait函数**
一个进程在终止时会关闭所有文件描述符，释放在用户空间分配的内存，但它的PCB还保留着，内核在其中保存了一些信息：如果是正常终止则保存着退出状态，如果是异常终止则保存着导致该进程终止的信号是哪个。

这个进程的父进程可以调用wait或waitpid获取这些信息，然后彻底清除掉这个进程。我们知道一个进程的退出状态可以在Shell中用特殊变量$?查看，因为Shell是它的父进程，当它终止时Shell调用wait或waitpid得到它的退出状态同时彻底清除掉这个进程。


父进程调用wait函数可以回收子进程终止信息。该函数有三个功能：
>① 阻塞等待子进程退出 
② 回收子进程残留资源 
③ 获取子进程结束状态(退出原因)。
```c
pid_t wait(int *status); //成功：清理掉的子进程ID；失败：-1 (没有子进程)
```
当进程终止时，操作系统的隐式回收机制会：1.关闭所有文件描述符 2. 释放用户空间分配的内存。内核的PCB仍存在。其中保存该进程的退出状态。(正常终止→退出值；异常终止→终止信号)
可使用wait函数传出参数status来保存进程的退出状态。借助宏函数来进一步判断进程终止的具体原因。宏函数可分为如下三组：
 >1.  WIFEXITED(status) 为非0	→ 进程正常结束
	WEXITSTATUS(status) 如上宏为真，使用此宏 → 获取进程退出状态 (exit的参数)
2. 	WIFSIGNALED(status) 为非0 → 进程异常终止
	WTERMSIG(status) 如上宏为真，使用此宏 → 取得使进程终止的那个信号的编号。
3. 	WIFSTOPPED(status) 为非0 → 进程处于暂停状态
	WSTOPSIG(status) 如上宏为真，使用此宏 → 取得使进程暂停的那个信号的编号。
	WIFCONTINUED(status) 为真 → 进程暂停后已经继续运行

## **waitpid函数**
作用同wait，但可指定pid进程清理，可以不阻塞。
pid_t waitpid(pid_t pid, int *status, in options);	成功：返回清理掉的子进程ID；失败：-1(无子进程)
特殊参数和返回情况：
参数pid： 
>\> 0 回收指定ID的子进程	
-1 回收任意子进程（相当于wait）
0 回收和当前调用waitpid一个组的所有子进程
< -1 回收指定进程组内的任意子进程

返回0：参3为WNOHANG，且子进程正在运行。

注意：一次wait或waitpid调用只能清理一个子进程，清理多个子进程应使用循环。	