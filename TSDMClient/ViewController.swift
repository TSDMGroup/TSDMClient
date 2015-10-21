//
//  ViewController.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/12.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeCurrentNavigationController()// initialized the main Navigation
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private extension ViewController {
    /// initialized the main Navigation
    func initializeCurrentNavigationController() {
        let menuVC = KRMenuViewController()
        let homeVC = KRHomeViewController()
        let nv = KRHomeNavigationController(rootViewController: homeVC)
        let totalVC = ICSDrawerController(leftViewController: menuVC, centerViewController: nv
        )
        
        UIApplication.sharedApplication().windows[0].rootViewController = totalVC
    }
}

/// 主页导航
class KRHomeNavigationController: UINavigationController, ICSDrawerControllerChild {
    weak var drawer: ICSDrawerController?
}

extension UIViewController {
    /**
    移除功能表手势
    */
    func removeMenuGestureRecognizer () {
        if navigationController != nil && navigationController!.isKindOfClass(KRHomeNavigationController) {
            (navigationController as! KRHomeNavigationController).drawer?.removeDrawerGestureRecognizerFromView()
        }
    }
    /**
    添加功能列表手势
    */
    func addMenuGestureRecognizer() {
        if navigationController != nil && navigationController!.isKindOfClass(KRHomeNavigationController) {
            if navigationController!.isKindOfClass(KRHomeNavigationController) {
                (navigationController as! KRHomeNavigationController).drawer?.addDrawerGestureRecognizerToView()
            }
        }
    }
}
