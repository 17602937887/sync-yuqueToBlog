---
title: POJ2955 Brackets 【区间DP】
date: 2019年2月16日
tags: 
	- 区间DP
	- 动态规划
categories: kuangbin带你飞【专题二十二】 区间DP 
---
## **题目链接**：[POJ-2955][1]   
[kuangbin带你飞【专题二十二】 区间DP ][2]
</br>
## **题目描述**：
We give the following inductive definition of a “regular brackets” sequence:

the empty sequence is a regular brackets sequence,
if s is a regular brackets sequence, then (s) and [s] are regular brackets sequences, and
if a and b are regular brackets sequences, then ab is a regular brackets sequence.
no other sequence is a regular brackets sequence
For instance, all of the following character sequences are regular brackets sequences:

(), [], (()), ()[], ()[()]

while the following character sequences are not:

(, ], )(, ([)], ([(]

Given a brackets sequence of characters a1a2 … an, your goal is to find the length of the longest regular brackets sequence that is a subsequence of s. That is, you wish to find the largest m such that for indices i1, i2, …, im where 1 ≤ i1 < i2 < … < im ≤ n, ai1ai2 … aim is a regular brackets sequence.

Given the initial sequence ([([]])], the longest regular brackets subsequence is [([])].

<escape><!-- more --></escape>

</br>

## **思路**:
对于这道题，我们可以定义dp[i][j],表示从i到j的最大括号匹配数；
然后我们可以发现，dp[i][j] = dp[i][k] + dp[k+1][j]
我们每次更新前需要判断 s[i]是否等于s[j],如果等于 则将dp[i][j]赋值为dp[i+1][j-1]+1,不等于则赋值为dp[i+1][j-1]，然后枚举断点更新dp[i][j]即可;

</br>

##  **代码**:
``` c
#include <iostream>
using namespace std;

#define INF 0x3f3f3f3f
#define long long long
#define MAX_N 110

int dp[MAX_N][MAX_N];
string s;

bool judge(int x, int y)
{
    if( (s[x] == '(' && s[y] == ')') || (s[x] == '[' && s[y] == ']') )
        return true;
    return false;
}

int main()
{
    while(cin >> s, s != "end")
    {
        s = ' ' + s;
        for(int k = 2; k <= s.length(); k++)
        {
            for(int i = 1; i + k - 1 <= s.length(); i++)
            {
                int ends = i + k - 1;
                dp[i][ends] = judge(i, ends) ? dp[i + 1][ends - 1] + 2 : dp[i + 1][ends - 1];
                for(int j = i; j < ends; j++)
                {
                    dp[i][ends] = max(dp[i][ends], dp[i][j] + dp[j + 1][ends]);
                }
            }
        }
        cout << dp[1][s.length()] << endl;
    }

    return 0;
}

```


  [1]: http://poj.org/problem?id=2955
  [2]: https://vjudge.net/contest/283749#overview