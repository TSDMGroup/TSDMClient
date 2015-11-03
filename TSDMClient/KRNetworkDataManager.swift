//
//  KRNetworkDataManager.swift
//  功能数据网络请求
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
        requestDataOfInterface(urlString, success: success, failure: failure)
    }
    /// 版块列表数据
    func forumList(groupID: String, success: (AnyObject) -> (), failure: () -> ()) {
        let urlString = interfaceList.getForumList(groupID)
        requestDataOfInterface(urlString, success: success, failure: failure)
    }
}

private extension KRRequestDataManager {
    /// 请求接口数据
    func requestDataOfInterface(api: String, success: (AnyObject) -> (), failure: () -> ()) {
        requestEngine.requestData(api, success: { (data) -> () in
            let json = self.synJSONFromData(data)
            if json != nil {
                success(json!)
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
            print((error as NSError).description)
            return nil
        }
    }
}


