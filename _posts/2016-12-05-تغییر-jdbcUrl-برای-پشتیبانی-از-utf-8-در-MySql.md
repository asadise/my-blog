---
layout: post
title: تغییر jdbc url برای پشتیبانی از utf-8 در پایگاه داده MySql
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- Morteza-Asadi
- برنامه‌نویسی
redirect_from: 
  - /2016/12/jdbc-url-utf8-support-mysql-database.html
---
  
این نوشته مربوط به فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من می‌تواند مفید باشد. اگر پس از پیکربندی پایگاه داده‌ی MySql در پروژه اسپرینگ خود با درج حروف فارسی در پایگاه داده مشکل دارید نیازمند تغییر jdbc url به گونه‌ای هستید که از یونیکد (Unicode) نیز پشتیبانی کند.
  
برای اینکه بتوان در پایگاه داده‌هایهای MySQL، متن فارسی insert نمود، لازم است در jdbc.url عبارت زیر وارد شود:  
{% highlight shell %}
jdbc.url=jdbc\:mysql\://localhost\:3306/نام دیتابیس موردنظر?zeroDateTimeBehavior\=convertToNull&useUnicode\=yes&characterEncoding\=UTF-8&characterSetResults\=UTF-8
{% endhighlight %}
