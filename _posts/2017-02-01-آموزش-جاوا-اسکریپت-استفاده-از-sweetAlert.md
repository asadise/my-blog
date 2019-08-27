---
layout: post
title: 'آموزش جاوا اسکریپت: استفاده از sweetAlert برای نمایش اعلان و اطلاعیه‌ها'
author: مرتضی اسدی
tags:
- آموزش-جاوا-اسکریپت-به-زبان-ساده
- کتاب-آموزش-جاوا-اسکریپت
- مرتضی-اسدی
- Morteza-Asadi
- برنامه‌نویسی
redirect_from:
  - /2017/02/using-sweetalert-for-show-alert-notification.html
---

  

این روزها استفاده از زبان جاوا اسکریپت و تکنولوژی‌های مرتبط با آن بسیار فراگیر شده است. برای همین قصد دارم که در این آموزش جاوا اسکریپت، چند راه‌حل را برای نشان دادن اعلان‌ها و هشدارها را در مرورگرها بررسی کنیم. برای نمایش اعلان‌ها و پنجره تایید از طریق جاوا اسکریپت راه‌های زیادی وجود دارد؛ در این نوشته قصد دارم سه روش مفید و کاربردی برای نشان دادن اعلان‌ها و پنجره تایید از طریق جاوا اسکریپت و کتابخانه‌های مبتنی بر جی‌کوئری را بررسی کنم.


  
**۱٫ ()alert و ()confirm جاوا اسکریپت**  
در ابتدای این آموزش جاوا اسکریپت ساده‌ترین راه را بررسی می‌کنیم؛ ساده‌ترین راه استفاده از ()alert  و ()confirm مربوط به جاوا اسکریپت  pure است؛ اما این سادگی همراه با محدودیت‌هایی است، از جمله اینکه نمی‌توانیم style آنها را متناسب با نیاز خود شخصی‌سازی کنیم و همچنین هر مرورگری استایل آنها را به نحو متفاوتی پیاده‌سازی کرده است و این باعث می‌شود که پیام‌ها و اعلان‌های اپلیکیشن ما در هر مرورگر به یک شکل به نمایش درآید. مورد بعدی این است که کاربر می‌تواند نمایش این توایع از جمله ()alert را در مرورگر خود Block کند. به همین دلیل شاید بهتر باشد که از کتابخانه‌ها و ابزارهای آماده که مبتنی بر جی‌کوئری هستند، استفاده نماییم.  

#### **۲٫** toast

 [toast](https://github.com/CodeSeven/toastr){:rel="nofollow"} یک پلاگین jQuery برای نمایش اعلان‌ها و هشدارها است. این پلاگین قابلیت‌ها و موراد زیادی برای شخصی سازی دارد که در تصویر زیر مشخص است.

  
{:refdef: class="center"}
![آموزش جاوا اسکریپت]( {{ site.baseurl }}/images/toast.jpg "آموزش جاوا اسکریپت")
{: refdef}
  
  

#### **۳٫** sweetAlert

[sweetalert](http://t4t5.github.io/){:rel="nofollow"} یک پلاگین jQuery دیگر برای نمایش اعلان‌ها و هشدار است که استفاده از انیمیشن در پیام‌ها و شخصی‌سازی از جمله مزیت‌های آن محسوب می‌شود.

  

{:refdef: class="center"}
![آموزش جاوا اسکریپت]( {{ site.baseurl }}/images/sweetAlert.gif "آموزش جاوا اسکریپت")
{: refdef}

  
  

آموزش جاوا اسکریپت: **استفاده از sweetAlert به جای ()alert  و ()confirm**
-------------------------------------------------------------------------

در انتهای این آموزش جاوا اسکریپت، تکه کدی برای تبدیل ()alert  و ()confirm به sweetAlert ارائه می‌دهم:  

{% highlight javascript %}
//alert in pure javaScript  
alert("Your Message");  
  
//alert in SweetAlert  
swal({  
     title: "",  
     text: "Your Message",  
     type: "success", //also use error, warning,...  
     timer: 1400,  
     showCancelButton: false,  
     showConfirmButton: false,  
     showLoaderOnConfirm: false,  
});

  

// confirm in pure javaScript  
if(confirm("Are you sure?")){  
     // Do something...  
}  
  
// confirm in SweetAlert  
swal({  
     title: "",  
     text: "Are you sure?",  
     type: "warning",  
     showCancelButton: true,  
     closeOnConfirm: true,  
     showLoaderOnConfirm: false,  
}, function(){  
     //Do something...  
}
{% endhighlight %}
  
امیدوارم از این آموزش جاوا اسکریپت استفاده کافی برده باشید.