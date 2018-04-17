//
//  DateHelper.swift
//  DateCalendar
//
//  Created by 祁志远 on 2017/8/22.
//  Copyright © 2017年 祁志远. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
    //参数： date：当天时间（如： 2017/08/22）
    //算出当前月份的第几号（今天22号）
    class func day(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.day!
    }
    
    //算出当前是第几月份（当前8月）
    class func month(date: Date) -> Int{
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.month!
    }
    //算出当前年份（当前2017年）
    class func year(date: Date) -> Int{
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.year!
    }
    
    //算出每个月的1号对应的是星期几（这个月1号对应星期二）
    class func firstWeekdayInThisMonth(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var comp = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        comp.day = 1
        let firstDayOfMonthDate = calendar.date(from: comp)
        let firstWeekDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay! - 1
    }
    
    //当前月份的天数
    class func totaldaysThisMonth(date: Date) -> Int {
        let totaldaysInMonth: Range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!
        return totaldaysInMonth.upperBound
    }
    
    //上月天数
    class func totaldaysInMonth(date: Date) -> Int {
        let daysInLastMonth: Range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!
        return daysInLastMonth.upperBound
    }
    
    //上个月
    class func lastMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        if  DateHelper.month(date: date) == 1{
            dateComponents.year = -1
        }
        dateComponents.month = -1

        let newDate = Calendar.current.date(byAdding: dateComponents, to: date, wrappingComponents: true)
        return newDate!
        
    }
    //上一年
    class func lastYear(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = -1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date, wrappingComponents: true)
        return newDate!
        
    }
    
    //下个月
    class func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        if  DateHelper.month(date: date) == 12{
            dateComponents.year = +1
        }
        dateComponents.month = +1

        let newDate = Calendar.current.date(byAdding: dateComponents, to: date, wrappingComponents: true)
        return newDate!
    }
    
    //下一年
    class func nextYear(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = +1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date, wrappingComponents: true)
        return newDate!
    }

    //日期转字符串
    class func dateConvertString(date: Date) -> String {
        let timeZone = TimeZone(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    //字符串转日期
    class func strConverDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datef = dateFormatter.date(from: dateStr)
        return datef!
    }
    
    //判断今天 明天 周日 周一。。。。
    class func weekComPareDate(dateStr: String) -> String {
        let date = DateHelper.strConverDate(dateStr: dateStr)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        let firstDayOfMonthDate = calendar.date(from: comp)
        let weekDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate!)
        
        switch weekDay! - 1 {
        case 0:
            return "星期日"
        case 1:
            return "星期一"
        case 2:
            return "星期二"
        case 3:
            return "星期三"
        case 4:
            return "星期四"
            
        case 5:
            return "星期五"
            
        case 6:
            return "星期六"
        default:
            return ""
        }

    }
    
    //判断是星期几
    class func strCompareDate(dateStr: String) -> String {
        let date = DateHelper.strConverDate(dateStr: dateStr)
        let dateDay = DateHelper.day(date: date)
        if dateDay == DateHelper.day(date: Date()) && DateHelper.month(date: date) == DateHelper.month(date: Date()) && DateHelper.year(date: date) == DateHelper.year(date: Date()) {
            return "[今天]"
        }else {
            return "[\(DateHelper.weekComPareDate(dateStr:dateStr))]"
        }
        
    }
    
    
    
    

    /*
     注： date: 表示传入的时间是当前时间. 比如今天是2017/08/22
     
     1.算出当前月份的第几号(今天22号)
     
     2. 算出当前是第几月份(当前8月份)
     
     3. 算出当前的年份(当前年份是2017年)
     
     4.算出每个月份的1号对应的星期几(这个月1号对应星期二)
     
     5.算出当前月份的天数
     
     6. 算出上个月
     
     7.算出下个月
     
     */
}
