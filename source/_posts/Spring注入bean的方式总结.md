---
title:  Spring注入bean的方式总结
date: 2020年11月16日
tags: 
	- Spring
	- 面试
categories: Spring框架
---
![在这里插入图片描述](/image/插图/大理寺4.jpg)
本篇文章是基于作者的理解，总结一下关于Spring注入bean的所有方式。
<escape><!-- more --></escape>
# 准备工作
为了演示所有注入方式，我们先做一些准备工作，供之后的测试顺利进行！

## 导入Jar包/添加Maven依赖
我们要使用Spring框架则需要导入必备的jar包。
+ spring-context
+ spring-beans
+ spring-core
+ spring-expression
+ commons-logging

除此之外，我们还需要进行测试代码，所以我们继续导入junit的jar包。
作者的maven配置如下。
``` xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.example</groupId>
    <artifactId>SpringDay01</artifactId>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-expression</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

## 编写需要的类
作者这里构造了几个类，供我们进行测试
+ 爱好类 有三个字段 分别为爱好的名字 爱好的分类 爱好的描述
```  java
public class Hobby {
    private String name;
    private String classify;
    private String describe;
    public Hobby() {
    }
    public Hobby(String name, String classify, String describe) {
        this.name = name;
        this.classify = classify;
        this.describe = describe;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getClassify() {
        return classify;
    }
    public void setClassify(String classify) {
        this.classify = classify;
    }
    public String getDescribe() {
        return describe;
    }
    public void setDescribe(String describe) {
        this.describe = describe;
    }
    @Override
    public String toString() {
        return "Hobby{" +
                "name='" + name + '\'' +
                ", classify='" + classify + '\'' +
                ", describe='" + describe + '\'' +
                '}';
    }
}
```

+ 教师类 有三个字段 分别为教师的名字、年龄、以及性别
``` java
public class Teacher {
    private String name;
    private Integer age;
    private String sex;
    public Teacher() {
    }
    public Teacher(String name, Integer age, String sex) {
        this.name = name;
        this.age = age;
        this.sex = sex;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
    public String getSex() {
        return sex;
    }
    public void setSex(String sex) {
        this.sex = sex;
    }
    @Override
    public String toString() {
        return "Teacher{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", sex='" + sex + '\'' +
                '}';
    }
}
```

+ 学生类 包含了许多字段 为了测试bean的注入
    + name属性 为String类型
    + age属性 为Integer类型
    + Teacher属性 为自定义的类型
    + courses 为数组类型
    + friend 为集合容器中的List类型
    + hobbies 为集合容器中的Set类型
    + score 为集合容器中的Map类型
    + config 为Properties类型
 
 ``` java

import java.util.*;
public class Student {
    private String name; // String类型
    private Integer age; // Integer类型
    private Teacher teacher; // 自定义数据类型
    private String[] courses; // 数组类型
    private List<Student> friend; // 集合容器List
    private Set<Hobby> hobbies; // 集合容器Set
    private Map<String, Integer> score; // 集合容器Map
    private Properties config; // Properties类型
    public Student() {
    }
    public Student(String name, Integer age, Teacher teacher, String[] courses, List<Student> friend, Set<Hobby> hobbies, Map<String, Integer> score, Properties config) {
        this.name = name;
        this.age = age;
        this.teacher = teacher;
        this.courses = courses;
        this.friend = friend;
        this.hobbies = hobbies;
        this.score = score;
        this.config = config;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Integer getAge() {
        return age;
    }
    public void setAge(Integer age) {
        this.age = age;
    }
    public Teacher getTeacher() {
        return teacher;
    }
    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }
    public String[] getCourses() {
        return courses;
    }
    public void setCourses(String[] courses) {
        this.courses = courses;
    }
    public List<Student> getFriend() {
        return friend;
    }
    public void setFriend(List<Student> friend) {
        this.friend = friend;
    }
    public Set<Hobby> getHobbies() {
        return hobbies;
    }
    public void setHobbies(Set<Hobby> hobbies) {
        this.hobbies = hobbies;
    }
    public Map<String, Integer> getScore() {
        return score;
    }
    public void setScore(Map<String, Integer> score) {
        this.score = score;
    }
    public Properties getConfig() {
        return config;
    }
    public void setConfig(Properties config) {
        this.config = config;
    }
    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", teacher=" + teacher +
                ", courses=" + Arrays.toString(courses) +
                ", friend=" + friend +
                ", hobbies=" + hobbies +
                ", score=" + score +
                ", config=" + config +
                '}';
    }
}

```

# 基于XML配置文件注入bean

首先我们需要有一份spring关于xml配置的模板，这里作者贴一下。
``` xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
</beans>
```

## 使用property进行属性赋值
**property标签有三个key-value对可供赋值**
+ ``name``

property是利用类的setter方法进行属性赋值的，所以name属性填写的值为set方法首字母小写之后的剩余部分。

+ ``value``

对于基本数据类型及其包装类，String类型，可以直接给value填写相关值，spring会帮我们自动做类型转换。

+ ``ref``

表示引用当前组件，我们在之后进行演示这种操作。

``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
    <bean id="hobby1" class="cn.hangcc.bean.Hobby">
        <property name="name" value="踢足球"/>
        <property name="classify" value="体育"/>
        <property name="describe" value="球类运动,强身健体"/>
    </bean>
    <bean id="hobby2" class="cn.hangcc.bean.Hobby">
        <property name="name" value="打篮球"/>
        <property name="classify" value="体育"/>
        <property name="describe" value="球类运动，强身健体"/>
    </bean>
    <bean id="hobby3" class="cn.hangcc.bean.Hobby">
        <property name="name" value="读书"/>
        <property name="classify" value="学习"/>
        <property name="describe" value="阅读文学,开阔视野"/>
    </bean>
    <bean id="teacher1" class="cn.hangcc.bean.Teacher">
        <property name="name" value="张老师"/>
        <property name="sex" value="男"/>
        <property name="age" value="32"/>
    </bean>
    <bean id="teacher2" class="cn.hangcc.bean.Teacher">
        <property name="name" value="李老师"/>
        <property name="sex" value="女"/>
        <property name="age" value="28"/>
    </bean>
    <bean id="student" class="cn.hangcc.bean.Student">
        <!--String类型 可以直接给value赋字符串值-->
        <property name="name" value="张三"/>
        <!--基本数据类型的包装类 可以直接给value赋值 spring会帮我们做类型转化-->
        <property name="age" value="18"/>
        <!--这里是自定义的类类型 所以无法直接使用value进行赋值，我们有两种方法进行赋值
            第一种就是在当前的bean内部,创建一个Teacher对象来对当前bean进行赋值
        -->
<!--        <property name="teacher">-->
<!--            <bean class="cn.hangcc.bean.Teacher">-->
<!--                <property name="name" value="陈老师"/>-->
<!--                <property name="age" value="23"/>-->
<!--                <property name="sex" value="男"/>-->
<!--            </bean>-->
<!--        </property>-->
        <!--第二种办法就是使用ref 引用当前ioc容器已有的组件进行赋值,其中ref填写的值为唯一标识id-->
        <property name="teacher" ref="teacher1" />
        <!--对于数组类型，那么显然也是无法直接用value来直接赋值的 所有我们需要在property标签内部使用list或者array标签进行赋值
            然后因为作者这里定义的是String数组 所以在array标签内部使用value直接进行赋值
            如果是自定义的类型数组， 则可以使用ref或者bean进行赋值 写多少个bean或者ref就代表多少个数组元素
        -->
        <property name="courses">
            <array>
                <value>123</value>
                <value>234</value>
                <value>345</value>
            </array>
        </property>
        <!--对于集合容器中的List类型，那么显然也是无法直接用value来直接赋值的 所有我们需要在property标签内部使用list标签进行赋值
            然后因为作者这里定义的是Student类型的List, 可以使用ref或者bean进行赋值 写多少个bean或者ref就代表多少个数组元素
        -->
        <property name="friend">
            <list>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="Hang_c"/>
                    <property name="age" value="18"/>
                </bean>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="Jay_chou"/>
                    <property name="age" value="30"/>
                </bean>
            </list>
        </property>
        <!--对于集合容器Set 肯定也无法使用value进行直接赋值
            与List类似 可在其标签内部使用标签进行赋值
            作者这里是自定义的类Hobby 所以可以在标签内部使用bean或者ref进行初始化
            这里还会将我们的对象进行去重 保证set的正确性
        -->
        <property name="hobbies">
            <set>
                <bean class="cn.hangcc.bean.Hobby">
                    <property name="name" value="书画"/>
                    <property name="classify" value="文学素养"/>
                    <property name="describe" value="陶冶情操"/>
                </bean>
                <ref bean="hobby1"/>
                <ref bean="hobby2"/>
                <ref bean="hobby1"/>
            </set>
        </property>
        <!--对于集合容器Map 也是类似 可以在标签内部注册相关的key-value键值对
            因为作者这里定义的都是可以直接初始化的类型即String和Integer所以可以直接利用字符串进行赋值
            如果是复杂对象 则可以利用key-ref value-ref等进行赋值
        -->
        <property name="score">
            <map>
                <entry key="数学" value="110"/>
                <entry key="语文">
                    <value>80</value>
                </entry>
                <entry key="英语" value="20"/>
            </map>
        </property>
        <!--最后就是Properties对象了 也是类似的
            不过其键值都为字符串 比较简单
        -->
        <property name="config">
            <props>
                <prop key="userName">Hang_ccccc</prop>
                <prop key="password">123456</prop>
            </props>
        </property>
    </bean>
</beans>


```

**总结起来就是基本数据类型、基本数据类型的包装类型、String类型可以直接通过value进行赋值。
如果是集合容器、数组、配置类等这样的属性，可以通过相应的标签内部进行赋值，其中基础数据类型之类的还是可以直接用value标签赋值，而自定义的类可以使用bean或者ref进行赋值。**

## 通过构造函数进行赋值
与上述的方法类似，只是上述方法是根据类的setter方法进行注入的，而我们即将要讨论得方式使用过构造函数进行注入。

我们可以通过``constructor-arg``标签 来根据构造函数对属性值进行注入。 其中``constructor-arg``标签 有5个属性可供赋值

+ name 

表示构造函数的形参名字

+ value

如果是简单的数据类型 可以直接给value赋值进行注入

+ ref

对当前参数进行引用赋值

+ type

因为构造函数可能会重载 该参数用来指定当前类型

+ index

同上 因为构造参数可能会重载 所以该参数用来指定当前参数的下标 下标从0开始

``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="teacher" class="cn.hangcc.bean.Teacher">
        <property name="name" value="张老师"/>
        <property name="age" value="33"/>
        <property name="sex" value="男"/>
    </bean>
    <bean id="student" class="cn.hangcc.bean.Student">
        <!--因为name是String类型 所以可以直接对value进行赋值-->
        <constructor-arg name="name" value="李四"/>
        <!--age是Integer 可以给value合适的值 会自动做类型转化-->
        <constructor-arg name="age" value="12"/>
        <!--teacher是自定义的类 所以有两种方式进行注入
            方式一 在标签内部创建类
            -->
<!--        <constructor-arg name="teacher">-->
<!--            <bean class="cn.hangcc.bean.Teacher">-->
<!--                <property name="name" value="钱老师"/>-->
<!--                <property name="age" value="43"/>-->
<!--                <property name="sex" value="女"/>-->
<!--            </bean>-->
<!--        </constructor-arg>-->
        <!--方式二 引用IOC容器中已有的类-->
        <constructor-arg name="teacher" ref="teacher"/>
        <!--对于数组 与setter方法注入类似-->
        <constructor-arg name="courses">
            <array>
                <value>abc</value>
                <value>bcd</value>
                <value>cde</value>
            </array>
        </constructor-arg>
        <!--对于容器List 也是类似-->
        <constructor-arg name="friend">
            <list>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="小张"/>
                </bean>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="小照"/>
                </bean>
            </list>
        </constructor-arg>
        <!--类似 也是标签内部进行赋值-->
        <constructor-arg name="hobbies">
            <set>
                <bean class="cn.hangcc.bean.Hobby">
                    <property name="name" value="街舞"/>
                </bean>
                <bean class="cn.hangcc.bean.Hobby">
                    <property name="name" value="滑板"/>
                </bean>
            </set>
        </constructor-arg>
        <constructor-arg name="score">
            <map>
                <entry key="高数" value="80"/>
                <entry key="体育" value="20"/>
            </map>
        </constructor-arg>
        <constructor-arg name="config">
            <props>
                <prop key="key">nihao</prop>
                <prop key="value">admin</prop>
            </props>
        </constructor-arg>
    </bean>
</beans>

```
**总结 与setter方法类似 只是一个是通过set方法进行注入 一个是通过构造器进行注入。
重点还是在对于具体的类而言，其注入的方式可能有所不同。**

## p命名空间和c命名空间
因为对于基本数据类型、基本数据类型的包装类型、String类型可以直接通过value赋值。或者较为复杂的类型使用引用IOC容器的组件进行赋值，那么需要重复写很多标签。 所以引入了p命名空间和c命名空间。

### p命名空间
p就是property的首字母，代表通过属性进行注入的简写形式。
使用前 我们需要在beans里面添加
``xmlns:p="http://www.springframework.org/schema/p"``来引入p命名空间
其仅仅可以简化基本数据类型、基本数据类型的包装类、String类以及需要引用IOC容器中以及存在组件。对于自定义的类还需要在bean标签里面通过property标签进行注入;
使用语法为: c:字段=value 或者c:字段-ref="引用的id"进行注入。
``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--对于基本数据类型 可以直接利用p命名空间进行快速的注册-->
    <bean id="teacher" class="cn.hangcc.bean.Teacher" p:name="姚老师" p:age="18" p:sex="女"/>
    <!--对于基本数据类型 以及以及在IOC容器存在的组件 可以直接赋值或引用-->
    <bean id="stu" class="cn.hangcc.bean.Student" p:name="Hang_ccccc" p:age="23" p:teacher-ref="teacher">
        <!--其他复杂的类型 还需要利用property标签进行注入-->
        <property name="score">
            <map>
                <entry key="物理" value="110"/>
                <entry key="化学" value="98"/>
            </map>
        </property>
        <!--其他复杂的类型 还需要利用property标签进行注入-->
        <property name="config">
            <props>
                <prop key="userName">admin</prop>
                <prop key="passWord">root</prop>
            </props>
        </property>
    </bean>
</beans>
```

### c命名空间
其中c 就是constructor的首字母，代表通过构造器进行注入。
同样的，我们需要在使用之前 在beans中引入c命名空间。
``xmlns:c="http://www.springframework.org/schema/c"`` 同样的，其只能简化部分基本数据类型及已存在与IOC容器的组件，对于未定义在IOC容器中的类还是需要通过``constructor-arg``进行指定。
``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--对于简单类型的属性 可以直接通过c命名空间进行注入 简化代码-->
    <bean id="teacher" class="cn.hangcc.bean.Teacher" c:name="高老师" c:age="35" c:sex="男"/>
    <!--对于简单类型的属性 也可以通过c命名空间进行注入 但是 未在IOC容器中定义的 还是需要在标签中定义-->
    <bean id="stu" class="cn.hangcc.bean.Student" c:name="Pony" c:age="22" c:teacher-ref="teacher">
        <constructor-arg name="courses">
            <array>
                <value>1</value>
                <value>2</value>
                <value>3</value>
                <value>4</value>
            </array>
        </constructor-arg>
        <constructor-arg name="friend">
            <list>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="张三"/>
                </bean>
                <bean class="cn.hangcc.bean.Student">
                    <property name="name" value="李四"/>
                </bean>
            </list>
        </constructor-arg>
        <constructor-arg name="hobbies">
            <set>
                <bean class="cn.hangcc.bean.Hobby">
                    <property name="name" value="篮球"/>
                </bean>
                <bean class="cn.hangcc.bean.Hobby">
                    <property name="name" value="拍球"/>
                </bean>
            </set>
        </constructor-arg>
        <constructor-arg name="config">
            <props>
                <prop key="user">root</prop>
                <prop key="password">root</prop>
            </props>
        </constructor-arg>
        <constructor-arg name="score">
            <map>
                <entry key="数学" value="98"/>
                <entry key="语文" value="77"/>
            </map>
        </constructor-arg>
    </bean>
</beans>
```

**如需注入复杂对象且IOC容器内部无组件，则还是需要在标签内部写标签进行注入**

## util命名空间
对于自定义的类以及基本数据类型、基本数据类型的包装类型、String类型 都可以将其注册到IOC容器中，可以进行复用。 即有其他组件需要使用可以直接ref引用而无需重写一遍xml文件。

而对于集合容器而言，并不能将其封装为一个bean进行复用。所以这里引出了util这一内容。其就是用来对集合容器、Properties类型进行封装的标签。

使用前类似的需要在bean中引入，``xmlns:util="http://www.springframework.org/schema/util"``

**除此之外 还需要再``xsi:schemaLocation``之后添加**
``http://www.springframework.org/schema/util 
http://www.springframework.org/schema/util/spring-util.xsd
``

然后就可以进行使用了。
其中util后面跟着容器类型 可供选择
+ map
+ list
+ set
+ properties

``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:util="http://www.springframework.org/schema/util"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">
    <bean id="teacher" class="cn.hangcc.bean.Teacher" p:name="刘老师" p:age="31" p:sex="女"/>
    <util:map id="map">
        <entry key="C++" value="99"/>
        <entry key="Java" value="80"/>
        <entry key="数据结构" value="88"/>
    </util:map>
    <util:properties id="properties">
        <prop key="user">admin</prop>
        <prop key="password">admin</prop>
    </util:properties>
    <util:list id="list">
        <bean class="cn.hangcc.bean.Student" p:name="周杰伦"/>
        <bean class="cn.hangcc.bean.Student" p:name="刘德华"/>
    </util:list>
    <util:set id="set">
        <bean class="cn.hangcc.bean.Hobby" p:name="唱歌"/>
        <bean class="cn.hangcc.bean.Hobby" p:name="跳舞"/>
    </util:set>
    <util:list id="arr">
        <value>q</value>
        <value>w</value>
        <value>e</value>
    </util:list>
    <bean id="stu" class="cn.hangcc.bean.Student" p:name="Hang_ccccc" p:age="21" p:teacher-ref="teacher">
        <property name="score" ref="map"/>
        <property name="config" ref="properties"/>
        <property name="friend" ref="list"/>
        <property name="hobbies" ref="set"/>
        <property name="courses" ref="arr"/>
    </bean>
</beans>
```

## bean的作用域
默认情况下，每一个IOC的组件都是单例的，即多次获取同一ID的组件得到的是同一个对象。在xml文件内部如果组件有引用的话，也是公用同一个对象。
我们可以修改配置，可以让每次获取都是不同地对象。

``scope``可选值:
+ singleton: 即默认的单例 每次获取都是同一个对象.当IOC容器被创建 则该对象也被创建
+ prototype: 原型模式 每次获取都会新创建对象. 当IOC容器被创建时 不会创建对象 只有被使用时才会创建

## 工厂方法创建bean
类似于设计模式中的工厂模式，就是指给定工程具体的参数，然后工程返回一个组件给到调用者。
这里的实现方式有两种，分别是静态工厂模式与实例工厂模式。

+ 静态工厂: 就是指工厂方法是静态的，无需创建对象即可调用工厂方法。
+ 实例工厂: 即方法属于对象而非类，所以调用工厂方法需要创建一个工厂对象，然后根据此工厂对象调用工厂方法。

### 静态工厂创建bean
即写一个静态工厂的类，然后编写生成对象的逻辑，将生成的对象进行返回。
``` java

public class StaticFactory {
    public static Student getStu(String name, Integer age) {
        Student student = new Student();
        student.setName(name);
        student.setAge(age);
        student.setTeacher(new Teacher("刘老师", 12, "男"));
        student.setCourses(new String[]{"Hello", "World", "I am", "Chen"});
        return student;
    }
}
```
然后在xml配置文件中使用该工厂方法创建bean即可。
``` xml
<bean id="stuFactory" class="cn.hangcc.bean.StaticFactory" factory-method="getStu" c:name="Hang_c" c:age="32" />
```

这里的id就为我们获取组件的标识，class为静态工厂的全路径类名，factory-method指定此静态工厂的获取对象的方法名。如果该方法需要参数，则我们需要通过constructor传递参数，这里我用c命名空间简写了。
你也可以这样写.
``` xml
<bean id="stuFactory" class="cn.hangcc.bean.StaticFactory" factory-method="getStu">
        <constructor-arg name="name" value="Hang_c"/>
        <constructor-arg name="age" value="25"/>
    </bean>
```

### 实例工厂创建bean
首先，我们还是得写一个该工厂得对象，只是此工厂方法不属于类而是属于对象。
``` java

import java.util.ArrayList;
public class InstanceFactory {
    public Student getStu(String name, Integer age) {
        Student student = new Student();
        student.setName(name);
        student.setAge(age);
        ArrayList<Student> arr = new ArrayList<>();
        arr.add(new Student("张三", 14, null, null, null, null, null, null));
        arr.add(new Student("李四", 15, null, null, null, null, null, null));
        arr.add(new Student("王五", 16, null, null, null, null, null, null));
        student.setFriend(arr);
        student.setTeacher(new Teacher("呵呵", 54, "男"));
        return student;
    }
}
```
然后我们需要在xml配置文件中使用该实例工厂去创建bean。
首先因为是实例工厂创建bean，所以我们先需要在IOC容器中创建一个对象，然后根据此对象调用工厂方法
``<bean id="instanceFactory" class="cn.hangcc.bean.InstanceFactory"/>``。
然后对于我们创建得bean，需要依赖于此实例进行调用工厂方法。
``` xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
       
    <bean id="instanceFactory" class="cn.hangcc.bean.InstanceFactory"/>
    
    <bean id="stu" class="cn.hangcc.bean.Student" factory-bean="instanceFactory" factory-method="getStu" c:name="Hello" c:age="43"/>
    
    <bean id="stu1" class="cn.hangcc.bean.Student" factory-bean="instanceFactory" factory-method="getStu">
        <constructor-arg name="name" value="喜羊羊"/>
        <constructor-arg name="age" value="1"/>
    </bean>

</beans>
```
这里的id也是我们从IOC容器获取组件得入口。class为我们实际想要创建的全限定类名。 ``factory-bean``用来指定根据哪一个对象调用工厂方法，``factory-method``用来指定根据对象的哪一个方法构造对象。
同样的，如果工厂方法是有参的，则需要根据constructor用来指定参数。
这里可以用c命名空间指定，也可以用bean下面的标签``constructor-arg``指定，效果是一样的，个人感觉c命名空间更加简洁。

## FactoryBean实现创建bean
FactoryBean接口是Spring提供的工厂接口

我们可以直接实现该接口，并实现其包含的方法即可使用。
``` java

import org.springframework.beans.factory.FactoryBean;
public class MyFactoryBeanImpl implements FactoryBean<Student> {
    @Override
    public Student getObject() throws Exception {
        Student student = new Student();
        student.setName("abc");
        student.setAge(123);
        return student;
    }
    @Override
    public Class<?> getObjectType() {
        return Student.class;
    }
    @Override
    public boolean isSingleton() {
        return false;
    }
}
```
其中``getObject``方法就为对象的具体实现方法，我们在此方法中编写我们需要创建的对象的代码即可，Spring会自动帮我们调用此方法。

``getObjectType``就是获取当前工厂所需要创建对象的类的Class对象，``isSingleton``是用来判断当前工厂创建的对象是否是单例的，返回true则工厂创建的对象为单例的。返回false则是原型模式，每get一次，创建一个新的对象。
``` xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="bean" class="cn.hangcc.bean.MyFactoryBeanImpl"/>
</beans>
```

我们只需要在我们的Java代码中get唯一id标识，Spring会帮我们调用getObject()方法返回对象。 is
Singleton()方法的返回值来决定是单例还是多实例的。

