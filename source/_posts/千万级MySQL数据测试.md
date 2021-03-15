---
title:  千万级MySQL数据测试
date: 2020年10月2日
tags: 
	- 面试
    - MySQL
  
---

![在这里插入图片描述](/image/刺客伍六七/5.jpg)
<escape><!-- more --></escape>
# 千万级数据生成插入测试
## 建表
```sql
CREATE TABLE boy(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT, -- 用户id 主键 唯一且不为空 自增
	`name` VARCHAR(20) NOT NULL, -- 用户姓名 非空
	`phone` VARCHAR(20) NOT NULL UNIQUE, -- 用户手机号 非空且唯一
	`girl_friendId` INT(11) -- 男用户的女朋友id 
)ENGINE = INNODB DEFAULT CHARSET = utf8; -- 存储引擎为innodb 且 默认编码为u8
```
## 通过JDBC进行添加数据
### 构造姓名
通过姓氏、名字、的随机组合，随机出姓名;
```java
private static String FIRST_NAME="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄魏加封芮羿储靳汲邴糜松井段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎祖武符刘姜詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲台从鄂索咸籍赖卓蔺屠蒙池乔阴郁胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛寿通边扈燕冀郏浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈廖庚终暨居衡步都耿满弘匡国文寇广禄阙东殴殳沃利蔚越夔隆师巩厍聂晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后江红游竺权逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台公冶宗政濮阳淳于仲孙太叔申屠公孙乐正轩辕令狐钟离闾丘长孙慕容鲜于宇文司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良拓拔夹谷宰父谷粱晋楚阎法汝鄢涂钦段干百里东郭南门呼延归海羊舌微生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱阳佟第五言福百家姓续";

private static String BOY = "伟刚勇毅俊峰强军平保东文辉力明永健世广志义兴良海山仁波宁贵福生龙元全国胜学祥才发武新利清飞彬富顺信子杰涛昌成康星光天达安岩中茂进林有坚和彪博诚先敬震振壮会思群豪心邦承乐绍功松善厚庆磊民友裕河哲江超浩亮政谦亨奇固之轮翰朗伯宏言若鸣朋斌梁栋维启克伦翔旭鹏泽晨辰士以建家致树炎德行时泰盛雄琛钧冠策腾楠榕风航弘";

public static String getOneBoyName(){
        char firstName = FIRST_NAME.charAt(random.nextInt(FIRST_NAME.length())); // 取出姓氏
        if(random.nextInt(2) == 0){ // 随机名字为两个字或者三个字
            String lastName = BOY.charAt(random.nextInt(BOY.length())) + "" + BOY.charAt(random.nextInt(BOY.length())); // 取出两个字
            return firstName + lastName;
        } else {
            char lastName = BOY.charAt(random.nextInt(BOY.length())); // 取出一个字
            return firstName + "" + lastName;
        }
    }
```
### 构造手机号
与上同理，通过已有的手机号前缀，随机出手机号，但手机号唯一，用一个set去维护不冲突。
```java
private static String[] TEL_FIRST = ("133, 153, 177, 180,181, 189, 134, 135, 136, 137, 138, 139, 150, 151, 152, 157, 158, 159," +        "178, 182, 183, 184, 187, 188, 130, 131, 132, 155, 156, 176, 185, 186," +        "145, 147, 170").split(",");

private static Set<String> phoneSet = new HashSet<>();

public static String getOneBoyPhone(){
        String phone;
        do{
            String pre = TEL_FIRST[random.nextInt(TEL_FIRST.length)].trim(); // 取出一个随机前缀
            String last = String.valueOf(random.nextInt(100000000)); // 随机一个后8为位
            if(last.length() < 8){ // 如果当前随机值不足8为 则前置位补0
                StringBuilder sb = new StringBuilder();
                for(int i = 0; i < 8 - last.length(); i++){
                    sb.append("0");
                }
                sb.append(last);
                last = sb.toString();
            }
            phone = pre + last;
        } while(phoneSet.contains(phone)); // 如果set集合已存在 则继续生成
        phoneSet.add(phone); // 添加到set集合 保证不重复
        return  phone;
    }
```

