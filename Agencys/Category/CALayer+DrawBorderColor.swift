//
//  CALayer+DrawBorderColor.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import Foundation
import UIKit

//由于swift函数问题，所以添加次方法实现storyboard中，边框颜色设置生效

extension CALayer {
    var drawBorderColor:UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        }set {
            
            self.borderColor = newValue.cgColor
        }
        
    }
}
