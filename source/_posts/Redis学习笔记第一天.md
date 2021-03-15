---
title:  Redis学习笔记第一天
date: 2020年11月4日
tags: 
	- 数据库
	- 面试
categories: Redis
---
![在这里插入图片描述](/image/插图/柯南1.jpg)
<escape><!-- more --></escape>

# 关系型数据与非关系型数据库

## 关系型数据库

### 概念
关系型数据库就是指采用了关系模型来组织、存储数据的数据库。可以理解为二维的表格。每一行对应着一条纪录，而每一列代表着不同的属性。

主流的关系型数据库管理软件有: MySql、SqlServer、Oracle

### 优点
(1) 容易理解，二维表格的结构与人类思维符合。
(2) 使用方便，因为大多数关系型数据库都遵循sql标准，当你熟悉了某一种sql语法后，可以迅速学会另一套数据库管理软件的sql语法。
(3) 易于维护，数据库的ACID(原子性、一致性、隔离性、持久性)属性，大大降低了数据数据冗余和数据不一致的概率。

### 瓶颈
(1) 海量数据的读写效率
**对于网站的并发量高，往往打到每秒上万次的请求，对于传统的关系型数据库来说，磁盘的IO是一个很大的挑战**
(2) 高扩展性和可用性
在基于Web的结构中，数据库是最难以横向拓展的(**对数据添加列**)，当一个应用系统的用户量和访问量与日俱增的时候，数据库没有办法像Web Server那样简单的通过添加更多的硬件和服务节点来拓展性能和复杂能力。

### 从关系型到非关系型
关系型数据库的最大优点就是事务的一致性，这个特性，使得关系型数据库中可以适用于一切要求一致性比较高的系统中。 比如: 银行系统。
 但是在网页应用中，对这种一致性的要求不是那么的严格，允许有一定的时间间隔，所以关系型数据库这个特点不是那么的重要了。相反，关系型数据库为了维护一致性所付出的巨大代价就是读写性能比较差。而像微博、facebook这类应用，对于并发读写能力要求极高，关系型数据库已经无法应付。所以必须要用一种新的数据结构存储来代替关系型数据库。所以非关系型数据库应用而生。
 
 ## 非关系型数据库
 
### 概念

NoSQL(Not Only Sql) 非关系型数据库，主要是指非关系型、分布式的且一般不保证ACID的数据存储系统，主要代表有MongoDB、Redis等

NoSQL提出了另一种概念、以键值来存储数据、且结构不稳定，每一个元组都可以有不一样的字段，这种就不会局限于固定的结构，可以减少一些时间和空间的开销。使用这种方式，为了获取用户的不同信息，不需要像关系型数据库中，需要进行多表查询。仅仅需要根据key来取出对应的value即可。

### 分类
非关系型数据库大部分是开源的，实现比较简单，大都是针对一些特性的应用需求出现的。
可以根据结构化方法和应用场景的不同，分为以下几类。
(1) 面向高性能并发读写的**key-value**数据库
主要特点是具有极高的并发读写能力，例如Redis，Tokyo Cabint等。
(2) 面向海量数据访问的面向文档数据库
特点是，可以在海量的数据库中快速的查询数据。例如MongoDB、CouchDB
(3) 面向可拓展的分布式数据库
解决的主要问题是传统数据库的扩展性上的缺陷。

### 缺点
由于Nosql约束少，所以不能像sql那样提供where字段属性的查询。
因此适合存储较为简单的数据。有一些不能够持久化数据，所以需要和关系型数据库结合。

## 对比

### 存储上
关系型数据库以数据库表的形式存储数据。NoSql采用**key-value**的形式存储

### 事务
在关系型数据库中，可以通过开启事务一次执行多条sql语句，要么同时成功要么同时失败，可以保证数据的一致性。

而在NoSql中，没有事务这一个概念，每一个数据集都是原子级别的。

### 数据表和数据集
关系型数据库是表格型的，存储在数据表的行和列中。彼此关联，容易提取。

而非关系型数据库是大块存储在一起。

### 预定义结构与动态结构
在关系型数据库中，必须先定义好字段和表结构之后，才能进行数据的增删改查。
而在 非关系型数据库中，可以在任何时候任何地方进行添加，无需语线定义表结构。


# 常用的命令

