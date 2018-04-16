//
//  Date+Extension.swift
//  Dealers
//
//  Created by Black on 2017/8/23.
//  Copyright © 2017年 Anji-Allways. All rights reserved.
//

import Foundation

extension Date {
    
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
    
    //字符串 年-月-日 转  date
    static func strConverDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let datef = dateFormatter.date(from: dateStr) {
            return datef
        }
        return Date()
    }
    
    //字符串 时-分-秒 转  date
    static func strConverHourStr(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        guard let datef = dateFormatter.date(from: dateStr) else {
            return ""
        }
        let hourMinutesStr = Date.strConverDateforHourMinutes(date: datef)
        return hourMinutesStr
    }
    
    // date 转  时:分
    static func strConverDateforHourMinutes(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        let timerString: String = formatter.string(from: date)
        return timerString
    }
    
    
    
    
    //字符串 年-月-日 转  xx月xx日
    static func strMonthAndDayConverDate(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "MM月dd日"
        let datef = self.strConverDate(dateStr: dateStr)
        let timerString: String = dateFormatter.string(from: datef)
        return timerString
    }
    
    //date 转 xx年xx月xx日
    static func getdateFormatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        //     formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let timerString: String = formatter.string(from: date)
        return timerString
    }
    
    //时间戳转date
    static func stampTimeForDate(timeStamp: Int) -> Date {
        let timInterVal: TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timInterVal)
        return date
    }
    //时间戳转xx月xx日xx时
    static func stampTimeForTimeStr(timeStamp: Int) -> String {
        let timInterVal: TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timInterVal)
        let dateStr = self.getdateFormatTime(date: date)
        return dateStr
    }
    
    
    static func getCurrentLogTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss:SSS"
        let timerString: String = formatter.string(from: Date())
        return timerString
    }
    
    func dateString() -> String {
        let formater = DateFormatter.creatFormatter(formatterStr: "yyyy-MM-dd HH:mm:ss")
        return formater.string(from: self)
    }
    
    func yearMonthDayString() -> String {
        let formater = DateFormatter.creatFormatter(formatterStr: "yyyy-MM-dd")
        return formater.string(from: self)
    }
    
   
}

// MARK:- DateFormatter extensiob
extension DateFormatter {
    
    class func creatFormatter(formatterStr: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = formatterStr
        return dateFormatter
    }
    
}
