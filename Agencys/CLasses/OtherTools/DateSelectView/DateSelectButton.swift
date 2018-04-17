//
//  DateSelectButton.swift
//  Dealers
//
//  Created by 祁志远 on 2017/8/23.
//  Copyright © 2017年 Anji-Allways. All rights reserved.
//

import UIKit

class DateSelectButton: UIButton {
    
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       

        // 调整文字
        titleLabel?.x = 10
        titleLabel?.centerY = 20
        titleLabel?.width = self.width - 20
        
        // 调整图片
        imageView?.x = self.width - 20
        imageView?.y = 10
        imageView?.width = 20
        imageView?.height = 20

    }
    
    
}
