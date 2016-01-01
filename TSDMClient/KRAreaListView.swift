//
//  AreaListView.swift
//  分区选择列表
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

//MARK: - View

protocol KRAreaListViewDelegate: NSObjectProtocol {
    /// 地区列表视图取消
    func areaListViewWillCancel(areaListView: KRAreaListView, isCancel: Bool)
}

/// 版块分区列表选择视图
class KRAreaListView: UIView {
    weak var delegate: KRAreaListViewDelegate?
    
    
    var checkItem: Dictionary<String, AnyObject>?
    
    /// 分区数据
    private var areaData: KRAreaListData = [] {
        didSet(old) {
            print("-----------------")
            print(areaData)
            reloadDisplayList()
        }
    }
    /// 显示列表
    private var displayList: UITableView!
    private let dataManager = KRAreaListDataManager()
    
    init() {
        super.init(frame: CGRect(origin: CGPointZero, size: KRScreenSize))
        
        backgroundColor = UIColor.clearColor()
        initDisplayList()// 配置视图
        // 配置数据管理类
        dataManager.delegate = self
        areaData = dataManager.areaListdata
        clipsToBounds = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 显示视图
    func showView() {
        setDisplayListFrame()
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
    
    /// 重载显示列表
    func reloadDisplayList() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            weak var tempSelf = self
            tempSelf?.displayList.reloadData()// 刷新视图
        }
    }
    
    /// 根据内容设置视图的大小和滑动开关
    func setDisplayListFrame() {
        // 显示大小和是否滑动
        let contentSize = displayList.contentSize
        let maxViewHeight = bounds.height
        var listHeight = maxViewHeight
        var enableScroll  =  true
        if contentSize.height <= maxViewHeight {
            // 部分
            listHeight = contentSize.height
            enableScroll = false
        }
        // 处理重复设置
        if displayList.scrollEnabled != enableScroll {
            displayList.scrollEnabled = enableScroll
        }
        if displayList.frame.size.height != listHeight {
            userInteractionEnabled = false
            UIView.animateWithDuration(0.6,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.1,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    self.displayList.frame.size.height = listHeight
                }) { status in
                    if status {
                        self.userInteractionEnabled = true
                    }
            }
        }
    }
    
    /// 移除视图
    func cancelAreaListView(isCancel: Bool = true) {
        delegate?.areaListViewWillCancel(self, isCancel: isCancel)
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.displayList.frame.size.height = 0
            }) { (status) -> Void in
                self.removeFromSuperview()
        }
    }
}

extension KRAreaListView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelAreaListView()
    }
}

//MARK: UITableViewDataSource
extension KRAreaListView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setDisplayListFrame()
        return areaData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)!
        cell.textLabel?.text = areaData[indexPath.row]["title"] as? String
        return cell
    }
}

//MARK: UITableViewDelegate
extension KRAreaListView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        checkItem = areaData[indexPath.row]
        cancelAreaListView(false)
    }
}

//MARK: KRAreaListDataManagerDelegate
extension KRAreaListView: KRAreaListDataManagerDelegate {
    func areaListDataChange(areaListdata: KRAreaListData) {
        areaData = areaListdata
    }
}

// TODO： 自定义Cell
class KRAreaListCell: UITableViewCell {
}
/// 分区版块列表数据代理
protocol KRAreaListDataManagerDelegate: NSObjectProtocol {
    func areaListDataChange(areaListdata: KRAreaListData)
}

//MARK: - Data

/// 分区版块列表数据类型
typealias KRAreaListData = Array<Dictionary<String, AnyObject>>
/// 分区版块数据管理
class KRAreaListDataManager {
    /// 数据动态状态代理
    weak var delegate: KRAreaListDataManagerDelegate?
    
    enum KRRequestStatus {
        case none, loading, success, failure
    }
    
    var areaListdata: KRAreaListData = [] {
        didSet(old) {
            delegate?.areaListDataChange(areaListdata)
        }
    }
    /// 网络请求状态
    var requestStatus: KRRequestStatus = .none {
        didSet(old) {
            switch requestStatus {
            case .success:
                saveNetworkData()// 存储网络数据
                requestStatus = .none
            default:
                break
            }
        }
    }
    
    init() {
        checkLocationData()
    }
}

private extension KRAreaListDataManager {
    
    /// 获取数据
    func checkLocationData() {
        let locationData = KRMOBasicJSON().readDataOFKey(.AreaList)// 从本地获取
        if locationData == nil {
            requestNetworkData()
            return
        }
        areaListdata = locationData! as! KRAreaListData
    }
    
    // 从网络获取数据
    func requestNetworkData() {
        requestStatus = .loading
        weak var tempSelf = self
        KRRequestDataManager().areaList({ (data) -> () in
            tempSelf?.dealRequestData(data as! Dictionary<String, AnyObject>)
            tempSelf?.requestStatus = .success
            }) {
                print("数据获取错误")
                tempSelf?.requestStatus = .failure
        }
    }
    
    /// 解析请求数据
    func dealRequestData(data: Dictionary<String, AnyObject>) {
        let statusID = data["status"] as! NSNumber
        if !statusID.boolValue {
            areaListdata = data["group"] as! KRAreaListData
        } else {
            print("status != 0")
        }
    }
    
    /// 存储网络数据
    func saveNetworkData() {
        let saveStatus = KRMOBasicJSON().writeData(.AreaList, data: areaListdata)
        if !saveStatus { print("网络数据存储失败") }
    }
}

