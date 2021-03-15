---
title: Socket编程浅谈
date: 2019年4月1日
mathjax: true
tags: 
	- 网络编程
	- Socket
categories: Linux网络编程
---

## **套接字的基本概念**
在TCP/IP协议中，“IP地址+TCP或UDP端口号”唯一标识网络通讯中的一个进程。“IP地址+端口号”就对应一个socket。欲建立连接的两个进程各自有一个socket来标识，那么这两个socket组成的socket pair就唯一标识一个连接。因此可以用Socket来描述网络连接的一对一关系。
套接字通信原理如下图所示：
![](/image/Socket/Socket原理.png)
<font color=green>一个sfd(servert_fd)代表服务器端的文件描述符
一个cfd（client_fd）代表客户端的文件描述符</font>
与常规的文件描述符不同，Socket中的文件描述符读取和写入并不是对同一个文件进行操作，而是指向两个不同的缓冲区;
<escape><!-- more --></escape>
## **socket模型创建流程图**
![](/image/Socket/socket模型创建流程图.png)
通过此图我们可以得出，在写服务器端的时候这几个步骤是：
### 1. 创建Socket套接字 
socket()打开一个网络通讯端口，如果成功的话，就像open()一样返回一个文件描述符，应用程序可以像读写文件一样用read/write在网络上收发数据，如果socket()调用出错则返回-1。对于IPv4，domain参数指定为AF_INET。对于TCP协议，type参数指定为SOCK_STREAM，表示面向流的传输协议。如果是UDP协议，则type参数指定为SOCK_DGRAM，表示面向数据报的传输协议。protocol参数的介绍从略，指定为0即可。
Linux下函数原型是：
int socket(int domain, int type, int protocol);
第一个参数domain一般写AF_INET，代表使用IPV4地址传输；
第二个参数type一般写SOCK_STREAM或者SOCK_DGRAM;分别代表有连接的可靠的流式传输和无连接不可靠的报式传输;第一个最常见的就是TCP协议，第二个最常见的就是UDP；
第三个参数一般写0；代表使用默认的type协议；
SOCK_STREAM默认协议是TCP
SOCK_DGRAM默认协议时UDP
返回值：
	成功：返回指向新创建的socket的文件描述符，失败：返回-1，设置errno
头文件:
```c
#include <sys/types.h>
#include <sys/socket.h>
```
### 2. 绑定IP和端口
绑定程序的IP和端口
服务器程序所监听的网络地址和端口号通常是固定不变的，客户端程序得知服务器程序的地址和端口号后就可以向服务器发起连接，因此服务器需要调用bind绑定一个固定的网络地址和端口号。
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
<font>**sockfd：** socket文件描述符</font>
**addr:** 构造出IP地址加端口号
**addrlen:** sizeof(addr)长度
**返回值：** 成功返回0，失败返回-1, 设置errno
头文件:
```c
#include <sys/types.h>
#include <sys/socket.h>
```
PS：<font color=red>这里需要注意一点是:由于Socket发展过程中，有些东西的不统一，所以我们得手动让他们兼容;
现在的构造Socket结构体的类型是 struct sockaddr_in而之前我们的前辈在写一些函数时写的类型是strut sockaddr *，所以我们得手动让他们兼容；
简单来说，A发明了socket 其结构体是 struct sockaddr, A将很多函数都写好了，函数的参数类型也是 struct sockaddr；
后来B发现struct sockaddr有缺陷 就对其进行升级改造为struct sockaddr_in,但是B并没有对函数进行重写，所以我们得将struct sockaddr_in这种类型转为struct sockaddr这种类型，以便其可以在A写的函数中使用;</font>
**Socket中需要进行类型转换的函数有三个，分别是:
bind()
accept()
connect()**
## 3. listen函数 设置等待上限
listen函数原型:
int listen(int sockfd, int backlog);
<font>**sockfd:** socket文件描述符</font>
<font>**backlog:** 排队建立3次握手队列和刚刚建立3次握手队列的链接数和</font>
这个解释一下，这个函数并不是设置监听客户端的上限。而是设置等待建立连接的最大客服端的个数；比如服务器现在很繁忙，没有时间与客户端建立连接，那么客户端进入等待队列，这里设置的就是最大允许等待的个数，大于这个个数则直接忽略他的请求，不进如等待队列;
头文件:
```c
#include <sys/types.h>
#include <sys/socket.h>
```
## 4.accept函数 阻塞函数，等待客户端的连接
函数原型:
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
sockdf: socket文件描述符
addr: 传出参数，返回链接客户端地址信息，含IP地址和端口号
addrlen: 传入传出参数（值-结果）,传入sizeof(addr)大小，函数返回时返回真正接收到地址结构体的大小
返回值： 成功返回一个新的socket文件描述符，用于和客户端通信，失败返回-1，设置errno
三方握手完成后，服务器调用accept()接受连接，如果服务器调用accept()时还没有客户端的连接请求，就阻塞等待直到有客户端连接上来。addr是一个传出参数，accept()返回时传出客户端的地址和端口号。addrlen参数是一个传入传出参数（value-result argument），传入的是调用者提供的缓冲区addr的长度以避免缓冲区溢出问题，传出的是客户端地址结构体的实际长度（有可能没有占满调用者提供的缓冲区）。如果给addr参数传NULL，表示不关心客户端的地址。
头文件:
```c
#include <sys/types.h>
#include <sys/socket.h>
```
**服务器端重要的过程就是这四步**
## **代码示例:**
我们先写一个简单的服务器端的程序，对这个过程加深一下了解；
服务端的功能很简单，等待客户端输入一串字母，将字母的小写转为大写并写会客户端；
```c
#include<stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#define IP "127.0.0.1"
#define PORT 6666

int main()
{
    char buf[1024];
    int server_fd, client_fd, n, i;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len;
    // 第一步 建立socket套接字
    server_fd = socket(AF_INET, SOCK_STREAM, 0); // AF_INET 代表使用IPV4传输 SOCK_STREAM代表使用流式传输 0代表默认协议 即TCP协议
    if(server_fd == -1) // 代表创建失败 
    {
        perror("socket error:");
        exit(1); // 结束程序
    }
    // 第二步 绑定端口和IP地址
    server_addr.sin_family = AF_INET;//补全套接字的传输方式 IPV4
    server_addr.sin_port = htons(PORT);// 设置套接字的端口
    inet_pton(server_fd, IP, &server_addr.sin_addr.s_addr);//设置套接字的IP

    bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr));

    //第三步 设置服务端等待上限
    listen(server_fd, 128);

    //第四步 阻塞等待客户端连接
    client_len = sizeof(client_addr);
    client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_len);

    // 处理数据
    n = read(client_fd, buf, sizeof(buf));
    for(i = 0; i < n; i++)
        buf[i] = toupper(buf[i]);
    write(client_fd, buf, n);

    close(server_fd);
    close(client_fd);

    return 0;
}

```
你可以复制一下代码保存为socket.c
然后在终端输入
> gcc socket.c -o socket -w

