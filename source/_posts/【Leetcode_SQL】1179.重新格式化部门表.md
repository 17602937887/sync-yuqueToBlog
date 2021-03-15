---
title: 【Leetcode_SQL】1179.重新格式化部门表
date: 2020年11月1日
mathjax: true
tags: 
	- MySql
	- sql刷题
categories: SQL

---
## **题目链接：**[1179.重新格式化部门表][1]   
## **题目描述：**
部门表 Department：

| Column Name   | Type    |
| ---- | ---- |
| id            | int     |
| revenue       | int     |
| month         | varchar |
(id, month) 是表的联合主键。
这个表格有关于每个部门每月收入的信息。
月份（month）可以取下列值 ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]。
 

编写一个 SQL 查询来重新格式化表，使得新的表中有一个部门 id 列和一些对应 每个月 的收入（revenue）列。
<escape><!-- more --></escape>
查询结果格式如下面的示例所示：

Department 表：

| id   | revenue | month |
| ---- | ---- | ---- |
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |

查询得到的结果表：

| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
| ----   | ---- | ---- | ---- | ---- | ---- |
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |

注意，结果表有 13 列 (1个部门 id 列 + 12个月份的收入列)。

## 思路
菜鸡落泪、并不会这道题。
**但其是经典的行转列问题，所以有必要深入探究一下！**
首先我们不难想到要查出每一个id的每个月的工资，那么则需要根据id进行分组，即我们需要用到``group by``进行分组。这里由于作者很菜，所以对``group by``进行一个较为详细的分析。

## group by语句
group by语句的作用就是根据一个或者多个列对结果集进行分组。
**然后我们可以根据分组的结果进行聚合函数的过滤或者通过聚合函数进行查询。**

举个例子:
``` sql
# 建表sql
CREATE TABLE IF NOT EXISTS stu (
	NAME VARCHAR(20) NOT NULL,
	class VARCHAR(20) NOT NULL, 
	score INT(11) NOT NULL DEFAULT 0
)ENGINE=INNODB DEFAULT CHARSET=utf8;

# 插入数据
INSERT INTO stu VALUES
	('张三', '数学', 90),
	('张三', '语文', 50),
	('张三', '英语', 80),
	('李四', '数学', 50),
	('李四', '语文', 50),
	('李四', '英语', 40),
	('王五', '数学', 90),
	('王五', '语文', 80),
	('王五', '英语', 90),
	('赵六', '数学', 40),
	('赵六', '语文', 60),
	('赵六', '英语', 80)
    
```
接下来我说几个需求，你可以尝试一下自己能否写出

**需求一: 查询该表中各个科目的名称及对应的的平均成绩**
<details> 
<summary>查看参考答案:</summary> 
<pre>
        select class, avg(score) from stu group by class;
    </pre> 
</details>

**需求二: 查询出该表各个科目不及格的人数分别是多少**
<details> 
<summary>查看参考答案:</summary> 
<pre>
        select class, sum(score < 60) from stu group by class;
        注意 此处定不能使用count来统计，因为count统计的是非空的个数，而score < 60返回值只可能是0或1，所以就会统计出学生的个数。我们用sum进行统计。
    </pre> 
</details>

**需求三: 查询出所有科目都及格的学生姓名。**
<details> 
<summary>查看参考答案:</summary> 
<pre>
        select name from stu group by name having min(score) >= 60;
    </pre> 
</details>

以第三个需求举例，通过group by之后，会产生一个不存在的虚表，如图所示
![在这里插入图片描述](/image/【Leetcode_SQL】1179.重新格式化部门表/1.png)
我们可以看到，会根据我们group by后面的字段进行分组，那么就会出现同一个字段对应多个记录行，然后我们可以对这些纪录行的字段做聚合函数操作，进而进行筛选或者提取数据。

## case when语句

### 简单函数
语法: ``CASE [col_name] WHEN [value1] THEN [result1]…ELSE [default] END``
就是类似于编程语言的switch() case语句。 枚举字段的可能值，如果满足则输出then之后的值，否则以else后面的值进行填充，如果没有else子句，则以null填充。

**注意:** 简单的case 只能做等值判断 
以stu表举例子: 我们判断学生的成绩是否为50分
```sql
# 此为包含else的情况 所以所有字段都会有值进行填充
SELECT *, (CASE score WHEN  50 THEN '是' ELSE '不是' END) AS '50分男孩？' FROM stu;
```

