---
layout: post
title: رفع مشکل استفاده از CKEditor در modal بوت استرپ
author: مرتضی اسدی
tags:
- آموزش-فارسی-بوت-استرپ
- آموزش-بوت-استرپ
- آموزش-استفاده-از-ckeditor
- مرتضی-اسدی
- Morteza-Asadi
- برنامه‌نویسی
redirect_from: 
  - /2016/12/ckeditor-on-bootstrap-modal.html
---

اگر بخواهیم از ویراشگر متن CK Editor در یک Bootstrap Modal استفاده کنیم، از آنجایی که خود CK Editor نیز برای کارهایی نظیر درج لینک یا تصویر و... از یک modal استفاده می‌کند؛ برای همین دچار conflict می‌شویم و دیگر تمای inputهای فرم‌های درج لینک، تصویر disable خواهند شد.

برای رفع این مشکل باید از اسکریپت زیر کمک بگیریم:

{% highlight javascript %}
<script>  
$.fn.modal.Constructor.prototype.enforceFocus = function () {  
    var $modalElement = this.$element;  
    $(document).on('focusin.modal', function (e) {  
        var $parent = $(e.target.parentNode);  
        if ($modalElement\[0\] !== e.target && !$modalElement.has(e.target).length  
            &&  
            !$parent.hasClass('cke\_dialog\_ui\_input\_select') && !$parent.hasClass('cke\_dialog\_ui\_input\_text')) {  
            $modalElement.focus()  
        }  
    })  
};  
</script>
{% endhighlight %}

با استفاده از اسکریپت فوق دیگر conflict پیش آمده حل شده و تمام inputهای modal داخلی CKEditor به صورت عادی قابل استفاده خواهند بود.
