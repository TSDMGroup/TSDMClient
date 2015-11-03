//
//  KRInterfaceManager.swift
//  APP接口管理
//  TSDMClient
//
//  Created by 王晶 on 15/10/20.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation

/// 接口列表
class KRInterfaceList {
    private let basicPath = "www.tsdm.net/"
    private let appID = "2"// AppID -> 1: Android, 2: iOS
}

//MARK: 外部接口
extension KRInterfaceList {
    /// 分区列表接口
    var areaList: String {
        return synFullPath("forum.php?")
    }
    /// 版块列表接口
    func getForumList(froupID: String) -> String {
        return synFullPath("forum.php?gid=\(froupID)")
    }
}

//MARK: 内部小工具
private extension KRInterfaceList {
    /**
    获取完整接口路径
    
    - parameter interfaceKey: 接口键
    
    - returns: 完整接口路径
    */
    func synFullPath(interfaceKey: String) -> String {
        return "http://" + basicPath + interfaceKey + "&mobile=yes&tsdmapp=\(appID)"
    }
}