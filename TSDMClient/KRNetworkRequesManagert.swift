//
//  NetworkRequest.swift
//  APP网络请求类
//  TSDMClient
//
//  Created by 王晶 on 15/10/20.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation

/**
KR网络请求错误状态

- InterfaceError: 接口错误
- RequestError:   网络请求失败
- NotDara:        请求成功，但无数据
*/
enum KRNetWorkRequesError: ErrorType {
    case InterfaceError, RequestError, NotDara
}

/// KR网络请求
class KRNetworkRequest {
    lazy private var shareSession = NSURLSession.sharedSession()
    
    /**
    请求数据
    
    - parameter urlString: URL字符串
    - parameter success:   请求成功调用
    - parameter failure:   请求失败调用
    */
    func requestData(urlString: String, success: (data: NSData) -> (), failure: (error: KRNetWorkRequesError)->()) {
        guard let url = NSURL(string: urlString) else {
            failure(error: .InterfaceError)
            return
        }
        
        let request = NSURLRequest(URL: url)
        let task = shareSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                failure(error: .RequestError)// 网络请求失败
                return
            }
            if data == nil {
                failure(error: .NotDara)// 无数据
                return
            }
            
            // 编码控制
            var textEncodeName = ""
            if response != nil && response!.textEncodingName != nil {
                textEncodeName = response!.textEncodingName!
            }
            
            let result = self.dataEncodeManager(data!, textEncodeName: textEncodeName)
            success(data: result)
        }
        task.resume()
    }
    
}

private extension KRNetworkRequest {
    /**
    Data编码控制
    
    - parameter data:           源数据
    - parameter textEncodeName: 文本编码名称
    
    - returns: 处理结果
    */
    func dataEncodeManager(data: NSData, textEncodeName: String) -> NSData {
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(textEncodeName))
        if enc != NSUTF8StringEncoding {
            if let content = String(data: data, encoding: enc) {
                print(content)
                if let resultData = content.dataUsingEncoding(NSUTF8StringEncoding) {
                    return resultData
                }
            }
        }
        return data
    }
}



