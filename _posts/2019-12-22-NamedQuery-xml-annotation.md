---
layout: post
title: استفاده از NamedQuery به دو صورت XML و annotation
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- آموزش-هایبرنت-در-اسپرینگ-جاوا
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- Morteza-Asadi
- برنامه‌نویسی
---
  

پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ و هایبرنیت است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. هایبرنیت یک کتابخانه object-relational mapping برای زبان جاوا است که چارچوبی را برای نگاشت یک شی به یک پایگاه داده رابطه‌ای فراهم می‌آورد. نوشتن NamedQuery به صورت XMLی بدین صورت است که در فایل XML متناظر با مدل (Model) خود، بعد از تعریف propertyها باید کوئری مورد نظر خود را به صورت  صورت زیر تعریف کنیم:





{% highlight xml %}
<hibernate-mapping>
   <class name="org.somePackages.MyModel" table="table_name" schema="...">
   <!-- id, properties, Relations and so on... -->
   <sql-query name="applicantForImages" callable="true">
	{ call DBPK_SMP.get_all_codes(?, :param1_var, :param2_var) }
   </sql-query>
</hibernate-mapping>
{% endhighlight %} 



نوشتن  NamedQuery به صورت annotation تقریبا مشابه حالت XML است و تفاوت آن فقط در این مورد است که در این حالت فایل XMLی وجود ندارد و تعریف  NamedQuery را به صورت انوتیشنی و در بالای کلاس مدل (Model) می‌آوریم؛ تکه کد زیر تعریف NamedQuery در این حالت را نشان می‌هد:

{% highlight java %}
@Entity
@Table(schema = "...", name = "table_name")
@SqlResultSetMapping(name = "pkgResult",
classes = {
            @ConstructorResult(
                targetClass = org.somePackages.MyDto.class,
                columns = {
                       @ColumnResult(name = "firstPropertyOfMyDTO", type = Long.class),
                       @ColumnResult(name = "secondPropertyOfMyDTO", type = String.class)
                  }
            )
      }
)
@NamedNativeQuery(
  name = "getAllDuplicateCodes",
  callable = true,
  query = " {call DBPK_SMP.get_all_codes(?, :param1_var, :param2_var)} ",
  resultSetMapping = "pkgResult"
)
public Class MyModel extends BaseEntity<Long>{
  // peoperties, Getter & Setter and so on...
}
{% endhighlight %} 

حال برای فراخوانی کوئری در لایه‌ی Repository کافی است NamedQueryی که در مدل (Model) خود تعریف کرده‌ایم را به صورت زیر فراخوانی کنیم:
{% highlight java %}
public List<LongPairDto> getAllDuplicateCodes(Long param1, Long param2) {
   Session session = getSession();
   Query query = session.getNamedNativeQuery("getAllDuplicateCodes");
   query.setParameter("param1_var", param1);
   query.setParameter("param2_var", param2);
  return query.list();
}
{% endhighlight %} 
