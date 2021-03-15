---
title:  Spring学习笔记第一天
date: 2020年11月10日
tags: 
	- Spring
	- 面试
categories: Spring框架
---
![在这里插入图片描述](/image/插图/大理寺3.jpg)
<escape><!-- more --></escape>

# Spring框架概述

## 什么是Spring
spring是一个开源的框架，它是为了解决企业应用开发的复杂性而创建的。框架的主要优势之一就是其分层架构，分层架构允许使用者选择使用哪一个组件，同时为J2EE应用程序开发提供集成框架。
**Spring的核心是控制反转(IOC)和面向切面(AOP)** 简单来说，Spring是一个分层的JavaSE/EE(一站式)轻量级开源框架。

## Spring的优点
+ **方便解耦，简化开发(高内聚、低耦合)**
Spring就是一个大的容器，可以将所有对象创建和依赖关系维护，交给Spring管理。
Spring工厂是用于生成Bean

+ **AOP编程的支持**
Spring提供面向切面编程，可以方便的实现对程序进行权限拦截、运行监控等功能。 

+ **声明式事务的支持**
只需要通过配置就可以完成对事务的管理，而无需手动编程

+ **方便程序的测试**
Spring对Junit4支持，可以通过注解方便的测试Spring程序。

+ **方便集成各种优秀框架**
Spring不排斥各种优秀的开源框架，其内部提供了对各种优秀框架(如: Struts、Hibernate、MyBatis、Quatz等)的直接支持。

+ **降低JavaEE API的使用难度**
Spring对JavaEE开发中非常难用的一些API(JDBC、JavaMail、远程调用等)都提供了封装，是这些API应用难度大大降低

## Spring的体系结构
Spring框架是一个分层架构，它包含了一系列的功能要素并被分为大约20个模块。这些模块分为Core Container、Data Access/Integration、Web、AOP(Aspect Oriented Programming)、Instrumentation和测试部分、如图所示。
![在这里插入图片描述](/image/Spring学习笔记第一天/1.png)

我们可以看到spring框架整合了包含
+ **Test**： 单元测试模块、需要导包
    + spring-test
    
+ **Core Container**: 核心容器(IOC);  黑色代表这部分的功能有哪些jar包组成。要使用这部分功能就得导入当前模块的全部jar包
    + spring-beans
    + spring-core
    + spring-context
    + spring-expression
    
+ **AOP + Aspects**: 面向切面编程模块，需要导入的包
    + spring-aop
    + spring-aspects
   
+ **Data Access/Integration**: (数据访问/集成) 
    + **spring-jdbc**: 操作数据库  重点
    + **spring-orm**：对象关系映射 重点
    + spring-oxm: 对象与xml关系映射
    + spring-jms: 消息中间件
    + ** spring-tx**: 数据库事务相关  重点 
+ **Web**：Spring开发web应用的模块
    + spring-websocket: websocket
    + spring-web: 原生web相关
    + spring-webmvc: 开发web项目的
    + spring-webmvc-portlet: 开发web的组件


**用哪个模块导入那个包。**

# IOC和AOP

## IOC(Inversion of control): 控制反转

### 控制资源获取的方式

+ 主动获取：(要什么资源自己创建即可)
``` java
class Person  {
    House house = new House(); // 主动获取 通过new的方式。 但是如果此对象又包含了很多复杂的属性，则此对象的初始化较为复杂。
    Car car = new Car(); // 也是通过new的方式主动获取。
}
```

+ 被动获取: (需要什么资源由容器提供、不需要自己主动获取)
``` java

class Person {
    House house; // 不需要自己创建，由容器提供
    Car car; // 不需要自己创建，由容器提供
}

```

**容器: 管理所有的组件(有功能的类); 容器可以自动的探查出那些组件(类)需要到另一些组件(类)；容器帮我们创建对象、添加依赖关系等**

### DI(dependency Injection) 依赖注入
容器能知道哪个组件(类)运行的时候，需要另外一个类(组件)；容器通过反射的形式，将容器中准备好的对象进行注入(利用反射给属性进行赋值)。

只要容器管理的组件、都能使用容器提供的强大功能。

