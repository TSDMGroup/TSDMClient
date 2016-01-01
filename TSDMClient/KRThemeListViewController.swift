//
//  KRThemeListViewController.swift
//  TSDMClient
//
//  Created by 王晶 on 16/1/1.
//  Copyright © 2016年 tsdmGroup. All rights reserved.
//

import UIKit

class KRThemeListViewController: UIViewController {
    
    var themeKey: [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = themeKey["title"] as? String
        
        KRThemeListData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class KRThemeListData: KRNetworkDataBasis {
    
    // 网络请求
    func requestDataOfNetwork(forumID: Int, completion: ()->(), failure: ()->()) {
        networkManager.themeList((forumID, 1), success: { () -> () in
            
            }) { (errorID) -> () in
                
        }
    }
    
    // 解析数据
}
