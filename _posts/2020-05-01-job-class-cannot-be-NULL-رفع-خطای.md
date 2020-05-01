---
layout: post
title: رفع خطای ORA-2745 job class cannot be NULL
author: مرتضی اسدی
tags:
- آموزش-اوراکل
- آموزش-نرم‌افزار-اوراکل
- مرتضی-اسدی
- Morteza-Asadi
- برنامه‌نویسی
---

بیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ و هایبرنیت همراه با دیتابیس اوراکل است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. پایگاه داده‌ی اوراکل (oracle) جزء قوی‌ترین پایگاه‌داده‌ها یا DBMS در دنیای نرم‌افزار به شمار می‌رود. از جمله ویژگی‌های آن می‌توان به سرعت بالا در دسترسی به داده‌ها، ضریب امنیتی بالا، کنترل همزمانی، توانایی نگهداری حجم انبوه اطلاعات و ... اشاره نمود. در این نوشته یک روش برای  رفع خطایی که در هنگام ذخیره یک job اوراکل در  PL/SQL پیش می‌آید ارائه می‌کنیم.

  
  
برای تعریف یک job در اوراکل معمولا از فرم زیر در PL/SQL استفاده می‌کنیم. فرم زیر یک stored procedure را نشان می‌دهد که برای محاسبه‌ی مقدار تجمیعی یک موجودیت به کار می‌رود؛ همانطور که از تصویر مشخص است این job به صورت روزانه قرار است از یک تاریخ به بعد راس ساعت مقرری (۱۲ شب) اجرا شود.
{:refdef: class="center"}
![Stored Procedure in PL/SQL]({{ site.baseurl }}/images/pl-sql-job.png "Stored Procedure in PL/SQL")
{: refdef}

 اما گاها پیش می‌آید که با apply کردن فرم بالا خطای زیر مشاهده می‌شود:
> ORA-2745: job class cannot be NULL

 برای رفع این مشکل باید در فرم بالا روی view SQL کلیک کرد و مقدار job_class را برابر با DEFAULT_JOB_CLASS قرار داد.

{% highlight sql %}
begin
sys.dbms_scheduler.create_job(job_name        => 'AMD.JOB_REFRESH_AGG_CONSUM',
                              job_type        => 'STORED_PROCEDURE',
                              job_action      => 'DBPK_DST_PROC.refresh_aggrgte_matviews',
                              start_date      => to_date('27-01-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),
                              repeat_interval => 'Freq=Secondly;Interval=30',
                              end_date        => to_date(null),
                              job_class       => 'DEFAULT_JOB_CLASS',
                              enabled         => true,
                              auto_drop       => false,
                              comments        => '');
end;
{% endhighlight %}
