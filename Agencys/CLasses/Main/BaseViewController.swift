//
//  BaseViewController.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setNavgationBackBtnItem()
    }
    
    //设置状态栏颜色
    
    //设置左侧返回按钮（显示在navgationItem上）
    func setNavgationBackBtnItem(){
        let controllerCount = self.navigationController?.viewControllers.count ?? 0
        if controllerCount > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_img")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(navigationBack))
        }
    }
    
    
    @objc func navigationBack(){
        if let nav = self.navigationController {
            if nav.viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
            } else if self.presentedViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    deinit {
        print("\(self) deinit")
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
