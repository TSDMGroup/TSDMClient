//
//  KRHomeViewController.swift
//  主页控制器
//  TSDMClient
//
//  Created by 王晶 on 15/10/12.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import UIKit

class KRHomeViewController: UIViewController, ICSDrawerControllerChild {

    weak var drawer: ICSDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 导航栏分区选择
        let button = UIButton(type: .System)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        button.setTitle("TSDM", forState: .Normal)
        button.addTarget(self, action: "testAction:", forControlEvents: .TouchUpInside)
        navigationItem.titleView = button
        
        // 
        let forumListView = KRForumListView(frame: view.frame)
        forumListView.delegate = self
        view = forumListView
        
        view.backgroundColor = UIColor.orangeColor()
        
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        button.backgroundColor = UIColor.grayColor()
//        button.addTarget(self, action: "testAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addMenuGestureRecognizer()// 添加功能列表手势功能
    }
    let areaListView = KRAreaListView()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension KRHomeViewController {
    func testAction(sender: UIButton) {
        // add AreaListView
        
        areaListView.delegate = self
        navigationController?.view.insertSubview(areaListView, aboveSubview: navigationController!.navigationBar)
        removeMenuGestureRecognizer()
        areaListView.showView()
    }
}

//MARK: KRAreaListViewDelegate
extension KRHomeViewController: KRAreaListViewDelegate {
    func areaListViewWillCancel(areaListView: KRAreaListView, isCancel: Bool) {
        if !isCancel {
            let checkItem = areaListView.checkItem!
            (navigationItem.titleView  as! UIButton).setTitle(checkItem["title"] as? String, forState: .Normal)
            (view as! KRForumListView).groupItemData = checkItem
        }
        addMenuGestureRecognizer()
    }
}

extension KRHomeViewController: KRForumListViewDelegate {
    func enterForumThemes(para: [String : AnyObject]) {
        let themesVC = KRThemeListViewController()
        themesVC.themeKey = para
        themesVC.view.backgroundColor = view.backgroundColor
        navigationController?.pushViewController(themesVC, animated: true)
    }
}
