//
//  LDCycleViewScrollViewCell.swift
//  Dealers
//
//  Created by 祁志远 on 2017/7/31.
//  Copyright © 2017年 Anji-Allways. All rights reserved.
//

import UIKit

class LDCycleViewScrollViewCell: UICollectionViewCell {
    var ca3DView: CA3DView!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    var isGesture: Bool? {
        didSet {
            if isGesture! {
                ca3DView.isHidden = false
                imageView.isHidden = true
            } else {
                ca3DView.isHidden = true
                imageView.isHidden = false
            }
        }
    }

    var cycleModel: CycleViewModel? {
        didSet{
            titleLabel.text = cycleModel?.title

            
            /*
             let data = pictures[indexPath.item]
             
             if data is UIImage {
             cell.setImage((data as? UIImage)!, nil)
             } else if data is String {
             cell.setImage(nil, data as? String)
             } else {
             cell.setImage(nil, nil)
             }

             */
            let data = cycleModel?.picture_url
            
            
            if self.isGesture! {
                if data is UIImage {
                    guard let image = data as? UIImage else {
                        print("出错")
                        return
                    }
                    ca3DView.imageView.image = image
                } else {
                    guard let urlStr = data as? String else {
                        print("出错")
                        return
                    }
//                    ca3DView.imageView.kf.setImage(with:  URL(string: urlStr), placeholder: UIImage(named: "placeholderImge"))

                }
//                ca3DView.imageView.kf.setImage(with: iconURL)
            } else {
                
                if data is UIImage {
                    guard let image = data as? UIImage else {
                        print("出错")
                        return
                    }
                    imageView.image = image
                } else {
                    guard let urlStr = data as? String else {
                        print("出错")
                        return
                    }

//                    imageView.kf.setImage(with: URL(string: urlStr), placeholder: UIImage(named: "placeholderImge"))
                }
//                imageView.kf.setImage(with: iconURL)
            }
        }
    }

    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//    }
    
    fileprivate func setupUI(){
        ca3DView = CA3DView()
        ca3DView.frame = CGRect(x: margin, y: margin, width: self.contentView.bounds.size.width - margin * 2, height: self.contentView.bounds.size.height - margin * 2)
        
        
        imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        self.contentView.addSubview(ca3DView)
//        ca3DView.imageView.kf.indicatorType = .activity
        self.contentView.addSubview(imageView)
//        imageView.kf.indicatorType = .activity

        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: margin, y: self.contentView.bounds.size.height - 40, width: self.contentView.bounds.size.width - margin * 2, height: 40)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        self.contentView.addSubview(titleLabel)
        

        
    }
    
    
    
    
    
}
