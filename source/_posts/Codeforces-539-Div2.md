---
title: Codeforces Round 539 (Div.2)
date: 2019年2月17日
tags:  
    - Codeforces
categories: Codeforces
---

## **题目链接**：[A题][1]

## **题目描述**：
给你一个长度n，然后从1这个点出发。每前进1个点需要花费1个单位的汽油。汽油的容量为v，然后在1-n每个点都可以加油，但是每单位的油价为i；问，最少花费；

<escape><!-- more --></escape>


## **思路**
签到题。
显然的，越到后面油价越高，不难想到一个贪心。
如果当前的油量不足以支撑全部路程，则将油加满。
否则可以直接走到终点，不会有额外的花费；


## **AC代码:**
``` c
#include <iostream>
using namespace std;

#define INF 0x3f3f3f3f
#define long long long
#define MAX_N 110

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    int n, v, val;
    cin >> n >> v;
    val = v;
    if(v >= n - 1) // 容量 大于等于 路程 直接输出 路程即可；因为油单价为1
    {
        cout << n - 1 << endl;
    }
    else
    {
        n--;
        int ans = 2;
        while( n - v > 0 ) // 不足以走到终点 则进行加油操作 油的价格为ans
        {
            n--;
            val += ans;
            ans++;
        }
        cout << val << endl;
    }

    return 0;
}

```

## **题目链接**：[B题][2]

## **题目描述**：
给定n个数字，让你选择一组数字(a, b) 使得 a / x + b * x < a + b;
只能选择一组，让你计算选择之后，所有数字之和最小是多少;(可以不进行选择)

## **思路**
显然的，对于要乘以x的数字而言，越小对于结果越有利。然后我们枚举x 和 选择的那个要除以x的数字即可。记录一个最大的差值；
如果这个最大的差值为正。 则答案等于 原sum - 这个差值；
否则 就是不进行改变，直接输出原来的sum即可；

## **AC代码:**
``` c
#include <iostream>
using namespace std;

#define INF 0x3f3f3f3f
#define long long long
#define MAX_N 100010

int a[MAX_N];

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    int n, MIN = INF, sum = 0;// MIN记录全部数字中最小值 sum为全部数字之和
    cin >> n;
    for(int i = 1; i <= n; i++)
    {
        cin >> a[i];
        sum += a[i];
        MIN = min(MIN, a[i]);
    }
    int MAX = -INF; // MAX 记录改变前后的最大差值
    for(int i = 2; i <= 100; i++)
    {
        for(int j = 1; j <= n; j++)
        {
            if(a[j] % i == 0)
            {
                MAX = max(MAX, a[j] + MIN - a[j] / i - MIN * i);// 记录更新前后的最大差值
            }
        }
    }
    if(MAX > 0)// 最大差值 > 0 则更新
        cout << sum - MAX << endl;
    else // 否则不更新
        cout << sum << endl;

    return 0;
}
```

## **题目链接**：[C题][3]

## **题目描述**：

给你n个数字，然后让你选择一段区间(l,r)
使得 
1.(r - l + 1) % 2 == 0 即 区间长度是偶数
2.前半段的异或值 = 后半段的异或值
询问满足这两个条件的区间共有多少个；

## **思路**
我是真的蠢！！！
我们可以考虑做一个异或前缀和fi， 然后要使区间前半段异或等于后半段异或
即: 
a[l] ^ a[l + 1] ^ .... ^ a[mid] == a[mid + 1] ^ .....^ a[r]
这个东西用前缀和的思想表示就是 f[mid] ^ f[l-1] == f[r] ^ f[mid]
那么 前半段区间异或后半段区间肯定为0
所以我们只需要统计 f[r] ^ f[l-1] == 0的个数即可;
<font color=red >至于为什么。 试想， 当f[r] ^ f[l - 1] = 0；
那么，显然可以想到对于a[l] a[l+1] ... a[r]对于异或值没有贡献，所以使得 f[r] == f[l - 1], 所以对于l - r 这段区间异或值肯定是0， 所以讲这一段任意分成两组后异或，结果一定相等。长度相等包含于任意长度，所以也成立</font>
然后我们记录在奇数位上出现每个值的个数，进行递推即可;

PS: 偶数位 ans_2[0]要初始化为1， 因为当偶数位异或为0时，他可以从0点进行选择;
统计要用long long

## **AC代码:**
``` c
#include <bits/stdc++.h>
using namespace std;

int ans_1[1<<21], ans_2[1<<21];

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    memset(ans_1, 0, sizeof(ans_1));
    memset(ans_2, 0, sizeof(ans_2));
    long long n, val = 0, ans = 0;
    cin >> n;
    ans_2[0] = 1;
    for(int i = 1, tmp; i <= n; i++)
    {
        cin >> tmp;
        val ^= tmp;
        if(i & 1)
        {
            if(ans_1[val])
                ans += ans_1[val];
            ans_1[val]++;
        }
        else
        {
            if(ans_2[val])
                ans += ans_2[val];
            ans_2[val]++;
        }
    }
    cout << ans << endl;

    return 0;
}


```


  [1]: https://codeforces.com/contest/1113/problem/A
  [2]: https://codeforces.com/contest/1113/problem/A
  [3]: https://codeforces.com/contest/1113/problem/A