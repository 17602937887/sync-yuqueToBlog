---
title: 畅通工程续 SPFA算法
date: 2018年10月21日
tags: 
	- 最短路
	- 算法
categories: kuangbin带你飞【专题六】 最短路
---
## **题目链接**：[HDU-1874][1]
</br>
## **题目描述**：

某省自从实行了很多年的畅通工程计划后，终于修建了很多路。不过路多了也不好，每次要从一个城镇到另一个城镇时，都有许多种道路方案可以选择，而某些方案要比另一些方案行走的距离要短很多。这让行人很困扰。

现在，已知起点和终点，请你计算出要从起点到终点，最短需要行走多少距离。
<escape><!-- more --></escape>

</br>

## **思路**
使用Spfa算法ac的此题；
易错点:使用前向星存图，如果只是一次计算，cnt可以只是全局初始化一次，若有多次计算，则init里面必须初始cnt = 0 ， 否则会与之前的数据冲突，发生一些意想不到的错误；
</br>

##  **代码**
``` c++
#include <bits/stdc++.h>
using namespace std;

#define MAX_N 210
#define MAX_M 2020
#define INF 0x3f3f3f3f

int dist[MAX_N], vis[MAX_N], head[MAX_M], cnt = 0;

struct Node{
    int to, val, next;
}edge[MAX_M];

void init(int n)
{
    cnt = 0;
    memset(head, -1, sizeof(head));
    memset(vis, 0, sizeof(vis));
    for(int i = 0; i<n; i++)
    {
        dist[i] = INF;
    }
}

void add(int x, int y, int val)
{
    edge[cnt].to = y;
    edge[cnt].val = val;
    edge[cnt].next = head[x];
    head[x] = cnt++;
}

void Spfa(int n, int v)
{
    dist[v] = 0;
    vis[v] = 1;
    queue<int> S;
    S.push(v);
    while(!S.empty())
    {
        int k = S.front();
        S.pop();
        vis[k] = 0;
        for(int j = head[k]; j != -1; j = edge[j].next)
        {
            int v = edge[j].to;
            if(dist[v] > edge[j].val + dist[k])
            {
                dist[v] = edge[j].val + dist[k];
                if(!vis[v])
                {
                    S.push(v);
                    vis[v] = 1;
                }
            }
        }
    }
}

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);
    int n, m;
    while(cin >> n >> m)
    {
        init(n);
        for(int i = 0; i<m; i++)
        {
            int x, y, val;
            cin >> x >> y >>val;
            add(x, y, val);
            add(y, x, val);
        }
        int x, y;
        cin >> x >> y;
        Spfa(n, x);
        dist[y] == INF ? cout << "-1" << endl : cout << dist[y] << endl;
    }
    return 0;
}



```
  [1]: http://acm.hdu.edu.cn/showproblem.php?pid=1874