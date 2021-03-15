---
title: Codeforces Round 538 (Div.2)
date: 2019年2月11日
tags:  
    - Codeforces
categories: Codeforces
---

## **题目链接**：[A题][1]

## **题目描述**：
三个人吃葡萄，a只吃x类，b可以吃x类和y类，c的话x,y,z类都可以吃;
然后输入a, b, c即a b c至少需要吃的个数
然后输入x, y, z,代表每种葡萄的个数

<escape><!-- more --></escape>


## **思路**
签到题。我们可以先判断是否满足a的需求，如果不满足直接输出NO；
否则 判断剩下的x + y  >= b 如果成立 则 判断 x + y + z - b >= c是否成立  成立则输出YES， 其他情况输出的是NO

即
x >= a && x + y - a >= b && x + y + z - a - b >= c是否成立 
成立输出YES， 否则输出NO

## **AC代码:**
``` c
#include <bits/stdc++.h>
using namespace std;

#define long long long
#define INF 0x3f3f3f3f
#define MAX_N 200010
#define MAX_M 1000010

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    int a, b, c, x, y, z;
    cin >> a >> b >> c >> x >> y >> z;
    if(x >= a && x + y - a >= b && x + y + z - a - b >= c)
        cout << "YES" << endl;
    else
        cout << "NO" << endl;

    return 0;
}

```

## **题目链接**：[B题][2]

## **题目描述**：

给定n, m, k; 代表着数组元素的个数， 拆分后每个集合包含元素的最小数目，拆分为k个集合;
然后求出拆分后每个集合最大的m项的和，将着k个集合的最大和累加，求出最大和是多少，并给出拆分的位置;

## **思路**
我们会有k X m个数字相加得到最大的和； 所以我们可以对数组进行nlogn排序后，得到前 k X m 大的数字；求和得到最大值；
然后对原数组进行遍历， 当在前 k X m大的数字长度到达m后，就将这个位置看做拆分点即可;

## **AC代码:**
``` c
#include <bits/stdc++.h>
using namespace std;

#define long long long
#define INF 0x3f3f3f3f
#define MAX_N 200010
#define MAX_M 1000010

long a[MAX_N], b[MAX_N];

bool cmp(long a, long b)
{
    return a > b;
}

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    int n, m, k;
    cin >> n >> m >> k;
    for(int i = 1; i <= n; i++)
    {
        cin >> a[i];
        b[i] = a[i];
    }
    sort(b + 1, b + 1 + n, cmp);
    map<long, long> F;
    long val = 0;
    for(int i = 1; i <= k * m; i++)
    {
        F[b[i]]++;
        val += b[i];
    }
    cout << val << endl;
    int cnt = 0;
    for(int i = 1, ans = 0; i <= n; i++)
    {
        if(F[a[i]])
        {
            ans++;
            F[a[i]]--;
        }
        if(ans == m && cnt < k - 1)
        {
            cout << i << " ";
            cnt++;
            ans = 0;
        }
    }

    return 0;
}

```

## **题目链接**：[C题][3]

## **题目描述**：
题意很简单，给出一个n，一个b；
问你n的阶乘转为b进制后，末尾一共有多少个0；
注意，此题数据范围很大，需要用 long long存储

## **思路**
此题我们可以转化为 求 n!中 含有多少个因子b。 至于为啥可以这样做， 我们以栗子1看一看;
当 n = 6 ，b = 9时；

我们转9进制是这样一个过程
首先计算出 6 X 5 X 4 X 3 X 2 X 1 然后不断除以9取余；
那这个过程能不能简化呢？ 当然是可以的， 那么 我们如何使末尾产生0呢？
我们发现 如果 K 是 9的整数倍， 那么取余必定为0； 所以， 如果计算过程中出现了9的倍数， 那么就会在末尾产生一个0；

所以我们可以对b进行素因数分解， 然后对n！分解， 统计出有多少组乘积满足即可；

我们 素因数分解b后， 统计最小满足的个数即为答案；

比如 6 = 2 X 3；
若 n！ = 3 X 3 X 2 X 1 这样 我们只有一对满足；意会一下；


## **AC代码:**
``` c
#include <bits/stdc++.h>
using namespace std;

#define long long long
#define INF 0x3f3f3f3f
#define MAX_N 100010

long res[MAX_N], num[MAX_N];

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    long n, b, k = 0;
    cin >> n >> b;
    for(int i = 2; i <= b / i; i++)
    {
        if(b % i == 0)
        {
            int ans = 0;
            while(b % i == 0)
            {
                ans++;
                b /= i;
            }
            res[++k] = i;
            num[k] = ans;
        }
    }
    if(b != 1)
    {
        res[++k] = b;
        num[k] = 1;
    }
    long flag = 1, val = 0;
    for(int i = 1; i <= k; i++)
    {
        long tmp = n, sum = 0;
        while(tmp)
        {
            sum += tmp / res[i];
            tmp /= res[i];
        }
        if(flag)
        {
            flag = 0;
            val = sum / num[i];
        }
        else
        {
            val = min(val, sum / num[i]);
        }
    }
    cout << val << endl;
    return 0;
}

```


  [1]: https://codeforces.com/contest/1114/problem/A
  [2]: https://codeforces.com/contest/1114/problem/B
  [3]: https://codeforces.com/contest/1114/problem/C