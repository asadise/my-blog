---
layout: post
title: 'آموزش جی کوئری: امکان Deselect کردن یک radio input با استفاده از جی کوئری'
author: مرتضی اسدی
tags:
- آموزش-جاوا-اسکریپت-به-زبان-ساده
- اموزش-جی-کوئری
- کدهای-جی-کوئری
- کار-با-جی-کوئری
- jquery-آموزش
- مرتضی-اسدی
- Morteza-Asadi
- برنامه‌نویسی

---

  
جی کوئری یک کتابخانه متن‌باز و رایگان جاوا اسکریپت است که کار نوشتن اسکریپتها به زبان جاوا اسکریپت را راحت‌تر می‌کند و امروزه محبوب‌ترین کتابخانه‌ی جاوااسکریپت در حال استفاده است. من در این نوشته قصد دارم آموزش select و Deselect کردن radio inputها را در HTML بنویسم.



همانطور که می‌دانید در HTML چندین نوع input برای گرفتن ورودی از کاربر وجود دارد. یکی از این inputها نوع radio است و برای انتخاب یک مقدار از بین چند مقدار استفاده می‌شود.  پس از انتخاب یک radio input امکان Deselect آن در HTML وجود ندارد (برخلاف checkBoxها). اما گاهی اوقات (مثلا در سوال‌های چندگزینه‌ای) لازم است که این امکان را به کاربر بدهیم. برای افزودن این امکان می‌توان از کد زیر استفاده کرد:

{% highlight javascript %}
$('input[type="radio"]').on('click change', function () {
$(this).prop('checked')                                                              //if checked
    ? $(this).prop('checked',false).data('waschecked', false)                        //uncheck
    : $(this).prop('checked',true).data('waschecked', true)                          //else check
    .siblings('input[name="'+$(this).prop('name')+'"]').data('waschecked', false);   //make siblings false
});
{% endhighlight %}

در این حالت با یک بار کلیک روی یک radio input، آن عنصر انتخاب شده و با کلیک مجدد روی همان Radio input به صورت Deselect درمی‌آید. 

امیدوارم از این آموزش جی کوئری استفاده کافی برده باشید.
