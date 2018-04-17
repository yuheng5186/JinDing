//
//  UITextField+setLeftImageView.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setFieldLeftView(_ imageName: String) {
        let leftBtn = UIButton()
        leftBtn.frame = CGRect(x: 0, y: 0, width: 36, height: 40.5)
        leftBtn.isUserInteractionEnabled = false
        leftBtn.setImage(UIImage(named: imageName), for: .normal)
        self.leftView = leftBtn
        self.leftViewMode = .always
    }
    
    
}
