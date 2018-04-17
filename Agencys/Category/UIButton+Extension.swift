//
//  UIButton+Extension.swift
//  Dealers
//
//  Created by 祁志远 on 2017/7/18.
//  Copyright © 2017年 Anji-Allways. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    /**
     添加小红点
     
     - parameter index: index
     */
    func showBadgeOnItemIndex(_ index : Int = 0 , infoNumber: Int){
        // 移除之前的小红点
        removeBadgeOnItemIndex(index: index)
        if infoNumber <= 0 {
            return
        }
        // 新建小红点
        let badgeView = UILabel()
        badgeView.tag = 199998 + index
        badgeView.textColor = UIColor.red
        badgeView.text = "\(infoNumber)"
        badgeView.backgroundColor = UIColor.white
        let tabFrame = self.frame
        badgeView.font = UIFont.systemFont(ofSize: 12)

        badgeView.textAlignment = .center
        // 确定小红点的位置
        let percentX = (Double(index) + 0.8) / 4
        let x = ceilf(Float(percentX) * Float(tabFrame.size.width))
        let y = 0
        
        badgeView.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 20, height: 20)
        self.addSubview(badgeView)
        badgeView.centerX = tabFrame.size.width - 5
        badgeView.centerY = 10
        badgeView.sizeToFit()
        if infoNumber < 10 {
            badgeView.width = badgeView.height + 4
            badgeView.height = badgeView.width
            
        } else if infoNumber < 100 {
            badgeView.height = badgeView.width + 4
            badgeView.width = badgeView.height
        }
        badgeView.layer.cornerRadius = badgeView.height * 0.5
        
        badgeView.layer.masksToBounds = true
        
        
    }
    
    func hideBadgeOnItemIndex(index : Int){
        // 移除小红点
        removeBadgeOnItemIndex(index: index)
    }
    func removeBadgeOnItemIndex(index : Int){
        // 按照tag值进行移除
        for itemView in self.subviews {
            if(itemView.tag == 199998 + index){
                itemView.removeFromSuperview()
            }
        }
    }
}
