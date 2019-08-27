---
layout: post
title: آموزش کار با formScanner در فریم‌ورک اسپرینگ
author: مرتضی اسدی
tags:
- آموزش-فریم-ورک-اسپرینگ
- مرتضی-اسدی
- آموزش-جاوا-اسپرینگ
- پردازش-تصویر-در-اسپرینگ-جاوا
- برنامه‌نویسی

---
  

پیش از هر چیز باید بگویم که این نوشته مربوط به برنامه‌نویسی در فریم‌ورک اسپرینگ است؛ اگر با این فریم‌ورک آشنایی ندارید، خواندن [آموزش فریم ورک اسپرینگ](http://asadiweb.ir/%d9%81%d8%b1%db%8c%d9%85-%d9%88%d8%b1%da%a9-%d8%a7%d8%b3%d9%be%d8%b1%db%8c%d9%86%da%af-spring-framework-%da%86%db%8c%d8%b3%d8%aa%d8%9f/) در مورد این چهارچوب برنامه‌نویسی می‌تواند برای شما مفید باشد. معمولا برای تولید گزارشات و ایجاد بارکد از jasperReport استفاده می‌کنیم. برای خواندن بار کد و سایر کارهای مربوط به پردازش تصویر نیز می‌توانیم از یک dependency با نام formscanner می‌توان استفاده کرد. برای استفاده از این dependency باید کد زیر را به pom.xml خود اضافه کنید.



{% highlight xml%}
<dependency>
   <groupId>com.albertoborsetta</groupId>
   <artifactId>formscanner</artifactId>
   <version>1.1.4</version>
   <type>jar</type>
   <exclusions>
      <exclusion>
        <groupId>com.google.zxing</groupId>
        <artifactId>core</artifactId>
      </exclusion>
      <exclusion>
        <groupId>com.google.zxing</groupId>
        <artifactId>javase</artifactId>
      </exclusion>
   </exclusions>
</dependency>
<dependency>
   <groupId>com.google.zxing</groupId>
   <artifactId>core</artifactId>
   <version>3.3.0</version>
</dependency>
<dependency>
   <groupId>com.google.zxing</groupId>
   <artifactId>javase</artifactId>
   <version>3.3.0</version>
</dependency>
{% endhighlight %}

به دلیل بروز خطا در کامپایل،zxing dependency  را از formScanner dependency جدا کرده‌ایم.

formScanner براساس یک تمپلیت xml که از روی برگه اسکن شده ساخته می‌شود کار می‌کند. برای ساخت این تمپلیت از یک نرم‌افزار دسکتاپی استفاده می‌گردد. این نرم‌افزار یک برگه اسکن شده به عنوان ورودی از ما می‌گیرد و با مشخص کردن محدوده‌ها و علامتگذاری نقاط مختلف، تمپلیت xml را به عنوان خروجی به ما می‌دهد.شکل زیر نمایی از این نرم‌افزار را نمایش می‌دهد.
{:refdef: class="center"}
![نرم‌افزار formScanner]( {{ site.baseurl }}/images/formScanner.png "نرم‌افزار formScanner")
{: refdef}

برای ساخت یک تملیت جدید کلید Ctrl + C را می‌زنیم و فایل اسکن شده خود را انتخاب می‌کنیم. این نرم‌افزار از چهار نوع فیلد بارکد (میله‌ای و Qr)، سوالات سطری، سوالات ستونی و سوالات ماتریسی پشتیبانی می‌کند.  
پس از مشخص کردن نوع فیلد و تعداد آن، بایستی محدوده‌‌ی هر یک از فیلدها را روی فایل اسکن شده مشخص کنیم. شکل زیر نمایی از یک پاسخنامه به همراه گزینه‌ها و بارکد علامتگذاری شده (به رنگ قرمز) را نشان می‌دهد.
{:refdef: class="center"}
![یک نمونه پاسخ‌نامه اسکن شده]( {{ site.baseurl }}/images/workbook.jpg "یک نمونه پاسخ‌نامه اسکن شده")
{: refdef}
 برای خواندن فیلدها درمحیط برنامه‌نویسی نیز باید به این صورت عمل کنیم که ابتدا چهار علامت چهارگوشه برگه اسکن شده را یافته و سپس با توجه به گروه‌های هر فیلد شروع به خواندن مقادیر مورد نظر خود کنیم. برای مثال قطعه کد زیر برای خواندن بارکد به کار می‌رود.

{% highlight java %}
File template = new File("templateCreatedFromScannedFile.xtmpl");
BufferedImage image = ImageIO.read(imageFile);
FormTemplate filledForm = new FormTemplate("Main Template", new FormTemplate(template));
Collection<FormArea> FormAreas = filledForm.getParentTemplate().getGroup("group1").getAreas().values();
for (FormArea barcodeArea : FormAreas)
  for (FormArea barcodeResultArea : new BarcodeDetector(filledForm, barcodeArea, image).call().values())
      barcode = barcodeResultArea.getText();
{% endhighlight %}
در قطعه کد بالا در سطراول همان تمپلیت که خروجی اپلیکیشن دسکتاپی بود را load کرده‌ایم و سطر سوم یک تمپلیت با این فایل xml می‌سازد. سطر دوم فایل اسکن شده که قرار است محتوای آن را بخوانیم بارگذاری می‌کند. سطر چهارم به بعد نیز متن بارکد مورد نظر (که در group1 قرار دارد) را می‌خواند.

برای خواندن گزینه‌های هر سوال نیز از قطعه کد زیر بهره می‌بریم.
{% highlight java %}
File template = new File("templateCreatedFromScannedFile.xtmpl");
BufferedImage image = ImageIO.read(imageFile);
filledForm.findCorners(image, filledForm.getParentTemplate().getThreshold(), filledForm.getParentTemplate().getDensity(), filledForm.getParentTemplate().getCornerType(), filledForm.getParentTemplate().getCrop());
filledForm.findPoints(image, filledForm.getParentTemplate().getThreshold(), filledForm.getParentTemplate().getDensity(), filledForm.getParentTemplate().getSize());
filledForm.findAreas(image);
filledForm.getGroups().forEach((groupName, formGroup) -> {
  formGroup.getFields().forEach((questionName, formQuestion) -> {
    //Access to every Questions
    formQuestion.getPoints().forEach((pointName, formPoint) -> {
      // Access to every Points
    });
  });
});
{% endhighlight %}


**نکات:**

برای عملکرد بهتر formScanner به نکات زیر توجه کنید

- بهتر است برای ایجاد تمپلیت از فایل اسکن شده استفاده شود. استفاده ازه فایل تصویری که با نرم‌افزارهایی ویرایش تصویر نظیر فتوشاپ ایجاد شده است، ممکن است فرآیند پردازش تصویر را برای این dependency با خطا روبرو کند و دقت تشخیص آن را پایین بیاورد.

- گاهی اوقات پیش می‌آید که حاشیه‌های تصویر اسکن شده سیاه می‌شود. در این گونه موارد این dependency این حاشیه‌های سیاه را به عنوان یک یا دوتا از چهارگوشه تصویر در نظر گرفته و قادر به تشخیص درست نواحی مشخص شده نمی‌شود. برای پرهیز از این مشکل می‌توان از هر چهار طرف برای تصویر اسکن شده حاشیه‌ای بر حسب پیکسل (crop) مشخص کرد تا حاشیه‌های تصویر اسکن شده در نظر گرفته نشود (crop شود).
