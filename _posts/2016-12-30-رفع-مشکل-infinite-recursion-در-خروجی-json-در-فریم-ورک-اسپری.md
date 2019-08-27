---
layout: post
title: رفع مشکل Infinite Recursion در خروجی json در فریم ورک اسپرینگ برای مدل‌هایی که ارتباط دو طرفه دارند
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- Morteza-Asadi
- آموزش-جیسون-در-اسپرینگ-جاوا
- برنامه‌نویسی
redirect_from: 
  - /2016/12/infinite-recursion-for-bi-directional-model-spring-framework.html
---

پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. فرض کنید که دو مدل داریم که با هم ارتباط bi-directional دارند؛ یعنی هر کدام از این مدل‌ها یک property از مدل دیگر دارند؛ view model برای این دو مدل به صورت زیر هستند:

{% highlight java %}
public class GroupsViewModel extends BaseEntityViewModel<Long> {  
     private String               title;  
     private Set<UserViewModel>   users;  
{

public class UserViewModel extends BaseEntityViewModel<Long> {  
     private String                 username;  
     private String                 password;  
     private Set<GroupsViewModel>   groups;  
}
{% endhighlight %}
  
در این حالت در خروجی json هر یک از view modelها به Infinite Recursion برخواهیم خورد؛ چرا که jackson با مشاهده هر فیلد به دنبال تولید آن رفته و چون هر کدام از مدل‌ها یک فیلد از دیگری را دارند دچار Infinite Recursion خواهد شد. سه راه‌حل برای این مشکل وجود دارد:  

**روش ۱. استفاده از JsonIgnore@****:** دراین روش بر روی خود property یا بر روی متد set آن، این annotation را می‌گذاریم تا کلا در خروجی json ظاهر نشود؛ درواقع در این روش صورت مسئله را پاک می‌کنیم و دسترسی ما به object مورد نظر فقط از یک طرف امکان‌پذیر خواهد بود.

**روش ۲. استفاده از JsonManagedReference@****و** **JsonBackReference****@**: در این روش به jackson این اجازه را می‌دهیم که به صورت مدیریت شده دیتا را به صورت json نمایش دهد. برای این منظور بر روی property (یا متد set آن) که می‌خواهیم دسترسی ما به object از طرف آن مدل باشد JsonManagedReference@ گذاشته و در view model دیگر بر روی آن property که ایجاد حلقه می‌کند JsonBackReference@ می‌گذاریم. لازم به ذکر است که نتیجه این روش تفاوت چندانی با روش ۱ ندارد و دسترسی ما به object مورد نظر همواره از یک طرف خواهد بود.

**روش ۳. استفاده از  JsonIdentityInfo****@**: در این روش jackson با استفاده از یکی از propertyهای یکتای مدل، instanceهای آن مدل را در خروجی json شناسایی می‌کند و هر instance را تنها یک بار در خروجی json می‌آورد و در صورت تکرار آن instance، تنها propertyهای یکتای آن را در خروجی می‌آورد. برای استفاده از این روش کافی است که روی هر یک از view modelهای درگیر در رابطه، annotation زیر را بگذاریم:

{% highlight java %} 
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")  
public class GroupsViewModel extends BaseEntityViewModel<Long> {  
  
     private String               title;  
     private Set<UserViewModel>   users;  
{

@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")  
public class UserViewModel extends BaseEntityViewModel<Long> {  
     private String                 username;  
     private String                 password;  
     private Set<GroupsViewModel>   groups;  
}
{% endhighlight %}
  
همانطور که در در دو view model مشاهده می‌کنیم، برای شناسایی (Identity) هر instance، از id آن instance استفاده کرده‌ایم و در خروجی json هر instance  تنها یکبار می‌آید و در صورت تکرار در خروجی، Identity آن (یا همان id آن) چاپ می‌شود. با استفاده از این روش دیگر خروجی json ما در Infinite Recursion نخواهد افتاد. خروجی json مورد نظر به صورت زیر خواهد بود:
{% highlight json %} 
[{  
  "id" : 1,  
  "title" : "گروه مدیران کل",  
  "users" : [{  
        "id" : 1,  
        "username" : "admin",  
        "password" : "...",  
        "groups" : [1]  
     }, {  
        "id" : 31,  
        "username" : "user78",  
        "password" : "...",  
        "groups" : [1]  
     }, {  
        "id" : 3,  
        "username" : "ali",  
        "password" : "...",  
        "groups" : [{  
              "id" : 2,  
              "title" : "گروه نویسندگان خبر",  
              "users" : [{  
                    "id" : 14,  
                    "username" : "staff1",  
                    "password" : "...",  
                    "groups" : [{  
                          "id" : 1005,  
                          "title" : "گروه دسترسی به فایل",  
                          "users" : [{  
                                "id" : 25,  
                                "username" : "test1",  
                                "password" : "...",  
                                "groups" : [1005, {  
                                      "id" : 1006,  
                                      "title" : "گروه بدون دسترسی برای کاربران تست",  
                                      "users" : [25, {  
                                            "id" : 26,  
                                            "username" : "test5",  
                                            "password" : "...",  
                                            "groups" : [1006]  
                                         }  
                                      ]  
                                   }  
                                ]  
                             }, ۱۴]  
                       }, ۲]  
                 }, ...
{% endhighlight %}
