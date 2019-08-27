---
layout: post
title: رفع خطای can bind a LONG value only for insert into a LONG column
 در پایگاه داده‌ی اوراکل
author: مرتضی اسدی
tags:
- آموزش-اوراکل
- آموزش-نرم‌افزار-اوراکل
- مرتضی-اسدی
- Morteza-Asadi
- برنامه‌نویسی

redirect_from: 
  - /2017/07/can-bind-long-value-only-for-insert.html

---

بیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ و هایبرنیت همراه با دیتابیس اوراکل است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. پایگاه داده‌ی اوراکل (oracle) جزء قوی‌ترین پایگاه‌داده‌ها یا DBMS در دنیای نرم‌افزار به شمار می‌رود. از جمله ویژگی‌های آن می‌توان به سرعت بالا در دسترسی به داده‌ها، ضریب امنیتی بالا، کنترل همزمانی، توانایی نگهداری حجم انبوه اطلاعات و ... اشاره نمود. در این نوشته به بررسی یک مشکل که به هنگام ذخیره یک فایل در اوراکل ممکن است پیش بیاید، می‌پردازیم.

  
معمولا برای ذخیره فایل یک property با نوع داده‌ای \[\]byte در پایگاه داده در فایل هایبرنیت از نوع binary استفاده می‌کنیم:  
{% highlight java %}
//In Model  
private byte[]     answerImage;  
  
//In Hibernate file (.hbm.xml)  
<property  name="answerImage"  column="answer_image" type="binary" not-null="true" />  
{% endhighlight %}

  
در این حالت در پایگاه داده اوراکل نوع داده‌ای (RAW(255 برای این ستون در نظر گرفته می‌شود؛ اما این امر باعث می‌شود که در هنگاه ذخیره یک فایل (مثلا یک تصویر) در پایگاه داده با خطای زیر مواجه شویم:  

{% highlight shell %}
ERROR: ORA-01461: can bind a LONG value only for insert into a LONG column
{% endhighlight %}

دلیل این خطا محدودیت اندازه نوع داده‌ای (RAW(255 است. حال اگر در فایل هایبرنت نوع ستون را به blob تغییر دهیم؛  
{% highlight xml %}
 <property  name="answerImage"  column="answer_image" type="blob" not-null="true" />
{% endhighlight %}
 در اینصورت با خطای زیر مواجه می‌شویم:  

{% highlight shell %}
ERROR: B cannot be cast to java.sql.Blob
{% endhighlight %}
دلیل این خطا این است که در سطح هایبرنت، تبدیل نوع از باینری به blob نمی‌تواند انجام شود.  
  
راه‌حل: برای رفع این مشکل بایستی در فایل هایبرنت برای نوع ستون از همان نوع binary استفاده نمود و در پایگاه داده به صورت دستی نوع ستون را از (RAW(255 به blob تغییر داد.