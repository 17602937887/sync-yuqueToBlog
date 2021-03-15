---
title: POJ1651 Multiplication Puzzle 【区间DP】
date: 2019年2月16日
tags: 
	- 区间DP
	- 动态规划
categories: kuangbin带你飞【专题二十二】 区间DP 
---
## **题目链接**：[POJ-1651][1]   
[kuangbin带你飞【专题二十二】 区间DP ][2]
</br>
## **题目描述**：
The multiplication puzzle is played with a row of cards, each containing a single positive integer. During the move player takes one card out of the row and scores the number of points equal to the product of the number on the card taken and the numbers on the cards on the left and on the right of it. It is not allowed to take out the first and the last card in the row. After the final move, only two cards are left in the row. 

The goal is to take cards in such order as to minimize the total number of scored points. 

For example, if cards in the row contain numbers 10 1 50 20 5, player might take a card with 1, then 20 and 50, scoring 
10*1*50 + 50*20*5 + 10*50*5 = 500+5000+2500 = 8000

If he would take the cards in the opposite order, i.e. 50, then 20, then 1, the score would be 
1*50*20 + 1*20*5 + 10*1*5 = 1000+100+50 = 1150.

<escape><!-- more --></escape>

</br>

## **思路**:
这题和石子合并这道题差不多，主要是要考虑下状态转移方程；
要使整体合并费用最小，则中间过程的费用也是最小的；所以不难得出状态转移方程;
dp[i][j] = min(dp[i][j], dp[i][k] + dp[k][j] + a[i]*a[k]*a[j]);
注意：这里的i，j是开区间；举个例子
<font size=24 color=green> 10  1   50  50  20  5 </font>
对于这组数据，我们知道首位是不可以选择的，所以我们dp[i][j]，是开区间,就是不选择i和j，只对其中间的点进行枚举;
如， 要计算dp[i][j]， 我们已知dp[i][k], dp[k][j]；注意，这里是开区间，我们选择的点是k点，然后计算k点左半部分的最小费用，k点右半部分的最小费用。然后加上选择k点的费用，即可得出i到j的最小费用;

然后就是写代码，对于最外层循环，我们知道首位不能选，所以我们长度直接从3开始枚举；第二层枚举起点。注意，我这里写的是开区间(当然闭区间也可以做，但我感觉开区间更好理解)。第三层枚举选择点即可，更新dp值；
还是怕不理解，上一张图片
![在这里插入图片描述](/image/区间DP.png)
比如我们更新dp[1][7], 然后枚举点是4， 我们把枚举点当做左半部分的终点，当做有半部分的起点。然后计算左半部分的最小的有半部分的最小+当前选择后需要的费用即可更新dp[1][7]
复杂度O(n^3)

</br>

##  **代码**:
``` c
#include <iostream>
using namespace std;

#define INF 0x3f3f3f3f
#define long long long
#define MAX_N 110

int dp[MAX_N][MAX_N], a[MAX_N];

int main()
{
    int n;
    cin >> n;
    for(int i = 1; i <= n; i++)
        cin >> a[i];
    for(int k = 3; k <= n; k++)
    {
        for(int i = 1; i + k - 1 <= n; i++)
        {
            int ends = i + k - 1;
            dp[i][ends] = INF;
            for(int j = i; j < ends; j++)
            {
                dp[i][ends] = min(dp[i][ends], dp[i][j] + dp[j][ends] + a[i] * a[j] * a[ends]);
            }
        }
    }
    cout << dp[1][n] << endl;

    return 0;
}

```


  [1]: http://poj.org/problem?id=1651
  [2]: https://vjudge.net/contest/283749#overview