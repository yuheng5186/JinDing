//
//  NoDataView.swift
//  ExpressSystem
//
//  Created by 祁志远 on 2017/6/28.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit

enum NodataImageType {
    /* 数据为空 */
    case emptyData
    /* 加载失败 */
    case loadError
}

class NoDataView: UIView {

    @IBOutlet weak var loadImageView: UIImageView!
    
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    @IBOutlet weak var noDataBtn: UIButton!
    
    var nodataImageType: NodataImageType? {
        didSet{
            switch nodataImageType!{
            case .emptyData:
                noDataLabel.text = "暂无数据,点击可重新加载"
                loadImageView.image = UIImage(named: "empty_Normal")
            case .loadError:
                noDataLabel.text = "加载失败，点击可重新加载"
                loadImageView.image = UIImage(named: "loadError")
            }
        }
    }
    

    var noDataBtnBlock: KButtonBlock!
    
    
    var otherActionBlock: KButtonBlock!

    
    
    

    @IBAction func noDataButtonClick(_ sender: UIButton) {
        if noDataBtnBlock != nil {
            noDataBtnBlock(sender)
        }
        
    }
    
    
    
    
}
