//
//  AJAlterView.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

class AJAlterView: NSObject {
    ///3.确认弹出框
    
    class func showTwoAction(title:String?,
                             message:String?,
                             target: UIViewController? = UIViewController.currentViewController(),
                             confirmTitle: String = "确定",
                             cacelTitle: String = "取消",
                             confirmHandler: ( (UIAlertAction) -> Swift.Void)? = nil,
                             cancelHandler: ( (UIAlertAction) -> Swift.Void)? = nil)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cacelTitle, style: .cancel, handler: cancelHandler)
        cancelAction.setTextColor(TITLE_COLOR)
        alertVC.addAction(cancelAction)
        
        let entureAction = UIAlertAction(title: confirmTitle, style: .destructive, handler: confirmHandler)
        entureAction.setTextColor(NAV_BG_COLOR)
        alertVC.addAction(entureAction)
        
        target?.present(alertVC, animated: true, completion: nil)
        
    }
    
    class func showSigleAction(title:String?,
                               message:String?,
                               target: UIViewController? = UIViewController.currentViewController(),
                               confirmTitle: String = "确定",
                               confirmHandler: ( (UIAlertAction) -> Swift.Void)? = nil)
    {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let entureAction = UIAlertAction(title: confirmTitle, style: .destructive, handler: confirmHandler)
        alertVC.addAction(entureAction)
        
        target?.present(alertVC, animated: true, completion: nil)
        
    }
    
}

extension UIAlertAction {
    /// 设置文字颜色
    func setTextColor(_ color: UIColor) {
        let key = "_titleTextColor"
        guard isPropertyExisted(key) else {
            return
        }
        self.setValue(color, forKey: key)
    }
    
    /// 是否存在某个属性
    func isPropertyExisted(_ propertyName: String) -> Bool {
        for name in UIAlertAction.propertyNames {
            if name == propertyName {
                return true
            }
        }
        return false
    }
    
    /// 取属性列表
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            guard let pro: Ivar = ivars[i] else {
                continue
            }
            guard let name = String(utf8String: ivar_getName(pro)!) else {
                continue
            }
            result.append(name)
        }
        return result
    }
}

extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}

