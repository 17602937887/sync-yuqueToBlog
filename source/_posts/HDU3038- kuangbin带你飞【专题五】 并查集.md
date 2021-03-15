---
title: HDU3038 How Many Answers Are Wrong【并查集】
date: 2018年10月8日
tags: 
	- 并查集
	- 算法
categories: kuangbin带你飞【专题五】 并查集 
---
## **题目链接**：[HDU-3038][1]   
[kuangbin带你飞【专题五 并查集】][2]
</br>
## **题目描述**：
给定一系列的区间和，可能有一部分与之前给定的冲突；
如：第一步给出 1-10的区间和为100， 第二步给出7-10的区间和为20，第三步给出1-5的区间和为90(显然这是个与之前相冲突的语言，即错误！)                  乍看起来挺难的，其实也挺难的（23333）。感觉是带权并查集的基础？反正就是得用到向量思维+带权并查集可以过。

<escape><!-- more --></escape>

</br>

## **思路**:
　看这位巨巨的博客:[点击学习带权并查集][3]
　需要用到向量思维
　设置sum数组为当前结点到父结点的和。例如6 10 100,则设置id[6] = 10, sum[6] = 100。代表6的父结点是10，而6到10的和为100。由于A[6] + A[7] + A[8] + A[9] + A[10] = sum[10] - sum[5]，所以输入后进行处理，这样在后面的换算中可以直接得出相减得到答案。 
同样得，在带权并查集中，使用向量思维去求即可。 
【路径压缩】 
由于sum数组为当前结点到父结点的和，当将当前结点的父结点指向结点的爷爷结点，r的值需要从【当前结点到父结点的和】变成【当前结点到父结点的和 + 父结点到爷爷结点的和】.

</br>

## **易错点**：
1.输入输出有多组数据，题目并没有给出；
2.在存储区间和的时候，做端点-1 ， 易于后续的计算（这里还是手动模拟一下建树容易理解）；

##  **代码**:
``` c++
#include <bits/stdc++.h>
using namespace std;

#define MAX 200010

int pre[MAX], sum[MAX];

void init(int n)
{
    for(int i = 0; i<=n; i++)
    {
        pre[i] = i;
        sum[i] = 0;
    }
}

int Find(int x)
{
    while(pre[x] != pre[pre[x]])
    {
        sum[x] = sum[x] + sum[pre[x]];
        pre[x] = pre[pre[x]];
    }
    return pre[x];
}

void Union(int x, int y, int val)
{
    int xRoot = Find(x);
    int yRoot = Find(y);
    if(xRoot != yRoot)
    {
        pre[xRoot] = yRoot;
        sum[xRoot] = sum[y] - sum[x] + val;
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
        int ans = 0;
        init(n);
        for(int i = 0; i<m; i++)
        {
            int x, y, val;
            cin >> x >> y >> val;
            x--;
            if(Find(x) == Find(y))
            {
                if(sum[x] - sum[y] != val)
                {
                    ans++;
                }
            }
            else
            {
                Union(x, y, val);
            }
        }
        cout << ans << endl;
    }
    return 0;
}



```


  [1]: https://vjudge.net/problem/22656/origin
  [2]: https://vjudge.net/contest/66964#overview
  [3]: https://blog.csdn.net/u013075699/article/details/80379263