### 测试效率
通过JDBC进行操作数据库，进行插入数据操作。
```java

public static void addBoyUser(int n) throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/study?characterEncoding=utf-8", "root", "root");
        PreparedStatement statement = connection.prepareStatement("insert into boy values(?, ?, ?, ?)");
        for(int i = 1; i <= n; i++){
            statement.setString(1, null);
            statement.setString(2, getOneBoyName());
            String oneBoyPhone = getOneBoyPhone();
            while(phoneSet.contains(oneBoyPhone)){
                oneBoyPhone = getOneBoyPhone();
            }
            statement.setString(3, getOneBoyPhone());
            statement.setString(4, String.valueOf( (random.nextInt(100000000)) % 13 != 0 ?  random.nextInt(10000000) : 0));
        }
    }
```
**我们先插入1万条数据测试一下时间**
![在这里插入图片描述](/image/千万级MySQL数据测试/1.png)
我们可以看到需要15s左右，**但是**这里可能有小伙伴会怀疑存在set判重，生成数据等消耗的时间。我们可以测一下，只生成数据，不进行execute的时间。
![在这里插入图片描述](/image/千万级MySQL数据测试/2.png)
我们可以看到，生成数据的时间不超过1s，所以大部分时间是花在操作数据库上面。

**1万条数据就需要15秒左右，那千万级数据简单算一下就需要4个小时左右，我们显然不能接受**

## 千万数据快速插入优化
### 一次插入多个value值
我们都知道可以一次插入多条纪录
就像这样:
`insert into table values (字段1, 字段2, 字段3, ...), (字段1, 字段2, 字段3, ...), (字段1, 字段2, 字段3, ...);`
我们可以更改方法，使得一次插入多条数据，进而测试是否可以提高我们的插入效率
**总共1万条纪录**
这里分别测试拼接1条、10条、100条、1000条的插入完成时间

| 每次拼接的value条数 | 执行完成的时间 |
| ---- | ---- |
| 1条 | 15.482秒 |
| 10条 | 2.839秒 |
| 100条 | 0.966秒 |
| 1000条 | 0.865秒 |

我们可以看到，效果是非常明显的，但是显然我们的sql语句是有限制的，其长度不能过长。
我们可以执行sql语句`show VARIABLES WHERE Variable_name LIKE 'max_allowed_packet';`来查看自己机器目前所允许的sql最大字节数. **可以在my.ini配置文件中进行修改** 如: `max_allowed_packet = 8M`

除此之外，我们知道mysql是默认自动提交的。我们可以显式的开启事务，然后执行完毕之后进行commit，也可以增加我们插入的效率.
**总共1万条纪录**
这里分别测试拼接1条、10条、100条、1000条的插入完成时间(手动开启事务，执行完毕后统一提交事务)

| 每次拼接的value条数 | 执行完成的时间 |
| ---- | ---- |
| 1条 | 2.195秒 |
| 10条 | 1.004秒 |
| 100条 | 0.895秒 |
| 1000条 |0.76秒 |

观察结果我们可以发现，当一次插入一条纪录时，每次都是自动commit事务，导致效率的低下。我们手动commit之后，对于大量sql语句的执行有显著的效果。

### 将insert into语句改为 insert delayed into语句
innodb存储引擎不支持这样的语句 遂未测试

最终插入了1000万条数据，用时四分钟左右。
![在这里插入图片描述](/image/千万级MySQL数据测试/3.png)

