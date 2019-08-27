---
layout: post
title: استفاده از JsonView در فریم ورک اسپرینگ (Spring Framework)
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- آموزش-json-در-اسپرینگ-جاوا
- Morteza-Asadi
- برنامه‌نویسی
redirect_from: 
  - /2016/12/using-jsonview-spring-framework.html
---

پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. به طور معمول برای نمایش دیتا به کاربر از view model استفاده می‌کنیم؛ اما گاهی اوقات پیش می‌آید که در جایی از پروژه، تمام فیلدهای view model را نیاز داشته باشیم و در جای دیگر بخشی از این فیلدها مورد نیاز باشد.

یک راه حل برای انجام این کار، استفاده از (DTO (Domain Transfer Object است که فیلدهای مورد نظر خود را در آن قرار داده و returnType متدهایمان را از نوع آن DTO بگیریم. اما این کار به نوعی باعث ایجاد افزونگی می‌شود؛ چون احتمالا در کد خود متدهایی خواهیم داشت که کار یکسانی انجام می‌دهند و فقط returnType آنها متفاوت است؛ به عنوان مثال دو متد getAll خواهیم داشت که خروجی یکی از نوع view model است و خروجی دیگری از نوع DTO. در صورتی که کاری که هر دو متد انجام می‌دهند کار یکسانی است.

راه حل دوم برای انجام این کار، استفاده از JsonView است؛ با استفاده از آن می‌توان فیلدهای مورد نظر خود را که می‌خواهیم در json خروجی باشد را در view model مشخص کنیم. خوشبختانه Spring Framework 4.x به طور پیش‌فرض از JsonView پشتیبانی می‌کند. برای انجام باید مراحل زیر را دنبال کنید:

- یک کلاس به نام View به صورت زیر ایجاد می‌کنیم:

{% highlight java %}
public class View {  
      public interface Summary {}  
}
{% endhighlight %}

- حال در view model مورد نظر خود، فیلدهایی را که می‌خواهیم در خروجی باشد را با JsonView@ مشخص می‌کنیم:

{% highlight java %}
public class GroupsViewModel extends BaseEntityViewModel<Long> {  
     @JsonView(View.Summary.class)  
     private String                title;  
     private String                description;  
     private Set<UserViewModel>    users;  
}
{% endhighlight %}

- سپس در Controller برای متدی که می‌خواهیم فقط شامل فیلدهای مشخص شده باشد JsonView@ را به صورت زیر اضافه می‌کنیم:  

{% highlight java %}
@RestController  
@RequestMapping("/group")  
public class GroupsController {  
     @Autowired  
     private IGroupsService     iGroupsService;  
  
     @RequestMapping("/getAllGroups")  
     @JsonView(View.Summary.class)  
     @ResponseBody  
     public List<GroupsViewModel> getAllGroups() {  
         return ModelMapper.mapList(iGroupsService.getAll(), GroupsViewModel.class);  
     }  
{% endhighlight %}

با این کار در json خروجی فقط فیلدهایی که در view model مشخص کرده‌ایم نمایش داده خواهند شد.  

حال اگر بخواهیم از این روند به صورت inheritanceو سلسله مراتبی استفاده کنیم (برای مثال GroupsViewModel را در نظر بگیرید که یک attribute به صورت Set<UserViewModel> users دارد؛ حال اگر بخواهیم که در UserViewModel هم فقط چند فیلد انتخاب شده در  json خروجی باشند، لازم است که کلاس View  به صورت زیر تغییر کند:

{% highlight java %}
public class View {  
     public interface Summary {}  
     public interface SummaryWithRecipients extends Summary {}  
}
{% endhighlight %}

همچنین باید Annotation مرود استفاده برای Set<UserViewModel>  users به صورت زیر باشد:  

{% highlight java %}
public class GroupsViewModel extends BaseEntityViewModel<Long> {  
     @JsonView(View.Summary.class)  
     private String                title;  
     private String                description;  
     @JsonView(View.SummaryWithRecipients.class)  
     private Set<UserViewModel>    users;  
}
{% endhighlight %}

و فیلدهای مورد نظر (را که می‌خواهیم در json خروجی باشند) در UserViewModel را همانند مدل GroupsViewModel به صورت زیر مشخص می‌کنیم:  

{% highlight java %}
public class UserViewModel extends BaseEntityViewModel<Long> {  
     @JsonView(View.Summary.class)  
     private String      username;  
     @JsonView(View.Summary.class)  
     private String      firstname;  
     @JsonView(View.Summary.class)  
     private String      lastname;  
     private String      email;  
     private String      password;  
}

{% endhighlight %}
  
همچنین باید Annotation مورد استفاده در متد کنترلر از (JsonView(View.Summary.class@ به (JsonView(View.SummaryWithRecipients.class@ تغییر کند.