然后可以看到在当前目录地下生成了一个socket的可执行程序
> ./socket

运行此程序，然后在开一个终端 输入
> nc 127.0.0.1 6666

然后输入一串字母 然后会发现服务器给你返回一串转为大写的字符串;

![](/image/Socket/测试.png)

这样我们就建立了一个比较简单的web服务器了，当然，这里用的IP是本地IP。如果你有服务器也可以将IP设置为你的公网IP，这样其他的主机也可以进行访问你的程序；（记得将你的端口放行，否则会被安全组拦截）
## 其他内容
你可能也发现了，在函数中，我们写了并未在文章中提到的函数 比如 htons() inet_pton()之类的函数，那么我们在这里再说说这些东西;
### 网络字节序
我们已经知道，内存中的多字节数据相对于内存地址有大端和小端之分，磁盘文件中的多字节数据相对于文件中的偏移地址也有大端小端之分。网络数据流同样有大端小端之分，那么如何定义网络数据流的地址呢？发送主机通常将发送缓冲区中的数据按内存地址从低到高的顺序发出，接收主机把从网络上接到的字节依次保存在接收缓冲区中，也是按内存地址从低到高的顺序保存，因此，网络数据流的地址应这样规定：先发出的数据是低地址，后发出的数据是高地址。
TCP/IP协议规定，网络数据流应采用大端字节序，即低地址高字节。例如UDP段格式，地址0-1是16位的源端口号，如果这个端口号是1000（0x3e8），则地址0是0x03，地址1是0xe8，也就是先发0x03，再发0xe8，这16位在发送主机的缓冲区中也应该是低地址存0x03，高地址存0xe8。但是，如果发送主机是小端字节序的，这16位被解释成0xe803，而不是1000。因此，发送主机把1000填到发送缓冲区之前需要做字节序的转换。同样地，接收主机如果是小端字节序的，接到16位的源端口号也要做字节序的转换。如果主机是大端字节序的，发送和接收都不需要做转换。同理，32位的IP地址也要考虑网络字节序和主机字节序的问题。
为使网络程序具有可移植性，使同样的C代码在大端和小端计算机上编译后都能正常运行，可以调用以下库函数做网络字节序和主机字节序的转换。

端口网络字节序和本地字节序直接的转化
```c
#include <arpa/inet.h>

// h表示host，n表示network，l表示32位长整数，s表示16位短整数。
uint32_t htonl(uint32_t hostlong); 
uint16_t htons(uint16_t hostshort);
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```
IP地址的网络字节序和本地字节序的转化
```c
#include <arpa/inet.h>

//p to n 代表本地的IP字符串转为网络的IP地址
int inet_pton(int af, const char *src, void *dst);
// n to p 代表网络的IP地址 转为本地的IP字符串
const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
```
