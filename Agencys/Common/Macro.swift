//
//  Macro.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import Foundation
import UIKit


//导航标题颜色
let NAV_TITLE_BAR_COLOR = UIColor("FFFFFF")

//按钮选项卡颜色
let BTN_TITLE_COLOR = UIColor("666666")

//标题颜色
let TITLE_COLOR = UIColor("333333")

//正文颜色
let BODY_COLOR = UIColor("999999")

//提示语颜色
let TOAST_COLOR = UIColor("c0c0c0")

//说明文字
let DESC_COLOR = UIColor("cccccc")

//背景灰色
let BG_GEAY_COLOR = UIColor("d7d7d7")

//导航背景 橙色
let NAV_BG_COLOR = UIColor("FF7543")

//辅助橘黄色
let BTN_ORANGE = UIColor("FFA62B")

//辅助蓝色
let SUP_SELECT_COLOR = UIColor("2AB6EC")

//辅助灰色
let SUP_NORMAL_COLOR = UIColor("DAD8D8")

//分割线
let SUP_SEGMENT_COLOR = UIColor("ececec")



//背景颜色
let BG_COLOR = UIColor.white



/// iPhone 5
let isIPhone4S = SCREENH == 480 ? true : false
/// iPhone 5
let isIPhone5 = SCREENH == 568 ? true : false
/// iPhone 6
let isIPhone6 = SCREENH == 667 ? true : false
/// iPhone 6P
let isIPhone6P = SCREENH == 736 ? true : false
/// iPhone 8X
let isIPhone8X = SCREENH == 812 ? true : false


/// 屏幕的宽
let SCREENW = UIScreen.main.bounds.size.width
/// 屏幕的高
let SCREENH = UIScreen.main.bounds.size.height

let kStatusBarH : CGFloat = isIPhone8X ? 44 : 20
let kNavigationBarH : CGFloat = 44
let  kTabbarH : CGFloat = isIPhone8X ? 34 + 49 : 49
let kTitleViewH : CGFloat = 40
let margin: CGFloat = 10.0
let videoH = SCREENW * 12.0 / 16.0


typealias KButtonBlock = (_ button :UIButton) ->()


/// prin输出
///
/// - Parameters:
///   - message: 输出内容
///   - logError: 是否错误 default is false
///   - file: 输出文件位置
///   - method: 对应方法
///   - line: 所在行
/*
 #file    String    所在的文件名
 #line    Int    所在的行数
 #column    Int    所在的列数
 #function    String    所在的声明的名字
 */
func printLog<T>(_ message: T,
                 _ logError: Bool = false,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    if logError {
        print("\((file as NSString).lastPathComponent)\(method) [Line \(line)] [time \(Date.getCurrentLogTime())]: \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)\(method) [Line \(line)] [time \(Date.getCurrentLogTime())]: \(message)")
        #endif
    }
}