```java

package mysql;
import java.sql.*;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;
public class addUserBoy {
    private static String FIRST_NAME="赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍史唐费廉岑薛雷贺倪汤滕殷罗毕郝邬安常乐于时傅皮卞齐康伍余元卜顾孟平黄和穆萧尹姚邵湛汪祁毛禹狄米贝明臧计伏成戴谈宋茅庞熊纪舒屈项祝董梁杜阮蓝闵席季麻强贾路娄危江童颜郭梅盛林刁钟徐邱骆高夏蔡田樊胡凌霍虞万支柯咎管卢莫经房裘缪干解应宗宣丁贲邓郁单杭洪包诸左石崔吉钮龚程嵇邢滑裴陆荣翁荀羊於惠甄魏加封芮羿储靳汲邴糜松井段富巫乌焦巴弓牧隗山谷车侯宓蓬全郗班仰秋仲伊宫宁仇栾暴甘钭厉戎祖武符刘姜詹束龙叶幸司韶郜黎蓟薄印宿白怀蒲台从鄂索咸籍赖卓蔺屠蒙池乔阴郁胥能苍双闻莘党翟谭贡劳逄姬申扶堵冉宰郦雍却璩桑桂濮牛寿通边扈燕冀郏浦尚农温别庄晏柴瞿阎充慕连茹习宦艾鱼容向古易慎戈廖庚终暨居衡步都耿满弘匡国文寇广禄阙东殴殳沃利蔚越夔隆师巩厍聂晁勾敖融冷訾辛阚那简饶空曾毋沙乜养鞠须丰巢关蒯相查后江红游竺权逯盖益桓公万俟司马上官欧阳夏侯诸葛闻人东方赫连皇甫尉迟公羊澹台公冶宗政濮阳淳于仲孙太叔申屠公孙乐正轩辕令狐钟离闾丘长孙慕容鲜于宇文司徒司空亓官司寇仉督子车颛孙端木巫马公西漆雕乐正壤驷公良拓拔夹谷宰父谷粱晋楚阎法汝鄢涂钦段干百里东郭南门呼延归海羊舌微生岳帅缑亢况后有琴梁丘左丘东门西门商牟佘佴伯赏南宫墨哈谯笪年爱阳佟第五言福百家姓续";
    private static String BOY = "伟刚勇毅俊峰强军平保东文辉力明永健世广志义兴良海山仁波宁贵福生龙元全国胜学祥才发武新利清飞彬富顺信子杰涛昌成康星光天达安岩中茂进林有坚和彪博诚先敬震振壮会思群豪心邦承乐绍功松善厚庆磊民友裕河哲江超浩亮政谦亨奇固之轮翰朗伯宏言若鸣朋斌梁栋维启克伦翔旭鹏泽晨辰士以建家致树炎德行时泰盛雄琛钧冠策腾楠榕风航弘";
    private static String[] TEL_FIRST = ("133, 153, 177, 180,181, 189, 134, 135, 136, 137, 138, 139, 150, 151, 152, 157, 158, 159," +
            "178, 182, 183, 184, 187, 188, 130, 131, 132, 155, 156, 176, 185, 186," +
            "145, 147, 170").split(",");
    private static final int Max = 10000000;
    private static Random random = new Random();
    private static Set<String> phoneSet = new HashSet<>();
    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        long start = System.currentTimeMillis();
        addBoyUser2(10000000, 1000);
        long end = System.currentTimeMillis();
        System.out.println("耗时: " + (end - start) / 1000.0 + "秒");
    }
    public static void addBoyUser(int n) throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/study?characterEncoding=utf-8", "root", "root");
        PreparedStatement statement = connection.prepareStatement("insert into boy values(?, ?, ?, ?)");
        for(int i = 1; i <= n; i++){
            statement.setString(1, null);
            statement.setString(2, getOneBoyName());
            statement.setString(3, getOneBoyPhone());
            statement.setString(4, String.valueOf( (random.nextInt(100000000)) % 13 != 0 ?  random.nextInt(10000000) : 0));
            statement.executeUpdate();
        }
    }
    public static void addBoyUser2(int n, int m) throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/study?characterEncoding=utf-8", "root", "root");
        connection.setAutoCommit(false);
        Statement statement = connection.createStatement();
        String sql = "insert into boy values";
        StringBuilder sb = new StringBuilder(sql);
        boolean flag = true;
        for(int i = 1; i <= n; i++){
            if(flag){ // 代表第一条数据
                sb.append("(null, '" + getOneBoyName() + "', '" + getOneBoyPhone() + "', '" + getGirlFriendId() + "')");
            } else {
                sb.append(", (null, '" + getOneBoyName() + "', '" + getOneBoyPhone() + "', '" + getGirlFriendId() + "')");
            }
            flag = false;
            if(i % m == 0){
                flag = true;
                statement.execute(sb.toString());
                sb.delete(0, sb.length());
                sb.append(sql);
            }
        }
        connection.commit();
    }
    public static String getOneBoyName(){
        char firstName = FIRST_NAME.charAt(random.nextInt(FIRST_NAME.length())); // 取出姓氏
        if(random.nextInt(2) == 0){ // 随机名字为两个字或者三个字
            String lastName = BOY.charAt(random.nextInt(BOY.length())) + "" + BOY.charAt(random.nextInt(BOY.length())); // 取出两个字
            return firstName + lastName;
        } else {
            char lastName = BOY.charAt(random.nextInt(BOY.length())); // 取出一个字
            return firstName + "" + lastName;
        }
    }
    public static String getOneBoyPhone(){
        String phone;
        do{
            String pre = TEL_FIRST[random.nextInt(TEL_FIRST.length)].trim(); // 取出一个随机前缀
            String last = String.valueOf(random.nextInt(100000000)); // 随机一个后8为位
            if(last.length() < 8){ // 如果当前随机值不足8为 则前置位补0
                StringBuilder sb = new StringBuilder();
                for(int i = 0; i < 8 - last.length(); i++){
                    sb.append("0");
                }
                sb.append(last);
                last = sb.toString();
            }
            phone = pre + last;
        } while(phoneSet.contains(phone)); // 如果set集合已存在 则继续生成
        phoneSet.add(phone); // 添加到set集合 保证不重复
        return  phone;
    }
    public static String getGirlFriendId(){
        int val = random.nextInt(10000000);
        return String.valueOf((val % 13 == 0) ? 0 : val);
    }
}


```
# Explain查看执行计划

