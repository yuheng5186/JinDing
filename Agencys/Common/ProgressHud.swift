//
//  ProgressHud.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/16.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit
import MBProgressHUD

enum PostionType {
    case top
    case center
    case bottom
}
let UIRate = (UIScreen.main.bounds.size.width/375)

class ProgressHud: NSObject {

    class func showText(_ text: String, _ view: UIView?, _ interval: TimeInterval = 2, _ type: PostionType = .center) {
        DispatchQueue.main.async {
            var view = view
            if (view == nil) {
                view = UIApplication.shared.keyWindow
            }
            let hud = MBProgressHUD.showAdded(to: view!, animated: true)
            hud.animationType = .zoomOut
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = UIColor.init(white: 0.0, alpha: 0.6)
            hud.contentColor = UIColor.white
            hud.mode = .text
            hud.show(animated: true)
            switch type {
            case .top:
                hud.offset.y = -(view?.height)!*0.3
                break
            case .bottom:
                hud.offset.y = (view?.height)!*0.3
                break
            default:
                break
            }
            hud.removeFromSuperViewOnHide = false
            hud.margin = 12*UIRate
            hud.label.text = text
            hud.backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: interval)
        }
    }
    
    
    //成功失败
    class func showState(text: String, icon: String, view: UIView?)  {
        DispatchQueue.main.async {
            var view = view
            
            if (view == nil) {
                view = UIApplication.shared.keyWindow
            }
            
            let hud = MBProgressHUD.showAdded(to: view!, animated: true)
            hud.mode = .customView
            let image = UIImage(named: "MBProgressHUD.bundle/\(icon)")?.withRenderingMode(.alwaysTemplate)
            hud.customView = UIImageView(image: image)
            hud.isSquare = true
            hud.label.text = text
            hud.label.numberOfLines = 0
            hud.backgroundView.style = .solidColor
            hud.backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
            hud.hide(animated: true, afterDelay: 2.0)
        }
    }
    
    
    //显示信息
    class func showMessageView(message: String, view: UIView?) {
        DispatchQueue.main.async {
            var view = view
            if (view == nil) {
                view = UIApplication.shared.keyWindow
            }
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
            
            let hud =  MBProgressHUD.showAdded(to: view!, animated: true)
            hud.isUserInteractionEnabled = true;
            hud.contentColor = UIColor.init(r: 0.82, g: 0.82, b: 0.82)
            //        hud.backgroundView.style = .solidColor
            //style -blur 不透明 －solidColor 透明
            hud.bezelView.style = .solidColor
            hud.bezelView.color = UIColor("0000000",0.7);
            hud.margin = 12*UIRate
            hud.backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
            hud.label.text = message
            hud.label.textColor = UIColor.white
        }
    }
    
    class func hidHud(for view: UIView?) {
        var view = view
        if (view == nil) {
            view = UIApplication.shared.keyWindow
        }
        
        MBProgressHUD.hide(for: view!, animated: true)
    }
    
    
    
    class func showSuccess(text: String, toView: UIView?) {
        showState(text: text, icon: "success.png", view: toView)
    }
    
    class func showError(text: String, toView: UIView?) {
        showState(text: text, icon: "error.png", view: toView)
    }
    
    
    
    class func showMessage(_ message: String = "") {
        showMessageView(message: message, view: nil)
    }
    
    class func showSuccess(_ success: String) {
        showSuccess(text: success, toView: nil)
    }
    
    class func showError(_ error: String) {
        showError(text: error, toView: nil)
    }
    
    //    MARK:- //只显示文字 showText
    
    class func showText(_ text: String, _ interval: TimeInterval = 2, _ type: PostionType = .center) {
        showText(text, nil, interval, type)
    }
    
    class func showText(_ text: String, _ interval: TimeInterval = 2) {
        showText(text, nil, interval, .center)
    }
    
    class func showText(text: String, view: UIView?) {
        showText(text, view)
    }
    
    class func showText(_ text: String) {
        showText(text: text, view: nil)
    }
    
    //    MARK:- //隐藏 hidHud
    class func hidHud(){
        DispatchQueue.main.async {
            hidHud(for: nil)
        }
    }
}
