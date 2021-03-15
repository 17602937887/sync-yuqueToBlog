---
title: 关于String的笔记【Java基础】
date: 2020年11月1日
mathjax: true
tags: 
	- Java基础
	- 面试
categories: Java

---
本文对Java中的常用类String做一个阶段性的总结，其中包括String的底层实现、String的常用方法、关于字符串常量池中的面试题等内容。

<escape><!-- more --></escape>
**文章不做特殊说明，默认是JDK8的情况下的结论！！！**

# 基本概念

## 概述
String并属于基本数据，而是一种常用类。
String被声明为final，所以其不可被继承。

题外话面试可能会问到的题目:
1. final可以修饰那些东西？修饰之后有什么作用?
答: 1) 可以修饰类 修饰之后此类不可被继承。 2） 可以修饰方法 修饰之后该方法不能被子类重写 3）可以修饰变量 修饰之后改变量只能被赋值一次 4） 不能修饰抽象类或者接口 因为修饰了代表类不能被继承 接口不能被实现  那么该抽象类或者接口就没有了意义。

2. final，finally，finalize有什么区别。
答: 1) final回答就是第一个问题 就说可以修饰啥 修饰之后的效果 2)finally 是与try代码块 或 try catch代码块一起使用的 主要作用是在finally代码块中的代码一定会执行，常用于资源的释放，防止try代码块出现异常导致某些资源无法释放。 3）finalize是Object类中的方法，当子类重写该方法，可以在GC得时候获得一次免除被GC的机会（例如在代码块中使得其他在GC ROOTS中的引用指向this即可） 此方法只能被指向一次 且优先级较低 已经不建议被使用。

在 JDK1.8及之前，String底层使用char数组用来存储数据。
``` java
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence
{
    /** The value is used for character storage. */
    private final char value[];
    
```
在JDK1.9之后，String底层使用byte数组存储字符串，同时使用``coder``来标识使用了那种编码

``` java
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence {

    /**
     * The value is used for character storage.
     *
     * @implNote This field is trusted by the VM, and is a subject to
     * constant folding if String instance is constant. Overwriting this
     * field after construction will cause problems.
     *
     * Additionally, it is marked with {@link Stable} to trust the contents
     * of the array. No other facility in JDK provides this functionality (yet).
     * {@link Stable} is safe here, because value is never null.
     */
    @Stable
    private final byte[] value;

    /**
     * The identifier of the encoding used to encode the bytes in
     * {@code value}. The supported values in this implementation are
     *
     * LATIN1
     * UTF16
     *
     * @implNote This field is trusted by the VM, and is a subject to
     * constant folding if String instance is constant. Overwriting this
     * field after construction will cause problems.
     */
    private final byte coder;

```
**value数组被声明为final，所以就是说当数组初始化之后，就不能引用其他数组。并且String内部并没有改变value数组的方法，因此可以保证String的不可变。**

## 不可变的好处
### 可以缓存hash值
因为String的hash值经常被使用，不可变的特性可以使得hash值也不可变，因此只需要计算一次hash值即可
String存在成员变量hash默认值为0，String的hashCode方法如下
``` java
public int hashCode() {
    int h = hash;
    if (h == 0 && value.length > 0) {
        char val[] = value;

        for (int i = 0; i < value.length; i++) {
            h = 31 * h + val[i];
        }
        hash = h;
    }
    return h;
}
```
**可以看出，当其hash值为0时且串不为空时才会计算hash值，否则会返回默认的0值或者已经计算过的hash值。我们也可以看出，只有当实际调用hashCode方法时才会计算，否则默认为0，算是一个懒加载**

### 字符串常量池的需要
因为我们知道运行时数据区会有一会内存区域用来存储字符串常量池(jdk6及之前在方法区，jdk7及之后在堆空间)，如果String不是final的，那么其就是可变对象，如果修改了内容则其hashCode值就会改变, 在字符串常量池则可能无法获取正确引用地址或者字符串常量池会存储重复的数据。

