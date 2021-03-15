---
title:  关于面试的HashMap总结
date: 2020年9月26日
tags:  面试

---

![在这里插入图片描述](/image/刺客伍六七/1.jpeg)
<escape><!-- more --></escape>
# HashMap的原理
## HashMap底层的数据结构
### 1.8之前的实现方式
主要参数
+ initialCapacity 初始数组长度 默认为16
+ loadFactor 负载因子 用来确定扩容阈值 默认为0.75
+ threshold 扩容阈值 当当前map中的节点数大于等于阈值时 可能会发生扩容操作
+ size 存储当前有多少个节点
+ modCount 与Fail-Fast 机制相关
在jdk1.8之前是由数组+链表来实现。每一个键值对为一个Entry节点。通过对键的hash运算并于数组长度按位与之后得到该节点存储的下标位置并进行插入操作 **采用的是头插法**，其认为最新加进来的值可能会被使用，增加get的效率。其内部维护了size记录着当前节点数，如果大于阈值且当前下标位置不为空则会进行resize操作，数组的长度会变为原来的二倍。

### 1.8的实现方式
主要参数
+ initialCapacity 初始数组长度 默认为16
+ loadFactor 负载因子 用来确定扩容阈值 默认为0.75
+ threshold 扩容阈值 当当前map中的节点数大于等于阈值时 可能会发生扩容操作
+ size 存储当前有多少个节点
+ modCount 与Fail-Fast 机制相关
+ TREEIFY_THRESHOLD  链表变红黑树的阈值 默认为8
+ UNTREEIFY_THRESHOLD 红黑树变链表的阈值 默认为6

在jdk1.8中是由数组+链表+红黑树来实现。每一个键值对为一个Node或者TreeNode节点。通过对键的hash运算并于数组长度按位与之后得到该节点存储的下标位置并进行插入操作 **采用的是尾插法**，其内部维护了size记录着当前节点数，如果大于阈值且当前下标位置不为空则会进行resize操作，数组的长度会变为原来的二倍。且当put的时候，如果当前下标位置还是链表的话，会判断当前链表长度是否 **大于8** 来判断是否需要进行树化，**当table为空 或者 数组长度 < 64 则会进行扩容操作**， 其他情况才会进行树化操作。

## Hash冲突的解决办法
### 开放地址法
+ 开放地址法
    + 线性探测 在原有的基础上向后移一个单位，直到不冲突即可
    + 再平方法 在原来值的基础上先加1的平方个单位，若仍然冲突则减1的平方个单位。随之是2的平方，3的平方等等。直至不发生哈希冲突。


### 链地址法
+ 对于相同的值，使用链表进行连接。使用数组存储每一个链表。

### 再哈希法
+ 对于冲突的哈希值再次进行哈希处理，直至没有哈希冲突。

## 用LinkedList代替数组结构可以吗？
是可以的，但是由于LinkedList并不支持随机访问，所以即使我们可以通过hash确定下标，但也需要O(n)的时间去找到存储的位置，与HashMap的高效查找不符。 

## TreeMap
TreeMap底层不同与HashMap，其底层是由红黑树来实现的，其默认是以键值升序存储的。他的get,put,remove等操作都是O(logn)的复杂度 相对而言不如哈希表高效。

## LinkedHashMap
其保证了插入与取出的顺序是一致的。

## CurrentHashMapp
我们知道 HashMap TreeMap LinkedHashMap都是线程不安全的，当其应用于多线程并发的场景 会出现数据丢失，数据错误等情况。 我们可以使用HashTable、CurrentHashMapp等线程安全的集合容器。
HashTable是底层的get、put、remove等方法添加了Synchronized，保证多线程并发情况下只有一个线程操作。而CurrentHashMapp是使用分段锁机制来保证线程安全的

## HashMap的resize条件
### 扩容条件
扩容发生在put方法中，当table为空或长度为0时 会发生resize，节点数大于threshold也会触发扩容操作

### 为什么扩容是原容量的2倍
因为HashMap确定某个键值对的下标是通过hash(key)与length-1做按位与操作，2的幂可以保证lenth-1低位都为1，所以决定位置只与hash(key)的值有关，可以使得分布更加均匀。

## HashMap的put与get过程
### put的过程
1. 会调用内部的```putVal``` 方法 判断当前table是否为空或者长度是否为0 如果是则 resize
2. 根据hash(key) & (length - 1)得出下标，如果table[index] == null 则直接将table[index] = new Node()
3. 接着判断 当前已存在的元素的hash值与key的hash值与地址值或equals判断是否相对 来判断是否是同一键值
4. 判断当前节点所在结构是否是红黑树结构 如果是红黑树结构则调用红黑树的putTreeVal方法
5. 跑以下链表 判断当前是否是最后一个节点 如果是 则将当前的next指针赋为new Node。并判断当前链表的长度是否大于树化阈值，如果大于 则进行树化操作(当然 不一定会树化 如果table == null || length < 64 则进行resize操作
6. 判断当前节点是否与key相等，相等则保存旧的Node节点 跳出循环 
7. 判断当前的key值是否被存储过，如果存储过，则将value替换 返回旧的value
8. 否则就是添加新值 modCount++, size++， 并判断size是否大于阈值 大于则会进行resize操作
9. 返回旧的value

### get的过程
1. 会调用内部的```getNode```方法参数为hash(key)和key
2. 判断当前table是否为空 或者 长度是否为0 或者 hash(key) & (lenth -1 ) == null 如果有一条满足 则返回null
3. 首先判断数组中的节点与key的关系 如果地址值相同或者equals方法判断相等 则直接返回
4. 判断当前节点是否有下一项节点 如果没有 则返回null
5. 如果有 则判断当前下标存储的节点结构是不是红黑树 如果是 则调用```getTreeNode```方法在红黑树中进行查找
6. 否则 则会跑当前链表判断是否有相同的key值 找到返回 没找到返回null

## HashMap 1.7与1.8的不同
+ 1.7底层是由数组+链表实现 1.8是由数组+链表+红黑树实现
+ 1.7使用的是头插法 1.8使用的是尾插法


# HashMap的并发问题
## HashMap在并发环境下，1.7和1.8分别可能出现什么问题？

### 1.7 数据丢失 死循环等问题
由于1.7使用的是头插法。当两个线程都处于resize阶段，都会new 一个newTable出来，当转移数据transfer时可能会出现链表成环的情况，导致下一次get一个未存储在map中的key时可能会死循环。且resize过程和transfer过程返回的是最后一个线程对table的赋值 会出现数据丢失的问题
### 1.8 数据覆盖
1.8采用尾插法，可以解决链表成环的问题。但依然不是线程安全的，当并发情况下，可能会存在多个线程同时对table赋值，出现线程不安全的情况。

## 线程安全的map类

## HashMap的键值可以为null吗 TreeMap、HashTable、LinkedHashMap呢

### HashMap
+ 键和值都允许为null，当键为null时 其hash(key) = 0 存放位置为table[0]的位置

### TreeMap
+ 构造参数没有给定Comparator接口的实现对象是 不支持空的键 但支持空值
因为其底层是通过红黑树来实现的，需要由构造函数给定Comparator的实现才可以进行比较；
默认的比较器是null，给进来的key会判断当前比较器是否是空，如果为空的话，则进行调用key.compareTo()方法。此时key为空就会出现空指针异常。如果制定了比较器，则调用比较器的compare方法比较
+ 即使给定了比较器 没有对键为 null值做特殊处理也会报空指针异常

### LinkedHashMap
+ 键值都可以为null