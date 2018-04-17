//
//  CA3DView.swift
//  Dealers
//
//  Created by 祁志远 on 2017/7/31.
//  Copyright © 2017年 Anji-Allways. All rights reserved.
//

import UIKit

func myMIN(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
    return x < y ? x : y
}
func myMAX(_ x: CGFloat, _ y: CGFloat) -> CGFloat {
    return x > y ? x : y
}
//是否拖动
let IS_GESTURE_PAN = "isGesturePan"

let kSpreadDuration = 0.4                                               // 动画展开收拢的时长



let PanInCardNotify = Notification.Name("CA3DViewPanInCardNotify")


class CA3DView: UIView  {


    var imageView: UIImageView!

    fileprivate var emptyView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupUI()
    }
    
    
    fileprivate func setupUI(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.3
        
        imageView =  UIImageView()
        imageView.frame = self.bounds
        imageView.image = UIImage(named: "8_150709170804_8")
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        emptyView = UIView()
        emptyView.isUserInteractionEnabled = true
        emptyView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width - 80, height: self.bounds.size.height - 80)
        emptyView.center = imageView.center
        emptyView.backgroundColor = UIColor.clear
        
        self.addSubview(emptyView)


        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panInCard(_:)))
        panGes.delegate = self
        self.addGestureRecognizer(panGes)
        
    }
    
    
    @objc fileprivate func panInCard(_ panGes: UIGestureRecognizer) {
        let touchPoint = panGes.location(in: imageView)
        if panGes.state == .changed {
            UserDefaults.standard.set(true, forKey: IS_GESTURE_PAN)
            NotificationCenter.default.post(name: PanInCardNotify, object: nil, userInfo: ["changed" : true])

            let xFactor = myMIN(1, myMAX(-1, (touchPoint.x - (self.bounds.size.width / 2)) / (self.bounds.size.width / 2) ))
            let yFactor = myMIN(1, myMAX(-1, (touchPoint.y - (self.bounds.size.height / 2)) / (self.bounds.size.height / 2) ))
            imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            imageView.layer.transform = self.imagePanTransform(m34: 1.0 / CGFloat(-500), xf: xFactor, yf: yFactor)
            
//            let zFactor = 180.0 * atan(yFactor / xFactor) / CGFloat(Double.pi) + 90
//            printLog(zFactor)
            
        } else if panGes.state == .ended {
            NotificationCenter.default.post(name: PanInCardNotify, object: nil, userInfo: ["changed" : false])
            UIView.animate(withDuration: kSpreadDuration, animations: {
                self.imageView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    fileprivate func imagePanTransform(m34: CGFloat, xf: CGFloat, yf: CGFloat) -> CATransform3D {
        var t = CATransform3DIdentity
        t.m34 = m34
        t = CATransform3DRotate(t, CGFloat(Double.pi) / 15 * yf , -1, 0, 0)
        
        //t: CATransform3D, t: CATransform3D, x: CGFloat, y: CGFloat, z: CGFloat 后面3个数字分别代表不同的轴来翻转
        // xf / 360.0 * 2.0 * CGFloat(Double.pi)  
        t = CATransform3DRotate(t, CGFloat(Double.pi) / 15 * xf , 0, 1, 0)
        return t
        
    }
    

}

extension CA3DView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == emptyView {
            //#UIGestureRecognizerDelegate
            //我在这里设置响应事件的优先级，因为UITap响应事件的优先级会高，则他的subview的事件会被阻止
            return false
        }
        return true
    }
    
    
}