## 概述
使用Explain命令可以模拟优化器执行SQL查询语句，从而知道MySQL是如何处理你的SQL语句的。分析你的查询语句或是表结构的性能瓶颈。 通过explain我们可以获得以下信息：
+ 表的读取顺序
+ 数据读取操作的操作类型
+ 那些索引可能被使用
+ 那些索引确实被使用了
+ 表之间的引用
+ 每张表有多少行被优化器查询
使用方式:`explain sql语句`

## 具体字段及含义
![在这里插入图片描述](/image/千万级MySQL数据测试/4.png)
### id
select的标识符。**其值越大、则优先级越高、越先读取、加载**
1. 当所有id相同时，读取顺序从上到下一次读取；
2. 当所有的id都不同时，id值越大则越靠前读取。(子查询括号最里面的最先读取)
3. 当出现即有相同又有不同时。id大的组先按从上到下的顺序读取，id下的组后按从上到下的顺序读取。

### select_type
**该字段是表示查询的类型**
可能出现的值。
+ SIMPLE 表示简单的查询，没有使用union或者子查询
+ PRIMARY sql语句中有子查询，那么最外层的查询语句会被标记为primary
+ SUBQUERY 不依赖于外部查询 例如 `select a.* , (select id from b where id = 1) from a`
当前子查询只是将结果集填充一列，且子查询返回结果为一行
+ DEPENDENT SUBQUERY 依赖于外部查询 例如 `select * from a where id in (select id from b)`
当前子查询依赖于a表，也就是说得到结果 得全表扫描a表 然后匹配结果集是否满足。a表有多少条纪录，急需要执行多少次子查询。
+ DERIVED 表示临时表数据，即部分子查询被标记为衍生(DERIVED)
+ UNION 若第二个SELECT出现在UNION之后，则被标记为UNION；
+ UNION RESULT 从UNION表获取结果的SELECT