# Spring入门
+ 导包: 测试IOC容器功能，所以需要导入**Core Container**中的四个jar包，maven直接添加依赖即可。
 Spring运行的时候还需要依赖于日志包(commons-logging)。
 
 + 写配置: 需要创建Spring的bean配置文件.xml
 ``` xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
       
</beans>
```

## 给容器中注册组件(类)
在spring的bean配置文件中添加组件
``` xml
<bean id="" class="">    
    
</bean>
```
一个bean标签对应着一个组件
class为注册组件的全限定类名
id为这个组件的唯一标识

### 使用property为对象的属性赋值
``` xml
<bean id="" class="cn.hangcc.bean.Person">    
    <property name="" value=""/>
</bean>
```
其中id为通过容器获取组件的唯一标识。class为注册组件的全限定类名。
name为**setter方法后首字母小写后的剩余部分**
+ setFirstName(String firstName) {this.fisrtName = firstName};  在配置文件中 name="firstName";
其他的情况如: set方法首字母小写、set方法无参数等、则配置文件不进行识别。

value为这个**setter方法的传入参数**


**这种方式是根据全限定类名反射的方式创建对象，并根据set方法对应配置文件的property进行属性初始化的。**

## 从容器中获取组件(类)

我们可以先获取容器对象进而获取容器中的组件！
ApplicationContext这个接口就代表着IOC容器；
其常用的实现类有以下两个
![在这里插入图片描述](/image/Spring学习笔记第一天/2.png)
+ ``FileSystemXmlApplicationContext``
是根据当前系统的文件路径指定的bean配置文件进行获取容器。
+ ``ClassPathXmlApplicationContext``
是根据类路径的bean配置文件进行获取容器。

我们通常将bean.xml放到资源文件路径下即可，然后使用
``` java
    ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
```
进行ioc容器的获取。

获取组件的方法及其重载。
![在这里插入图片描述](/image/Spring学习笔记第一天/3.png)

+ **容器创建之后，容器中的所有组件都将被创建**
+ **容器中的bean，是同一个组件，多次获取地址相同，单例模式**
+ 

### 通过唯一id标识获取对象
我们可以通过``ApplicationContext``接口提供的getBean方法来获取对象。
我们直接传入在配置文件中给定的唯一标识id即可获取到Object对象，然后强转为我们已知的对象类型即可。
**如果给的的id未在容器中注册，会报``NoSuchBeanDefinitionException: No bean named 'XXXX' available``异常**
``` java
public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
        Person person = (Person) context.getBean("person01");
        System.out.println(person.toString());
    }
}
```


### 通过bean的类型来获取对象
我们可以通过``ApplicationContext``接口提供的getBean方法来获取对象。
我们可以将传入参数改为Class对象，则代表会根据对象的类型进行匹配。当容器中只有一个该类型或该类型的子类的组件时直接返回该组件，否则会抛出异常。

+ 当容器中只有一个该类或者该类的子类时候 直接返回类型匹配的这个组件
``` java
public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
        Person bean = context.getBean(Person.class);
        System.out.println(bean);
    }
}
```
+ 当容器中没有与该类型匹配的组件时候。
``NoSuchBeanDefinitionException：No qualifying bean of type 'xxxx.xxxx.xxxx.xxxx' available``

+ 当容器中匹配的个数大于1时
``NoUniqueBeanDefinitionException: No qualifying bean of type 'xxxx.xxxx.xxxx' available: expected single matching bean but found 3: person01,person02,boy01``

**获取Class对象的三种方式**
+ 根据Class.forName("全限定类名"); 获取
+ 可以通过类名.class; 获取
+ 可以通过对象的getClass(); 方法进行获取

### 可以通过指定id与类型唯一确定组件
我们可以通过``ApplicationContext``接口提供的getBean方法来获取对象。
第一个参数指定为唯一标识id，第二个参数指定为类的Class对象，即可唯一确定组件，且返回值为Class对象所对应的类。不需要进行强制类型转换了。

``` java
public class Demo {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
        Person per = context.getBean("person01", Person.class);
        System.out.println(per);
    }
}
```

当我们指定的id不存在时会抛出``NoSuchBeanDefinitionException``异常 代表容器中不存在指定id的Bean。当我们指定的类型与容器中不匹配时候，会抛出``BeanNotOfRequiredTypeException``异常，代表Bean不是我们指定类型。


