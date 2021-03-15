---
title: 【Leetcode_SQL】196.删除重复的电子邮箱
date: 2020年11月2日
mathjax: true
tags: 
	- MySql
	- sql刷题
categories: SQL

---
## **题目链接：**[196.删除重复的电子邮箱][1]   
## **题目描述：**
编写一个 SQL 查询，来删除 Person 表中所有重复的电子邮箱，重复的邮箱里只保留 Id 最小 的那个。

| Id | Email |
| ---- | ---- |
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |

Id 是这个表的主键。
例如，在运行你的查询语句之后，上面的 Person 表应返回以下几行:

| Id | Email            |
| ---- | ---- |
| 1  | john@example.com |
| 2  | bob@example.com  |

<escape><!-- more --></escape>

## 思路

先理清思路，我们需要删除Email信息重复的数据且保留的是id最小的那条记录行。
delete语句的基本语法为
``delete from 表名 where 条件``
那么这里的条件显然就是 Email重复且id不为最小值的情况需要删除。
所以我们可以根据Email进行分组，会得到一个关于Email的虚拟表，然后利用聚合函数min找到最小的id，
那么需要删除的id没在这个返回集就可以被删除。

画图以明确一下。
![在这里插入图片描述](/image/【Leetcode_SQL】196.删除重复的电子邮箱/1.png)
对于分组之后的结果，我们用聚合函数min可以取到每组的最小id(为保留id)
所以不难写出sql

```sql
delete from 
    Person
where
    id not in (select min(id) from Person group by Email)
```

但是这样写会报错，是因为MySQL不允许同时对一张表进行查询和删除操作（这个和并发概念不同，这是指不允许一条sql中同时出现删除与查询。 所以我们需要将子查询封装为一张临时表以供使用

## 参考解法

```sql
delete from 
    Person
where
    id not in (select id from (select min(id) as id from Person group by Email) tmp)
```

## 菜鸡Hang_c犯的错误

**对于子查询哪里 不可以 select id from Person group by Email having id = min(id)**
因为这样，having后面条件 等于号之前的id始终为虚拟表中的第一行 而 min(id) 确实为最小id。 如果首行不为最小id 这样写就会出现错误。 所以应该为``select min(id) from Person group by Email``

  [1]: https://leetcode-cn.com/problems/delete-duplicate-emails/