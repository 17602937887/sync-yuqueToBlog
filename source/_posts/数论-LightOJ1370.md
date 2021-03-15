---
title:  Bi-shoe and Phi-shoe  【欧拉函数】
date: 2018年11月22日
tags: 
    - phi
    - 数论
categories: kuangbin带你飞 专题十四 数论基础
---
## **题目链接**：[LightOJ-1370][1]
[【kuangbin带你飞】专题十四 数论基础][2]
</br>
## **题目描述**：
Bamboo Pole-vault is a massively popular sport in Xzhiland. And Master Phi-shoe is a very popular coach for his success. He needs some bamboos for his students, so he asked his assistant Bi-Shoe to go to the market and buy them. Plenty of Bamboos of all possible integer lengths (yes!) are available in the market. According to Xzhila tradition,

Score of a bamboo = Φ (bamboo's length)

(Xzhilans are really fond of number theory). For your information, Φ (n) = numbers less than n which are relatively prime (having no common divisor other than 1) to n. So, score of a bamboo of length 9 is 6 as 1, 2, 4, 5, 7, 8 are relatively prime to 9.

The assistant Bi-shoe has to buy one bamboo for each student. As a twist, each pole-vault student of Phi-shoe has a lucky number. Bi-shoe wants to buy bamboos such that each of them gets a bamboo with a score greater than or equal to his/her lucky number. Bi-shoe wants to minimize the total amount of money spent for buying the bamboos. One unit of bamboo costs 1 Xukha. Help him.
<escape><!-- more --></escape>

</br>

## **思路**

题意就是说给定一列数，然后求出比这个数大的phi的最小值是多少；
例如:给定的数字为 2, 我们知道phi[2] = 1, phi[3] = 2,phi[4] = 2....;
我们可以发现，phi[3]和phi[4] 都是等于2，满足phi[] >= 2 ，而且值也是 > 2，所以这时候3,4都是满足题意的，但是k最小，所以我们只能取3；
由于欧拉函数的性质，phi[p] = p - 1, 当p是素数的时候； 当给出的数字不是素数时 ，这时候的phi一定会 < 给出的值的； 所以，我们只需要找到比这个数大的最小的质数，然后累加输出答案即可；
我们用欧拉筛或者按个nlglgn的筛，筛出前1e6数据，直接搜就可以了。

PS：累加的过程会爆int，开long long 可以过;


##  **代码** 
``` c
#include <bits/stdc++.h>
using namespace std;

#define MAX_N 1000010

bool check[MAX_N];
int prime[MAX_N];

void fun()
{
    memset(check, 0, sizeof(check));
    check[0] = check[1] = 1;
    int ans = 0;
    for(int i = 2; i < MAX_N; i++)
    {
        if(!check[i])
        {
            prime[ans++] = i;
        }
        for(int j = 0; j < ans && i * prime[j] < MAX_N; j++)
        {
            check[i * prime[j]] = 1;
            if(prime[j] % i == 0)
                break;
        }
    }
}

int main()
{
    int t;
    fun();
    cin >> t;
    for(int k = 1; k <= t; k++)
    {
        long long n, ans = 0;
        cin >> n;
        for(int i = 0; i < n; i++)
        {
            int tmp;
            cin >> tmp;
            for(int j = tmp+1; ; j++)
            {
                if(!check[j])
                {
                    ans += j;
                    break;
                }
            }
        }
        cout << "Case " << k << ": " << ans << " Xukha" << endl;
    }
    return 0;
}


```


  [1]: http://lightoj.com/login_main.php?url=volume_showproblem.php?problem=1370
  [2]: https://vjudge.net/contest/70017#overview