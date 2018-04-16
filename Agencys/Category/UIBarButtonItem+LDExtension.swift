//
//  UIBarButtonItem-LDExtension.swift
//  ExpressSystem
//
//  Created by Kean on 2017/5/31.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //convenience 遍历构造器  action: Selector?
    convenience init(imageName: String, hightImageName : String = "", size :CGSize = CGSize.zero,action: Selector?,_ target: Any?) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        
        if hightImageName != "" {
            btn.setImage(UIImage(named: hightImageName), for: .highlighted)
        }
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        btn.addTarget(target, action: action!, for: .touchUpInside)
        
        self.init(customView : btn)
    }
}
