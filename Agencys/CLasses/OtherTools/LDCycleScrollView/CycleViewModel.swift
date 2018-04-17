//
//  CycleViewModel.swift
//  ExpressSystem
//
//  Created by 祁志远 on 2017/6/29.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit
@objcMembers
class CycleViewModel: NSObject {
    // 标题
    var title : String = ""
    // 展示的图片地址
    var pic_url : String = ""
    //兼容URL和UIImage
    var picture_url: Any?
    //图片路径
    var path:  String = ""
    //图片ID
    var id:  String = ""

    
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
