---
layout: post
title: بازنویسی url در فریم ورک اسپرینگ (Spring Framework)
author: مرتضی اسدی
tags:
- آموزش-بازنویسی--url-در-اسپرینگ-جاوا
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- Morteza-Asadi
- برنامه‌نویسی
redirect_from: 
  - /2016/12/rewrite-url-in-spring-framework.html
---

پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. استفاده از slug (نامک) در آدرس‌ها و url صفحات مزایای زیادی از جمله SEO-friendly و user-friendy را به همراه دارد. tuckey یک dependency برای بازنویسی urlها (rewrite URLs) در زبان جاواست و عملکردی بسیار مشابه mod_rewrite آپاچی دارد.

برای افزودن این dependency به پروژه‌ی خود مراحل زیر را دنبال کنید:

{% highlight xml %}
<dependency>  
    <groupId>org.tuckey</groupId>  
    <artifactId>urlrewritefilter</artifactId>  
    <version>4.0.3</version>  
</dependency>
{% endhighlight %}

در ادامه باید در فایل web.xml فیلتر زیر را اضافه کنیم:

{% highlight xml %}
<filter>  
    <filter-name>UrlRewriteFilter</filter-name>  
    <filter-class>org.tuckey.web.filters.urlrewrite.UrlRewriteFilter</filter-class>  
</filter>  
<filter-mapping>  
    <filter-name>UrlRewriteFilter</filter-name>  
    <url-pattern>/portal/*</url-pattern>  
    <dispatcher>REQUEST</dispatcher>  
    <dispatcher>FORWARD</dispatcher>  
</filter-mapping>
{% endhighlight %}

حال باید یک فایل با نام urlrewrite.xml در مسیر procjetName/src/main/webapp/WEB-INF ساخته و ruleهای مورد نظر خود را برای رای بازنویسی urlها در آن بنویسیم. به عنوان مثال یکی از ruleهایی که من برای slugify استفاده کردم به صورت زیر است:

{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>  
<!DOCTYPE urlrewrite PUBLIC "-//tuckey.org//DTD UrlRewrite 4.0//EN" "http://www.tuckey.org/res/dtds/urlrewrite4.0.dtd">  
<urlrewrite>  
 <rule>  
	<from>^/news/(.*)/(.*)$</from>  
	<to type="passthrough">/rest/news/details/$1?title=$2</to>  
 </rule>  
</urlrewrite>
{% endhighlight %}

در نهایت ذکر این نکته ضروری است که کاربردهای این dependency تنها شامل slugify نمی‌شود؛ بلکه مواردی نظیر نمایش صفحات برای انواع خطاها، redirect کردن و به طور کلی تقریبا تمام کارهایی که با mod_rewrite آپاچی انجام‌پذیر است را می‌توان با این dependency انجام داد.
