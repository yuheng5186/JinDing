//
//  CalenderCell.swift
//  DateCalendar
//
//  Created by 祁志远 on 2017/8/22.
//  Copyright © 2017年 祁志远. All rights reserved.
//

import UIKit

class CalenderCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var selectImageView: UIImageView!
    
    var isSelectedImage: Bool = false {
        didSet{
            selectImageView.isHidden = !isSelectedImage

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
