---
layout: post
title: ساخت تصاویر Thumbnail در فریم ورک اسپرینگ
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- تصویر-بند-انگشتی-اسپرینگ
- برنامه‌نویسی
redirect_from: 
  - /2016/12/create-thumbnail-image-in-spring-framework.html
---

  

این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [این نوشته‌ی](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) من در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. مزیت ساخت تصاویر بندانگشتی (thumbnail) این است که حجم تصاویر صفحه وب کاهش یافته و سرعت بارگزاری (load) تصاویر در صفحات وب افزایش می‌یابد.

 برای ساخت Thumbnail ابتدا باید dependency زیر را به پروژه خود اضافه کنیم:
{% highlight xml %}
<dependency>  
    <groupId>org.imgscalr</groupId>  
    <artifactId>imgscalr-lib</artifactId>  
    <version>4.2</version>  
    <type>jar</type>  
    <scope>compile</scope>  
</dependency>
{% endhighlight %}

حال هر جا که خواستیم از تصویر خود Thumbnail بسازیم، باید آن را به نوع BufferedImage تبدیل کنیم. می‌توانید از تابع زیر برای تولید Thumbnail استفاده کنید: (در اینجا تصویر ما از نوع MultipartFile است)

{% highlight java %}
import org.imgscalr.Scalr;   
/*  
...  
*/  
private ByteArrayOutputStream createThumbnail(MultipartFile orginalFile, Integer width) throws IOException{  
  
    ByteArrayOutputStream thumbOutput = new ByteArrayOutputStream();  
    BufferedImage thumbImg = null;  
    BufferedImage img = ImageIO.read(orginalFile.getInputStream());  
  
    thumbImg = Scalr.resize(img, Scalr.Method.AUTOMATIC, Scalr.Mode.AUTOMATIC, width, Scalr.OP_ANTIALIAS);  
    ImageIO.write(thumbImg, orginalFile.getContentType().split("/")\[1\] , thumbOutput);  
  
    return thumbOutput;  
}
{% endhighlight %}

در متد resize، ثابت  Scalr.Method.AUTOMATIC به معنای تنظیم نسبت طول تصویر به عرض آن به صورت اتوماتیک است.  
همچنین در متد  ImageIO.write، آرگومان دوم در واقع نوع تصویر مانند jpg، gif، png و... را مشخص می‌کند.
