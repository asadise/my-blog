#!/bin/env ruby
# encoding: utf-8
require "date"

module Jekyll
  module Jdate
  	GDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	JDaysInMonth = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29]
    PERSIAN_MONTH_NAMES = [nil, "فروردین","اردیبهشت","خرداد","تیر","مرداد","شهریور","مهر","آبان","آذر","دی","بهمن","اسفند"]
	PERSIAN_WEEKDAY_NAMES = ["یک‌شنبه","دوشنبه","سه‌شنبه","چهارشنبه","پنج‌شنبه","جمعه","شنبه"]
	
    def jdate(date)
		jj=0
		g = Date::strptime(date, "%Y-%m-%d")
		gy = g.year - 1600
		gm = g.month - 1
		gd = g.mday - 1
		wday = g.wday
		g_day_no = 365*gy + (gy+3)/4 - (gy+99)/100 + (gy+399)/400
		gm.times { |i| g_day_no += GDaysInMonth[i] }
		g_day_no += 1 if gm > 1 && ((gy%4 == 0 && gy%100 != 0) || (gy%400 == 0))
		g_day_no += gd

		j_day_no = g_day_no-79
		j_np = j_day_no/12053
		j_day_no %= 12053
		jy = 979 + 33 * j_np + 4*(j_day_no/1461)
		j_day_no %= 1461

		if (j_day_no >= 366)
		   jy += (j_day_no - 1)/365
		   j_day_no = (j_day_no - 1) % 365
		end

		11.times do |i|
		  if j_day_no >= JDaysInMonth[i]
			j_day_no -= JDaysInMonth[i]
			jj = i + 1
		  else
			jj = i
			break
		  end
		end
		jm = jj + 1
		jd = j_day_no + 1
		# [jy, jm,jd].join("/")
		return [PERSIAN_WEEKDAY_NAMES[wday], to_persian_number(jd), PERSIAN_MONTH_NAMES[jm], to_persian_number(jy)].join(" ")
	 end
	 def to_persian_number(num)
		str = num.to_s
		return str.tr("1234567890","۱۲۳۴۵۶۷۸۹۰")
	 end
  end
end

Liquid::Template.register_filter(Jekyll::Jdate)