## 未连接服务器端

连接Redis服务器端
+ ``redis-cli -h host -p port -a password``
默认的配置文件中没有开启远程访问，我们需要修改配置文件。
1. 将bind 绑定ip改为 0.0.0.0
2. 将proteched-mode 改为 no
3. 将requirepass 开启， 后面的value就是你要设置的密码
4. 重启redis服务即可。

在redis中，默认有16个库，我们可以通过修改配置文件进行修改此配置。
即 databases 后面的value值 然后重启redis服务即可。
我们可以在客户端使用 ``config get databases``命令获取当前有多少个库以供使用。 

## 已连接服务器端

+ 使用``select index``进行库的切换
+ 使用 ``keys *`` 查询所有的键
+ 使用 ``flushdb``清空当前库
+ 使用``flushall`` 清空所有库
+ 使用 ``dbsize``查看当前库的键数量
+ 使用 ``move key index`` 移动当前键值对到其他库 返回1代表成功 返回0代表失败(其他库存在同名键则失败
+ 使用 ``exists key``来判断某一个key值是否存在。  返回1代表存在 返回0代表不存在
+ 使用 ``expire key seconds`` 对键值key设置过期时间 单位是秒
+ 使用 ``persist key`` 解除key的过期时间 使得key持久保持
+ 使用 ``ttl key`` 查看当前key还有多少秒过期。 -1为永不过期 -2 不存在或已过期
+ 使用 ``type key`` 查看key值的类型
+ 使用 ``del key [ke....]`` 用于删除键. 返回成功删除的键的个数
+ 使用 ``rename key newkey`` 用于修改key的名称
+ 使用 ``renamenx key newkey`` 当newkey不存在时 才将key改为newkey


# Redis五种基本数据类型

## String
+ String类型是redis最基本的类型，一个key对应着一个value。
+ String类型是二进制安全的。意思是redis的string可以包含任何数据类型，比如jpg图片或者序列化的对象等
+ 在redis中，一个string最多可以是512M

### 常用命令
+ ``set key value`` 设置key的值为value 当key已存在于当前表 则更新
+ ``get key`` 获取key所对应的value值
+ ``append key value`` 如果key是一个已经存在并且为字符串，则在尾部追加value值。 如果key不存在 则创建 且值为value
+ ``strlen key`` 返回字符串key对应的value值的长度。
+ ``incr key`` 对string类型的值 + 1, 如果key是string类型但不是数字则失败、key不是string类型也会失败、对于不存在的key，则会创建并通过+1操作其value变为1
+ ``decr key`` 对string类型的值 - 1, 如果key是string类型但不是数字则失败、key不是string类型也会失败、对于不存在的key，则会创建并通过-1操作其value变为 -1
+ ``incrby key increment`` 对string类型的值 + increment, 如果key是string类型但不是数字则失败、key不是string类型也会失败、 对于不存在的key，则会创建并通过+ increment操作其value变为increment
+ ``decrby key decrement`` 对string类型的值 - decrement, 如果key是string类型但不是数字则失败、key不是string类型也会失败、对于不存在的key，则会创建并通过+ decrement操作其value变为decrement
+ ``getrange key start end`` 获取string类型从start 到 end的值，包含start与end，下标从0开始。 
+ ``setrange key offset value``  从offset位置起，用value替换原串内容。
+ ``setex key seconds value`` 设置key的过期时间及value。 类似与expire 不过setex可以在创建时直接设定好过期时间。
+ ``setnx key value`` 当key值不存在时候，才可以创建到内存，如果key已存在则不生效。
+ ``mset key value [key value ....]`` 即一次操作可以设置多个key value键值对。 若语句失败、则都不生效。
+ ``mget key [key....]`` 即一次可以获取多个key所对应的value值。
+ ``msetnx key value [key value.......]`` 当key不存在时才生效。 若某一个key存在，则失败全部不生效。


## List
+ 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部(左边，或者尾部(右边。其底层是一个双向链表

### 常用命令
+ ``lpush key value [value....]`` 从列表的左侧插入
+ ``rpush key value [value....]`` 从列表的右侧插入
+ ``lrange key start stop`` 从list中取出从start到end的值
+ ``lpop key`` 将key对应的列表最左侧的元素移除
+ ``rpop key`` 将key对应的列表最右侧的元素移除
+ ``lindex key index`` 获取列表的第index位置的值，下标从0开始。
+ ``llen key``  获取列表的长度
+ ``lrem key count value``  从列表中删除count个指定的value值，返回值为成功删除的个数。从左侧开始删除。
+ ``lrange key start stop`` 从列表中截取从start到stop的值。 包含start与stop。
+ ``rpoplpush source destination`` 从source列表中取出最右边的元素 添加到destination列表的左侧
+ ``lset key index value`` 根据下标设置列表中的值。
+ ``linsert key before | after pivot value`` 将某个值插入到给定的pivot之前或之后


## Hash

+ hash是一个键值对集合

一个键值对应着这个键值对。类似于 HashMap<Object, Map<Object, Object>>;

### 常用命令
+ ``hset key field value`` 添加或更新值
+ ``hget key field`` 获取hash字段所对应的value值
+ ``hmset key field valye [field value.....]`` 一条语句设置多条键值对
+ ``hmget key field [field.....]`` 一条语句可以获取多条value
+ ``hgetall key`` 获取当前键的所有键值对结果
+ ``hdel key field [field......]`` 删除指定字段的键值对
+ ``hlen key`` 返回当前key对应的键值对的个数
+ ``hexists key field`` 判断当前字段是否在当前键的集合当中，在返回1，不在返回0
+ ``hkeys key``  获取当前key所对应的全部key值。
+ ``hvals key``   获取当前key所对应的全部value值。
+ ``hincrby key field increment`` 给指定的键值对 + increment
+ ``hincrbyfloat key field increment`` 给指定的键值对 + increment浮点数
+ ``hsetnx key field value`` 当field不存在时 才进行插入。 否则失败。


## Set
+ Redis的Set是string类型的无序集合。他底层是通过Hashtable来实现的。

### 常用命令
+ ``sadd key member [member.......]``  向set集合中添加元素 自动去重
+  ``smembers key`` 取出所有set集合中的元素
+  ``sismember key member`` 判断member是否在集合中， 在返回1，不在返回0
+  ``scard key`` 返回集合中元素的个数。
+  ``srem key member [member......]`` 删除集合中的元素,返回成功删除的个数
+  ``srandmember key [count]`` 从集合中随机取出几个值，默认值为1。
+  ``spop key [count]`` 随机选取count个元素弹出并返回值，默认值为1
+  ``smove source destination member`` 将source中存在的元素移动到destination集合中，source中存在移动成功，不存在则移动失败。
+  ``sdiff key1 [key2....]`` 返回只有在key1中存在的元素，在key2,key3.....中都不存在的元素
+  ``sinter key1 [key2.....]`` 返回所有集合中的交集
+  ``sunion key1 [key2.....]`` 返回所有集合的并集

## ZSet
+ 在Redis中Zset与Set一样 是String类型元素的集合，且不允许重复的成员。
+ **不同点是Zset会关联一个double类型的分数。**
+ redis是通过分数 来为集合中的成员从小到大排序。**zset的成员是唯一的，但分数是可以重复的**


### 常用命令
+ ``zadd key score1 value1 [score2 value2....]`` 添加值或更新值 score为分数 value为字段 字段不可重复
+ ``zeange key start stop [withscores]`` 取出从start到stop的所有元素 默认升序 可选参数withscores为是否将分数一块取出
+ ``zrangebyscore key min max [withscores] [limit offset count]`` 取出满足min和max区间的元素 直接写数字包含min和max 加上左括号( 为不包含。 可选参数withscores为是否将分数一起取出 参数limit类似于mysql分页 表示跳过 offset个元素 取count个元素。
+ ``zrem key member [member.......]`` 删除zset集合中的指定字段
+ ``zcard key`` 统计该zset中的元素的数量
+ ``zcount key min max`` 统计在key这个集合中，满足条件的元素的数量。 默认包含最值 加左括号则不包含
+ ``zrank key member`` 获取member这个元素的下标位置，下标从0开始。
+ ``zrevrank key member`` 获取member这个元素的倒排下标位置。倒排也是从0开始
+ ``zrevrange key start stop [withsscores]``  与zrange类似，不过这样时倒排
+ ``zrangebyscore key max min [withscores] [limit offset count]`` 与上面一直 只是这样是倒排