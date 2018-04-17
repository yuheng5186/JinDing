//
//  BaseRequest.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/16.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import HandyJSON

enum MethodType {
    case get
    case post
}

//请求结果
enum RequestResult{
    case ok(message: String) // code == 000000 请求成功
    case failed(message: String)  //code > 000000 请求失败
    case error(error: Error) //请求出错
    
}


//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}

private let shareInstance = LDBaseReauest()
private var timeoutInterval: TimeInterval = 60  //请求超时时间

class LDBaseReauest {
    
    class var sharedInstance : LDBaseReauest {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInterval  // 请求超时时间
        //证书认证
        Alamofire.SessionManager(configuration: config).delegate.sessionDidReceiveChallenge = CertificateTrust.alamofireCertificateTrust
        
        return shareInstance
    }
}


extension LDBaseReauest {
    
    //MARK: -- 请求
    
    /// 请求基类
    ///
    /// - Parameters:
    ///   - type: 请求类型 默认post
    ///   - urlStrig: urlStr
    ///   - params: 请求参数
    ///   - decodeClass: 请求modelClass
    ///   - checkUserEmpty: 是否校验用户可以为空 默认需要校验
    ///   - success: 回调
    func requestData(_ type1 : MethodType = .post, urlStrig: String, params: [String: Any]? = nil, decodeClass: HandyJSON? = nil, checkUserEmpty: Bool = true, success: @escaping (_ response: [String : Any]?, _ classModle: HandyJSON?, _ resultCode:RequestResult?) -> ()) {
        
        let userModel = UserModel.loadUserInfo()
        let token = userModel?.token ?? ""
        let userId = userModel?.userId ?? ""
        let time =  String(Int(Date().timeIntervalSince1970))
        
        if checkUserEmpty {
            if userId.isEmpty || token.isEmpty {
//                LoginConfig.logOut()
            }
            
        }
        
        let sign = self.getSign(reqDataDict: params, timeStr: time, tokenStr: token)
        
        
        let param: [String: Any] = [
            "token" : token,
            "userId" : userId,
            "sign" : sign,
            "time" : time,
            "reqData" : params ?? ""
        ]
        
        //默认.post 553572bc-67cf-4869-8ccf-eeaeda87ab2c  62328b72-dd6b-491c-859c-1b5f525944df
        let method = type1 == .get ? HTTPMethod.get : HTTPMethod.post
//        let kServerBaseUrl = AJDebugManager.shareHelper.getAPI(kAJServerBaseUrlKey) ?? kServerBaseUrl_PR
        let kServerBaseUrl = ""

        let urlStr = "\(kServerBaseUrl)\(urlStrig)"
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        Alamofire.request(urlStr, method: method, parameters: param, encoding: JSONEncoding.default, headers:["Content-Type" : "application/json"]).responseJSON { (response) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch response.result {
            case .success:
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: Any]类型 如果是那么将其传给其定义方法中的success
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value)
                    let repCode = json["repCode"].intValue
                    let repMsg = json["repMsg"].stringValue
                    guard repCode == 0000 else {
                        printLog("请求出错: \(repMsg)")
                        if repCode == 4002 {
//                            LoginConfig.logOut()
                            return
                        } else {
                            success(value, nil, .failed(message: repMsg))
                            return
                        }
                    }
                    let jsonString = String(describing: json["repData"])
                    printLog(jsonString)
                    if decodeClass != nil {
                        //数据转model
                        if let classModle = type(of: decodeClass!).deserialize(from: jsonString) {
                            success(value,classModle,.ok(message: repMsg))
                            
                        }else {//转换失败
                            success(value, nil,.ok(message: "成功"))
                        }
                        
                    }else {
                        success(value, nil,.ok(message: "成功"))
                    }
                    
                    
                } else {
                    success(nil, nil, .failed(message: "数据出错"))
                }
                
                
                
            case .failure(let error):
                success(nil, nil, .error(error: error))
            }
        }
        
    }
    
    //MARK: - 照片上传
    func upLoadImage(image: UIImage?, success: @escaping (_ fileName: String) -> (), failture: @escaping (_ errorMessage: String) -> () ){
        
        if image == nil {
            failture("上传图片资源为空")
            return
        }
        let imageString = image?.toBase64String()
        let token = UserModel.loadUserInfo()?.token ?? ""
        let time =  String(Date().timeIntervalSince1970)
        let params = ["imgStr": imageString ?? ""]
        
        let param: [String: Any] = [
            "token" : token,
            "sign" : self.getSign(reqDataDict: params, timeStr: time, tokenStr: token),
            "time" : time,
            "reqData" : params
        ]
        
        //默认.post
        let method = HTTPMethod.post
//        let kUploadSeverURL = AJDebugManager.shareHelper.getAPI(kAJUploadPhotoSeverUrlKey) ?? AJConstUploadPhotoSeverUrl_PR
        let kUploadSeverURL = ""

        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(kUploadSeverURL, method: method, parameters: param, encoding: JSONEncoding.default, headers:["Content-Type" : "application/json"]).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: Any]类型 如果是那么将其传给其定义方法中的success
                if let value = response.result.value as? [String: Any] {
                    let json = JSON(value)
                    let repCode = json["repCode"].intValue
                    let repMsg = json["repMsg"].stringValue
                    guard repCode == 0000 else {
                        print("请求出错: \(repMsg)")
                        failture(repMsg)
                        return
                    }
                    let jsonString = String(describing: json["repData"])
                    success(jsonString)
                }
            case .failure(_):
                failture("照片上传失败")
            }
        }
    }
    
    
    //MARK:- 有关数据处理
    private func getSign(reqDataDict: [String: Any]? = nil, timeStr:String, tokenStr: String) -> String {
        
        var reqDataStr:String = ""
        if let paramsDict = reqDataDict {
            reqDataStr = self.creatJsonString(dict: paramsDict)
        }
        let valueStr = "reqData=" + reqDataStr + "&time=" + timeStr + "&token=" + tokenStr
        return valueStr.md5()
    }
    
    //formate有序json字符串
    private func creatJsonString(dict: [String: Any]) ->String {
        if (!JSONSerialization.isValidJSONObject(dict)) {
            print("无法解析出JSONString")
            return ""
        }
        var namedPaird = [String]()
        let sortedKeysAndValues = dict.sorted{$0.0 < $1.0}
        for (key, value) in sortedKeysAndValues {
            if value is [String: Any] {
                namedPaird.append("\"\(key)\":\(self.creatJsonString(dict: value as! [String : Any]))")
            } else if value is [Any] {
                namedPaird.append("\"\(key)\":\(value)")
            } else {
                namedPaird.append("\"\(key)\":\"\(value)\"")
            }
        }
        let returnString = namedPaird.joined(separator: ",")
        return "{\(returnString)}"
    }
    
}
