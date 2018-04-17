//
//  UserModel.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/16.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

import HandyJSON


class UserModel:NSObject, HandyJSON, NSCoding {
    var name: String? //名字
    var mobile: String? //手机
    var company: String? //公司
    var receiveCarPermission: String? //1：有收车权限， 2.无收车权限
    //    var cancelTransportOrderPermission: String? //0：无取消权限， 1.有取消权限
    var userId: String? //用户ID
    var token: String? //token
    
    var group: String?
    var isGroup: String?   //1：经销商 2:经销商集团
    var bankSupport: String? // 1：支持银行审核 0:不支持
    
    
    
    
    //    // 1.0用字典初始化模型
    //    init(dict: [String: Any]) {
    //        super.init()
    //        setValuesForKeys(dict)
    //    }
    //    //如果字典中又缺少值的情况不会报错
    //    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    
    //MARK: NACODING协议
    //2.0 将对象写入到文件中
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(company, forKey: "company")
        aCoder.encode(receiveCarPermission, forKey: "receiveCarPermission")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(group, forKey: "group")
        aCoder.encode(isGroup, forKey: "isGroup")
        aCoder.encode(bankSupport, forKey: "bankSupport")
        
        //        aCoder.encode(cancelTransportOrderPermission, forKey: "cancelTransportOrderPermission")
        
    }
    
    //3.0 从文件中读取对象
    required init?(coder aDecoder: NSCoder) {
        super.init()
        token = aDecoder.decodeObject(forKey: "token") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        company = aDecoder.decodeObject(forKey: "company") as? String
        receiveCarPermission = aDecoder.decodeObject(forKey: "receiveCarPermission") as? String
        group = aDecoder.decodeObject(forKey: "group") as? String
        isGroup = aDecoder.decodeObject(forKey: "isGroup") as? String
        bankSupport = aDecoder.decodeObject(forKey: "bankSupport") as? String
        
        //        guard let cancelStr = aDecoder.decodeObject(forKey: "cancelTransportOrderPermission") as? String else {
        //            cancelTransportOrderPermission = "0"
        //            return
        //        }
        //        cancelTransportOrderPermission = cancelStr
    }
    
    required override init(){
        super.init()
    }
    
    
    
    
    class func saveUserInfo(userModel: UserModel) {
        NSKeyedArchiver.archiveRootObject(userModel, toFile: UserModel.DomainsPath())
    }
    
    
    class func loadUserInfo() -> UserModel? {
        let userModel =  NSKeyedUnarchiver.unarchiveObject(withFile: UserModel.DomainsPath()) as? UserModel
        return userModel
        
        
        
    }
    
    class func deleteUserInfo() {
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: UserModel.DomainsPath())
            printLog("user info delete success")
        }catch{
            printLog("user info delete failure")
        }
        
    }
    
    class func DomainsPath() -> String{
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent("DealerUserInfo.plist")
        return filePath
    }
    
}

