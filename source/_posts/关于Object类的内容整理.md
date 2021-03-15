---
title:  关于Object类的内容整理
date: 2020年9月26日
tags:  面试

---

![在这里插入图片描述](/image/刺客伍六七/2.jpeg)
<escape><!-- more --></escape>
# Object类
# 经常实现的接口
## Comparable 和 Comparator 比较
这两个接口都是常见的接口，但是具体的区别一直没有考虑过.两者之间的差异也没有考虑过。今天来学习一下

### Comparable接口
Comparable 是排序接口。若一个类实现了Comparable接口，就意味着“该类支持排序”。  即然实现Comparable接口的类支持排序，假设现在存在“实现Comparable接口的类的对象的List列表(或数组)”，则该List列表(或数组)可以通过 Collections.sort（或 Arrays.sort）进行排序。此外，“实现Comparable接口的类的对象”可以用作“有序映射(如TreeMap)”中的键或“有序集合(TreeSet)”中的元素，而不需要指定比较器。 
```java
public interface Comparable<T> {
    public int compareTo(T o);
}
```
其需要实现CompaerTo方法 返回一个int值，假设我们通过`x.compareTo(y)`
+ 返回 负数 则代表x < y
+ 返回 0 则代表 x = y
+ 返回 正数 则 代表 x > y

### Comparator接口
Comparator 是比较器接口。我们若需要控制某个类的次序，而该类本身不支持排序(即没有实现Comparable接口)；那么，我们可以建立一个“该类的比较器”来进行排序。这个“比较器”只需要实现Comparator接口即可。也就是说，我们可以通过“实现Comparator类来新建一个比较器”，然后通过该比较器对类进行排序。
```java
public interface Comparator<T> {

    int compare(T o1, T o2);

    boolean equals(Object obj);
}
```
其需要实现Compaer方法 返回一个int值，假设我们通过`x.compare(y)`
+ 返回 负数 则代表x < y
+ 返回 0 则代表 x = y
+ 返回 正数 则 代表 x > y

### 比较
Comparable是排序接口；
若一个类实现了Comparable接口，就意味着“该类支持排序”。
而Comparator是比较器；我们若需要控制某个类的次序，可以建立一个“该类的比较器”来进行排序。
我们不难发现：Comparable相当于“内部比较器”，而Comparator相当于“外部比较器”。