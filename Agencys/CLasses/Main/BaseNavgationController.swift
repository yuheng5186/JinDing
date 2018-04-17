//
//  BaseNavgationController.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

class BaseNavgationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar.appearance()
        navBar.setBackgroundImage(UIImage.ld_image(color: NAV_BG_COLOR), for: .default)
        navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
