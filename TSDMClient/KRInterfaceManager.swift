//
//  KRInterfaceManager.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/20.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation

/// 接口列表
class KRInterfaceList {
    private let basicPath = "www.tsdm.net"
    private let appID = "2"// AppID -> 1: Android, 2: iOS
}

extension KRInterfaceList {
    /// 版块列表接口
    var areaList: String {
        return synFullPath("/forum.php?")
    }
}

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