```sql
# 我们把else去掉之后，当score不为50时，其以null进行填充
SELECT *, (CASE score WHEN  50 THEN '是'  END) AS '50分男孩？' FROM stu;
```

### 搜索函数

语法: ``CASE WHEN [expr] THEN [result1]…ELSE [default] END``
**搜索函数可以写判断，并且搜索函数只会返回第一个符合条件的值，其他case被忽略**
搜索函数可以写判断，如 <、>、  != 等进行判断
以stu表举例子:我们判断学生的成绩是否及格

```sql
select *, (case when score < 60 then '不及格' else '及格' end) as '及格否' from stu;
```

同样 当没有else做默认值的话，以null进行填充。


## 思路
指导了这两点之后，我们便可以搞**行专列**这个操作了。
首先，我们的数据存储在纪录行中，要获取到给定id的所有其他数据 则应该根据id对数据进行分组，即group by id。 画一个图帮助大家理解。 以样例为例子
![在这里插入图片描述](/image/【Leetcode_SQL】1179.重新格式化部门表/2.png)
我们可以看到，对于同一个id，其所有的数据已经放到一个组里面了，然后我们可以根据case when语句对所需数据进行提取，如 我要第一个月的收入，我可以将when的条件设置为 month = 'Jan' then的结果为 revenue即可。
``select id, case month when 'Jan' then revenue end from Department group by id ``
**但是这里需要考虑，group by 返回的默认是第一行的数据，即你写这样case只会判断第一行的数据是否满足。 你可以执行一下下面的代码帮助你的理解**
```sql
CREATE TABLE IF NOT EXISTS Department (
	id INT(11),
	revenue INT(11),
	`month` VARCHAR(20)
)DEFAULT CHARSET = utf8;

INSERT INTO Department VALUES 
(1, 8000, 'Jan'),
(2, 9000, 'Jan'),
(3, 10000, 'Feb'),
(1, 7000, 'Feb'),
(1, 6000, 'Mar')

SELECT 
	id, 
	CASE `month` WHEN 'Jan' THEN revenue END 一月,
	CASE `month` WHEN 'Feb' THEN revenue END 二月,
	CASE `month` WHEN 'Mar' THEN revenue END 三月
FROM 
	Department 
GROUP BY id;

```

![在这里插入图片描述](/image/【Leetcode_SQL】1179.重新格式化部门表/3.png)
我们可以看到，对于id = 1的二月，三月都无法获取到正确的数据，原因就是因为分组之后的数据，没通过聚合函数操作的话，其只返回第一行，所以我们的二月 'Feb' 三月 'Mar'无法与第一行数据匹配，导致收入为null.具体看下图，图片黄色背景为与case进行匹配的记录行。
![在这里插入图片描述](/image/【Leetcode_SQL】1179.重新格式化部门表/4.png)
考虑到了这里，我们就不难想到，我们需要一个聚合函数，让每个分组的所有数据都通过case校验并返回值。
所以这里我们选取max函数或者sum函数均可。

## 参考程序

``` sql

select 
    d.id,
    max(case d.month when 'Jan' then d.revenue end) Jan_Revenue,
    max(case d.month when 'Feb' then d.revenue end) Feb_Revenue,
    max(case d.month when 'Mar' then d.revenue end) Mar_Revenue,
    max(case d.month when 'Apr' then d.revenue end) Apr_Revenue,
    max(case d.month when 'May' then d.revenue end) May_Revenue,
    max(case d.month when 'Jun' then d.revenue end) Jun_Revenue,
    max(case d.month when 'Jul' then d.revenue end) Jul_Revenue,
    max(case d.month when 'Aug' then d.revenue end) Aug_Revenue,
    max(case d.month when 'Sep' then d.revenue end) Sep_Revenue,
    max(case d.month when 'Oct' then d.revenue end) Oct_Revenue,
    max(case d.month when 'Nov' then d.revenue end) Nov_Revenue,
    max(case d.month when 'Dec' then d.revenue end) Dec_Revenue
from    
    Department d
group by
    d.id
```

  [1]: https://leetcode-cn.com/problems/reformat-department-table/