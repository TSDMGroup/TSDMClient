//
//  AreaListView.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/20.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import UIKit

//MARK: 屏幕常量
/// 屏幕大小
let KRScreenSize = UIScreen.mainScreen().bounds.size
/// 屏幕宽度
let KRScreenWidth = KRScreenSize.width
/// 屏幕高度
let KRScreenHeight = KRScreenSize.height

protocol KRAreaListViewDelegate: NSObjectProtocol {
    /// 地区列表视图取消
    func areaListViewWillCancel(areaListView: KRAreaListView, isCancel: Bool)
}

/// 版块分区列表选择视图
class KRAreaListView: UIView {
    weak var delegate: KRAreaListViewDelegate?
    /// 分区版块列表数据类型
    typealias KRAreaListData = Array<Dictionary<String, String>>
    
    var checkTitle: String = ""
    
    /// 分区数据
    private var areaData: KRAreaListData = []
    /// 显示列表
    private var displayList: UITableView!
    
    init() {
        super.init(frame: CGRect(origin: CGPointZero, size: KRScreenSize))
        
        backgroundColor = UIColor.clearColor()
        initDisplayList()
        updateToLatestDataOfAreaData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// Area List Identifier
private let CellIdentifier = "AreaListCellIdentifier"

private extension KRAreaListView {
    
    /// 初始化显示列表
    func initDisplayList() {
        var tvFrame = bounds
        tvFrame.origin.y = 27 + 36
        tvFrame.origin.x = (tvFrame.width-160)/2
        tvFrame.size.width = 160
        tvFrame.size.height = 0
        displayList = UITableView(frame: tvFrame, style: .Plain)
        displayList.dataSource = self
        displayList.delegate = self
        displayList.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        addSubview(displayList)
        displayList.tableFooterView = UIView(frame: CGRectZero)
    }
    /// 从网络请求数据
    func updateToLatestDataOfAreaData() {
        
        KRRequestDataManager().areaList({ (data) -> () in
            weak var tempSelf = self
            tempSelf?.dealRequestData(data as! Dictionary<String, AnyObject>)
            }) {
                print("数据获取错误")
        }
    }
    /// 解析请求数据
    func dealRequestData(data: Dictionary<String, AnyObject>) {
        let statusID = data["status"] as! String
        if statusID == "0" {
            let groups = data["group"] as! KRAreaListData
            areaData = groups
            reloadDisplayList()
        } else {
            print("status != 0")
        }
    }
    /// 重载显示列表
    func reloadDisplayList() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            weak var tempSelf = self
            if tempSelf == nil { return }
            tempSelf!.displayList.reloadData()
            // 显示大小和是否滑动
            let contentSize = tempSelf!.displayList.contentSize
            let maxViewHeight = tempSelf!.bounds.height
            var listHeight = maxViewHeight
            var enableScroll  =  true
            if contentSize.height <= maxViewHeight {
                // 部分
                listHeight = contentSize.height
                enableScroll = false
            }
            tempSelf?.displayList.scrollEnabled = enableScroll
            tempSelf?.displayList.frame.size.height = listHeight
        }
    }
    /// 移除视图
    func cancelAreaListView(isCancel: Bool = true) {
        delegate?.areaListViewWillCancel(self, isCancel: isCancel)
        removeFromSuperview()
    }
}

extension KRAreaListView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelAreaListView()
    }
}

extension KRAreaListView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)!
        cell.textLabel?.text = areaData[indexPath.row]["title"]
        return cell
    }
}

extension KRAreaListView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let title = cell.textLabel?.text
        checkTitle = title!
        cancelAreaListView(false)
    }
}

// TODO： 自定义Cell
class KRAreaListCell: UITableViewCell {
}



