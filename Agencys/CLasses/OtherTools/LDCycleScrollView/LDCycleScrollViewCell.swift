//
//  LDCycleScrollViewCell.swift
//  ExpressSystem
//
//  Created by 祁志远 on 2017/6/29.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit

class LDCycleScrollViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iimageView: CA3DView!
    
    
    var cycleModel: CycleViewModel? {
        didSet{
            titleLabel.text = cycleModel?.title
            let iconURL = URL(string: cycleModel?.pic_url ?? "")!
//            imageView.kf.setImage(with: iconURL)
//            iimageView.imageView.kf.setImage(with: iconURL)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        iimageView.imageView.kf.indicatorType = .activity

    }
    
    

}
