//
//  DrawButton.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

class DrawButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 调整图片
        imageView?.x = 0
        imageView?.y = 0
        imageView?.height = imageView!.width
        // 调整文字
        titleLabel?.x = 0
        titleLabel?.y = imageView!.height + 5
        titleLabel?.width = self.width
        titleLabel?.height = self.height - self.titleLabel!.y
    }

}
