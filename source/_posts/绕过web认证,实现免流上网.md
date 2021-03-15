---
title: 绕过web认证,实现免流上网
date: 2018年9月27日
tags: 破解
categories: 校园网
---

# 声明：本教程只做学习交流，切勿用于商业用途！
#### 本文并不是原创，增加了自己的搭建经验和对原教程的更加细化的描述
参考博客：https://blog.csdn.net/qq_37371161/article/details/78150628
https://www.bennythink.com/softether-vpnserver.html SoftEther VPN Server安装手记+福利 **作者：Benny小土豆** 
https://www.bennythink.com/udp53.html UDP 53免费上网、DNS隧道经验谈 **作者：Benny小土豆** 
http://blog.aizhet.com/Linux/14873.html **作者未知**

## 一、原理简介：
  在连接到某个需要 Web 认证的热点之前，我们已经获得了一个内网 IP，此时，如果我们访问某个 HTTP 网站，网关会对这个 HTTP 响应报文劫持并篡改，302 重定向给我们一个 web 认证界面（所以点 HTTPS 的网站是不可能跳转到 web 认证页面的）。详细原理可以[点击这里](http://www.ruijie.com.cn/fw/wt/36502)

我们看到了，网关（或者说交换机）都默认放行 DHCP 和 DNS 报文，也就是 UDP53 与 UDP 67。有些网关甚至不会报文进行检查，这也就意味着任何形式的数据包都可以顺畅通过。

既然如此，我们就可以在公网搞一台服务器，然后借此来免费上网，顺便还能防止网络审计——再一次画了删除线的 "免费"，其实只是把钱花在服务器上了。我们这次免费上网的主要突破点就是 UDP 53。

<escape><!-- more --></escape>

## 二、环境检测
  本文的主要针对的目标是在校大学生，且认证方式包括但不限于web认证的群体！例如，本校的校园网连接后就会弹出登陆验证页面。
![我校的验证页面](/image/web_1.png)
                                                

OK，如何进行环境检测？连上校园网，不要登陆， win+r 打开快速启动程序  输入 cmd， 点击确定。 然后输入以下内容

    nslookup www.baidu.com

 这是我得到的结果：
![检测结果](/image/web_2.png)


我们可以的看到， 在没有进行web认证的情况下，我们成功的得到了百度的ip地址。  所以可以确定我们学校是对UDP53端口不拦截的， 我们可以进行下一步操作！

如果你测试的结果并没有得到百度的ip地址，那就可以关了此页面了（当然，你可以关注我一下，下一期可能会出ipv6的免流教程）。**如果你可以顺利得到百度的ip，那么恭喜你，可以进行接下来的操作！**

## 三、服务器的购买与配置
因为大家的水平残次不齐，所以以腾讯云为例；[点击这里](https://cloud.tencent.com/)进入腾讯云，进入腾讯云，大家可以绑定一下自己的学生身份，每个月有便宜的服务器使用！然后我们进入学生专区[点击进入学生专区](https://cloud.tencent.com/act/campus)，我们选择云服务器体验套餐
![在这里插入图片描述](/image/web_3.png)


**一个月10块钱，我的买过了，所以界面可能不太一样， 大家网络配置默认即可， 系统镜像选择Ubuntu16.04（64位） 14.04（64位）即可**， ssh密匙就是你登录服务器的密码，根据自身设置。 下面是我创建好的服务器。

![云服务器](/image/web_4.png)


Xshell6下载：[点击下载](https://www.lanzous.com/i1x27wf)

然后我们用XShell连接到我们的服务器，我们打开Xshell我们点文件， 新建， 名称随意写， 主机写你的服务器的公网ip；

![在这里插入图片描述](/image/web_5.png)

然后点击用户身份认证，用户名填入ubuntu， 密码填入你刚才设置的ssh密匙；


![登陆](/image/web_6.png)
 

然后点击连接， 在弹出的对话框选择一次性接受并保存， 这时即可连接到我们的服务器！

## 四、服务器配置SoftEther VPN
对于没有学过linux的同学，可能比较难于理解。没关系，我将用最简单的方式让你成功搭建，你只需要复制粘贴即可；

**接下来的步骤， 你只需要将我写出的命令依次复制即可， 大家复制的时候可以选择右键复制， 或者shift + ins进行复制，** ctrl + v是复制不了的。 

**①下载SoftEther VPN**

    wget -e -robots=off http://files.mawenjian.net/SoftEtherVPN/softether-vpnserver-v4.10-9473-beta-2014.07.12-linux-x64-64bit.tar.gz

**②解压**

    tar -zxvf softether-vpnserver-v4.10-9473-beta-2014.07.12-linux-x64-64bit.tar.gz

**③安装**

    cd vpnserver
    ./.install.sh

期间连续输入三个“1”。

**④启动**

    ./vpnserver start

**⑤**

    ./vpncmd 

分别输入：“1” “回车” “回车”。提示符变为“VPN Server”时输入：

    ServerPasswordSet

输入你想设置的服务器管理密码即可。

## 六、 SotfEther VPN Sever 的配置
SotfEther VPN Sever下载：[点击下载](https://www.lanzous.com/i1x281a)

运行 SotfEther VPN Sever ， 点击新设置



依次输入’设置名’ ‘主机名’ 和 ‘密码’，点击确定。 

![设置](/image/web_7.jpg)
 

打开你设置的服务器，首次连接需要输入服务器的管理员密码，然后在弹出的”SoftEther VPN Server/Bridge 简单安装”面板中，选择“**VPN的其他高级配置**”。 也就是最下面的那一项

 



依次选择“管理虚拟HUB”–>“管理用户”–>“新建” 



 ![新建](/image/web_8.png)

![设置](/image/web_9.jpg)



按图片内容设置即可。 

![在这里插入图片描述](/image/web_10.jpg)

![在这里插入图片描述](/image/web_11.jpg)

**注意，监听端口一定要写53！ 然后点确定**
解压ZIP文件，找出“vm-245-240-ubunt_openvpn_remote_access_l3.ovpn”，以记事本方式打开，找到图中位置，修改对应信息，保存即可。 

![在这里插入图片描述](/image/web_12.jpg)

## 七、客户端配置OpenVPN
OpenVPN下载：[点击下载](https://www.lanzous.com/i1x27xg)

**下载并安装（推荐安装在默认目录）** 
将“vm-245-240-ubunt_openvpn_remote_access_l3.ovpn”复制到OpenVPN目录下的“config”文件夹内。

## 八、连接

运行bin目录下的“openvpn-gui.exe”。 
此时电脑右下角托盘多了一个openvpn的图标。 
右键->vm-245-240-ubunt_openvpn_remote_access_l3.ovpn->connect

输入刚刚设置的用户名密码即可。 

![在这里插入图片描述](/image/web_13.jpg)

**等这个图标变绿，这时候我们就连到网络了， 当然，这个方法手机也可以用！包括你搭建国外服务器，那就可以自带梯子，访问YouTube，google等网站！**

显然，偷渡的网络与服务器的带宽有关，~~土豪们~~ 可以通过都买服务器带宽以提高接入速度。推荐购买服务器：如果没有fq需求，买国内的阿里云，腾讯云即可。国外的推荐vultr的洛杉矶。搬瓦工的cn2.
OK！到这里就结束了， 有问题欢迎大家留言，有时间一定帮大家解决！

