---
layout: post
title: دادن دسترسی به کاربران Login کرده در Spring-Security
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- آموزش-مفاهیم-spring-security
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- Morteza-Asadi
- برنامه‌نویسی
redirect_from: 
  - /2016/12/give-access-authenticated-user-spring-security.html
---
پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. پروژه‌ی Spring Security یکی از ابزارهای قدرتمند برای احراز هویت و دادن دسترسی در برنامه‌های اسپرینگ است. در این نوشته قصد داریم به کاربران وارد شده در اپلیکیشن (صرف نظر از هر Roleی که دارند) دسترسی بدهیم.

در spring-security 3.x در فایل spring-security در قسمت کنترل دسترسی‌ها به urlها که با تگ security:intercept-url مشخص می‌شود، ROLEهای مختلفی را می‌توان استفاده کرد از جمله IS_AUTHENTICATED_ANONYMOUSLY برای دادن دسترسی به کلیه کاربران اعتبارسنجی شده یا نشده.  
  
حال اگر بخواهی دسترسی به یک url خاص را فقط به کاربران Login کرده در سیستم بدهیم و کاری به ROLEهای خاصی که هر کاربر دارد نداشته باشیم؛ می‌توانیم ازIS_AUTHENTICATED_FULLY استفاده کنیم؛ مثال زیر را در نظر بگیرید:

{% highlight xml %}
<security:intercept-url    pattern="/view/cpanel/user/Profile.jsp*"   access="IS_AUTHENTICATED_FULLY" />
{% endhighlight %}
  
این rule اجازه دسترسی به url مشاهده‌ی پروفایل به کلیه کاربران Login کرده در سیستم -صرف نظر از هر ROLEی که دارند- را می‌دهد.
  
**آپدیت:** در spring-security 4.x باید عبارت IS_AUTHENTICATED_ANONYMOUSLY را با **()isFullyAuthenticated** جایگزین نماییم.