### table
显示这一行数据是关于哪一个表的

### type
type显示的是访问类型，**是较为重要的一个指标**，结果值从最好到最坏依次是：
system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL
需要记忆的
**system>const>eq_ref>ref>range>index>ALL**
一般来说，得保证查询至少达到range级别，最好能达到ref。
+ system 表只有一行纪录(等于系统表) const的特例 理解: 别人查出来的东西 只有一行 你继续查
`select * from (select * from table where id = 1) a;` 
这种情况就会出现system

+ const  表示通过一次索引即可获得数据 即主键索引或者唯一索引 
理解: 指定索引类型为主键索引或者是唯一索引时 查询会出现const

+ eq_ref 唯一性索引扫描 对于每个索引键 表中只有唯一一条纪录与之匹配
当多表连接查询时，连接条件都是主键索引或唯一索引时出现，即唯一 连接 唯一 会出现eq_ref

+ ref 非唯一性索引扫描 返回匹配某个单独值得所有行
当条件符合单列索引或者联合索引的最左字段时，此时type类型为ref

+ range 只检索给定范围的行 一般是where条件出现非等值条件 如 in between and > <等
当查询条件为索引列 且其是范围查询 则此时为type类型为range

+ index 
当所查询的列，为主键 + 某一个索引的子集列， 那么就会走index，可以直接从索引中拿到所有数据
+ All
需要扫描全表才能拿到所有的数据。

### possible_key和key
+ possible_keys: 可能使用的key，但不一定会被使用
+ Key: 实际使用的索引。如果为NULL，则没有使用索引。查询中若使用了**覆盖索引**，则此时key为使用到的索引而possible_key为null。若当前索引中的字段+主键 覆盖了所需要查询的字段，则走索引就可以查出，无需扫描全表。

### key_len

Key_len表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度。在不损失精确性的情况下，长度越短越好
key_len显示的值为索引字段的最大可能长度，**并非实际使用长度**，即key_len是根据表定义计算而得，不是通过表内检索出的

key_len表示索引使用的字节数，根据这个值，就可以判断索引使用情况，特别是在组合索引的时候，判断所有的索引字段是否都被查询用到
char和varchar跟字符编码也有密切的联系,
latin1占用1个字节，gbk占用2个字节，utf8占用3个字节。（不同字符编码占用的存储空间不同）
**↓重点↓**
char 不为null 时候: Keylen=char(n)  = n*(utf8=3,gbk=2,latin1=1)；
___
char 允许为null 时候: Keylen=char(n)+允许Null=n*(utf8=3,gbk=2,latin1=1)+1
___
varchar 不为null 时候: Keylen=varchar(n)变长字段+不允许Null=n*(utf8=3,gbk=2,latin1=1)+2
___
varchar 允许为null 时候: Keylen=varchar(n)变长字段+允许Null=n*(utf8=3,gbk=2,latin1=1)+1+2
**↑重点↑**

### ref
显示索引的哪一列被使用了，如果可能的话，是一个常数。哪些列或常量被用于查找索引列上的值

### rows
根据表统计信息及索引选用情况，大致估算出找到所需的记录所需要读取的行数

### Extra
包含不适合在其他列中显示但十分重要的额外信息。
+ Using filesort 会对数据使用一个外部的索引排序，无法利用索引完成排序。
+ Using temporary 使用了临时表保存了中间结果，MySql在对排序结果排序时 使用了临时表
+ Using index。 表示使用了覆盖索引。如果同时出现了 using where 表示索引被用来执行索引键值的查找，如果没出现 则表示索引用来读取数据，而非进行查找。

## 单表测试

## 多表测试
# 索引优化测试