例如: 假设String可变，我们知道字符串常量池的底层结构是Hashtable，即数组+链表的方式实现。 那么假设字符串String str = "abc" 打在了 index = 1的位置，然后str改变成了"123"，那么此时如果有新的字符串"123"试图添加进常量池，且其经过Hash运算打到的下标是2，那么此时常量池就会存储两份"123"。

所以为了保证常量池的数据唯一性，获得正确的引用地址，只有String是不可变的才可以使用字符串常量池。

### 安全性
由于String的不可变性，所以我们可以在多线程环境下使用String而不必考虑线程安全问题。

# 常用方法
## String.length()
 + 作用: 返回当前字符串的长度
 + 注意事项: 调用length()方法返回的是字符串的长度，即 不论是字母、数字、标点符号、汉字都是一个字符。 例如 ``"12345".length()``的返回结果是5. ``"你好呀".length()``的返回结果是3.

## String.isEmpty()
+ 作用: 用于判断当前字符串是否为空串，为空串返回true， 非空返回false
+ 注意事项: 此方法使用的前提是str有具体的指向，为null会报空指针异常。

## String.charAt(int index)
+ 作用: 获取下标index处的char值。 下标的起始位置为0

## String.indexOf()
+ 四种重载形式 ``indexOf(int)`` , ``indexOf(int, int)``, ``indexOf(String)``,  ``indexOf(String, int)``
+ 其中，若给定一个参数，则其会调用两个参数的方法，且第二个参数给定为0
+ 第一个参数为要查找的ASCII码或者String字符串，第二个参数为开始查找的下标
+ 作用: 返回要查找值的首次出现位置的下标，没有找到则返回-1；

## String.lastIndexOf()
+ 作用: 重载方式与indexOf()一直，只是当前方法返回的是指定内容出现的最后位置，没找到返回-1
+ 注意事项： indexOf()是从前往后找，而lastIndexOf是从后往前找。 所以当我们指定起始位置fromIndex时，indexOf()是找从fromIndex到str.length()中首次出现的下标。而lastIndexOf是找从0到fromIndex中最后一次出现的下标位置。

## String.subString()
+ 两种重载方式 ``subString(int beginIndex) ``, ``subString(int beginIndex, int endIndex)``
+ 作用：第一种方式返回从指定下标的字符串结尾的字串，第二种方式返回从begin开始到endIndex的字串(包含begin但不包含end)

## String.concat(String str)
+ 作用: 返回当前字符串拼接给定参数str后的结果。当我们只是少量的拼接操作，则不需要通过StringBuilder或者StringBuffer进行拼接，使用此方法即可进行拼接。


## String.replace(char oldChar, char newChar)
 + 作用: 将该字符串中所有的字符oldChar替换为newChar并返回。

## String.replaceFirst(String regex, String replacement)
+ 作用: 第一个参数为正则表达式，第二个参数为满足正则表达式之后的替换值。只替换首次满足的位置

## String.replaceAll(String regex, String replacement)
+ 作用: 第一个参数为正则表达式，第二个参数为满足正则表达式之后的替换值。替换所有满足正则的位置



# 字符串常量池

## 在运行时数据区的位置

在jdk6及之前，是存储在方法区的，即永久代。而从jdk7开始，其迁移到堆空间。

## 什么数据回存储在常量池？

+ 源码中显式的字面值常量
举例子
``String str  = "Hello World" ``
比如这里的"Hello World"就会添加在常量池里，这点我们可以通过反编译生成的字节码文件，在字节码文件中就会存储字面值常量的符号引用，通过类加载机制会将其添加到字符串常量池中。

+ 通过显式调用String的intern方法，会尝试加入常量池(已存在不会添加
显示的调用intern方法也会将String尝试添加到字符串常量池中。
**这里有个不同地问题，在jdk6及之前采用的是复制，即复制一份String到常量池中，而jdk7及之后采用的是复制为引用，不会重新造一份String**。

