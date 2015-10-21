//
//  KRNetworkDataManager.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/20.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation

/// 网络数据管理
class KRRequestDataManager {
    private let interfaceList = KRInterfaceList()
    private let requestEngine = KRNetworkRequest()
    
    /// 分区数据
    func areaList(success: (data: AnyObject)->(), failure: ()->()) {
        let urlString =  interfaceList.areaList
        requestEngine.requestData(urlString, success: { (data) -> () in
             let json = self.synJSONFromData(data)
            if json != nil {
                success(data: json!)
                return
            }
            failure()
            }) { (error) -> () in
                failure()
        }
    }
}

private extension KRRequestDataManager {
    /**
    解析NSData成JSON
    
    - parameter data: 获取的二进制数据
    
    - returns: 解析结果. 当结果为nil时, 代表解析失败
    */
    func synJSONFromData(data: NSData) -> AnyObject? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves)
            return json
        } catch {
            return nil
        }
    }
}


