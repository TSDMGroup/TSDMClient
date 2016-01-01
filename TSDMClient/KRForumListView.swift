//
//  KRForumListView.swift
//  版块列表
//  TSDMClient
//
//  Created by 王晶 on 15/10/22.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation
/**
 版块视图列表
 */
protocol KRForumListViewDelegate: NSObjectProtocol {
    // 查看版块主题
    func enterForumThemes(para: [String: AnyObject])
}

//MARK: View
/// 版块列表
class KRForumListView: UIView {
    
    private var listView: UITableView!
    
    weak var delegate: KRForumListViewDelegate?
    
    
    override var frame: CGRect {
        didSet {
            if listView != nil {
                listView.frame = bounds
            }
        }
    }
    /// 分区标记
    var groupItemData: Dictionary<String, AnyObject>? {
        didSet {
            updateData()
        }
    }
    /// 列表数据
    var listData: KRNetworkDataItemT = [] {
        didSet {
            listView.reloadData()
        }
    }
    /// 数据管理
    var dataManager: KRForumListData!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildListView()// 创建列表视图
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let KRForumListViewCellIdentifier = "ForumListViewCellIdentifier"

private extension KRForumListView {
    /// 创建列表视图
    func buildListView() {
        listView = UITableView(frame: bounds, style: .Plain)
        listView.dataSource = self
        listView.delegate = self
        listView.registerClass(KRForumListViewCell.self, forCellReuseIdentifier: KRForumListViewCellIdentifier)
        addSubview(listView)
        
        listView.backgroundColor = UIColor.clearColor()
        listView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    /// 创建数据管理类
    func updateData() {
        if dataManager == nil {
            dataManager = KRForumListData()
            dataManager.delegate = self
        }
        
        if groupItemData == nil { return }
        dataManager!.requestDataOfNetwork((groupItemData!["gid"] as! NSNumber).integerValue)
    }
}

//MARK: UITableViewDataSource
extension KRForumListView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(KRForumListViewCellIdentifier) as! KRForumListViewCell
        let itemData = listData[indexPath.row]
        cell.forumName = itemData["title"]! as! String
        cell.postNumOfToday = (itemData["todaypost"] as! NSNumber).integerValue
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KRForumListView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点击\(indexPath.row)")
        let itemData = listData[indexPath.row]
        let fid  = itemData["fid"] as! NSNumber
        let title = itemData["title"] as! String
        delegate?.enterForumThemes(["fid": fid, "title": title])
    }
}

//MARK: KRForumListDataDelegate
extension KRForumListView: KRForumListDataDelegate {
    func forumListDara(groupID: Int, data: KRNetworkDataItemT?) {
        if data != nil {
            listData = data!
        }
    }
}

/// 版块列表Cell
class KRForumListViewCell: UITableViewCell {
    
    /// 版块名称
    var forumName: String = "" {
        didSet {
            buildForumNameLable()
        }
    }
    /// 今天发帖子数
    var postNumOfToday: Int = 0 {
        didSet {
            buildPostNumOfToday()
        }
    }
    
    private var  forumNameLable: UILabel?
    private var postNumOfTodayLable: UILabel?
}

extension KRForumListViewCell {
    
    /// Build 版块名称视图
    func buildForumNameLable() {
        // Create forumNameLable
        if forumNameLable == nil {
            forumNameLable = UILabel(frame: CGRectZero)
            contentView.addSubview(forumNameLable!)
            forumNameLable?.translatesAutoresizingMaskIntoConstraints = false
            updateMyConstraints()
        }
        forumNameLable!.text = forumName
    }
     /// Build 版块今天发帖数
    func buildPostNumOfToday() {
        if postNumOfTodayLable == nil {
            postNumOfTodayLable = UILabel(frame: CGRectZero)
            postNumOfTodayLable?.textAlignment = .Right
            contentView.addSubview(postNumOfTodayLable!)
            postNumOfTodayLable?.translatesAutoresizingMaskIntoConstraints = false
            updateMyConstraints()
        }
        postNumOfTodayLable!.text = "(\(postNumOfToday))"
    }
    
    /**
     设置空间约束
     */
    func updateMyConstraints() {
        if forumNameLable == nil || postNumOfTodayLable == nil { return }
        let views = ["v1": forumNameLable!, "v2": postNumOfTodayLable!]
        let h_c = NSLayoutConstraint.constraintsWithVisualFormat("|-[v1]-[v2(60)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        let v_v1_c = NSLayoutConstraint.constraintsWithVisualFormat("V:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        let v_v2_c = NSLayoutConstraint.constraintsWithVisualFormat("V:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        addConstraints(h_c + v_v1_c + v_v2_c)
    }
}

//MARK: Data
typealias KRForumListDataT = Array<Dictionary<String, String>>

protocol KRForumListDataDelegate: NSObjectProtocol {
    /// 网络动态请求
    func forumListDara(groupID: Int, data: KRNetworkDataItemT?)
}

class KRForumListData: KRNetworkDataBasis {
     weak var delegate: KRForumListDataDelegate?
    
    // 网络请求
    func requestDataOfNetwork(groupID: Int) {
        weak var tempSelf = self
        networkManager.forumList(groupID, success: { (data) -> () in
            if tempSelf == nil { return }
            let result = tempSelf!.dealRequestData(data as! KRNetworkDataT, dataKey: "forum")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tempSelf!.delegate?.forumListDara(groupID, data: result.1)
            })
            }) { () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    tempSelf?.delegate?.forumListDara(groupID, data: nil)
                })
        }
    }
    
    // 解析数据
}

/// 网络请求数据类型
typealias KRNetworkDataT = Dictionary<String, AnyObject>
/// 网络请求元素数据类型
typealias KRNetworkDataItemT = Array<Dictionary<String, AnyObject>>
/// 网络请求数据基类
class KRNetworkDataBasis {
    
    lazy var networkManager = KRRequestDataManager()
    
    /// 解析请求数据
    func dealRequestData(data: KRNetworkDataT, dataKey: String) -> (Bool, KRNetworkDataItemT?) {
        let statusID = (data["status"] as! NSNumber).boolValue
        return (statusID, data[dataKey] as? KRNetworkDataItemT)
    }
}



