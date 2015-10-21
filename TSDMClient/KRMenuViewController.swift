//
//  KRMenuViewController.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/12.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import UIKit

/// Menu view to Display
class KRMenuViewController: UIViewController, ICSDrawerControllerChild {
    /// Menu data type
    struct MenuData {
        let text: String
        let imageName: String
    }
    
    /// User Info View
    var userInfoView: UserInfoView!
    /// The list of menus
    var listView: UITableView!
    /// The colloction of menu's keys
    var listKeys: Array<MenuData> = []
    
    /// ICSDrawerControllerChild
    weak var drawer: ICSDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeUserInfoView() // initialized User Info View
        initializeListView()// initialized List view
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
//MARK: Private Method
private extension KRMenuViewController {
    /// initialization User info view
    func initializeUserInfoView() {
        listKeys = [MenuData(text: "发现", imageName:"menu_bookshelf_bg"),
            MenuData(text: "消息", imageName: "menu_bookstore_bg"),
            MenuData(text: "设置", imageName: "menu_download_bg"),
            MenuData(text: "关于", imageName: "menu_record_bg"),
            MenuData(text: "反馈", imageName: "menu_set_bg")
        ]
        
        userInfoView = UserInfoView(viewType: .simple, viewWidth: view.bounds.width)
        userInfoView.backgroundColor = UIColor.grayColor()
        view.addSubview(userInfoView)
    }
    
    ///  Intialization list of menus
    func initializeListView() {
        // Set Frame
        let userInfoViewRect =  userInfoView.frame
        let uivMaxY = userInfoViewRect.height + userInfoViewRect.origin.y
        var rect = view.bounds
        rect.origin.y = uivMaxY
        rect.size.height -= uivMaxY
        rect.size.width = userInfoViewRect.width
        
        // Basic Setting
        listView = UITableView(frame: rect, style: .Plain)
        listView.delegate = self
        listView.dataSource = self
        listView.registerClass(UITableViewCell.self, forCellReuseIdentifier: KRMenuListViewCellIdentifier)
        view.addSubview(listView)
        
        // Special Deal
        listView.tableFooterView = UIView(frame: CGRectZero)
        listView.rowHeight = 60
        listView.separatorStyle = .None
    }
}

///  Identifier of the listView's Cell
private let KRMenuListViewCellIdentifier = "KRMenuListViewCellIdentifier"

//MARK: UITableViewDataSource
extension KRMenuViewController: UITableViewDataSource {
    // Set number of Rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Auto deal the scroll state of list view
        tableView.scrollEnabled = (tableView.contentSize.height > tableView.bounds.height)
        return listKeys.count
    }
    
    // Set TableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(KRMenuListViewCellIdentifier)!
        
        let cellData = listKeys[indexPath.row]
        if cell.textLabel == nil || cell.textLabel!.text != cellData.text {
            cell.selectionStyle = .None
            cell.textLabel?.text = listKeys[indexPath.row].text
            cell.imageView?.image = UIImage(named: cellData.imageName)
        }
        
        return cell
    }
}

extension KRMenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: 快速点击
        print(listKeys[indexPath.row].text)
//        let about = AboutViewController()
        var color = UIColor.whiteColor()
        switch indexPath.row {
        case 0:
            color = UIColor.blueColor()
        case 1:
            color = UIColor.redColor()
        case 2:
            color = UIColor.greenColor()
        case 3:
            color = UIColor.orangeColor()
        case 4:
            color = UIColor(red: 232/255.0, green: 106/255.0, blue: 62/255.0, alpha: 1)
        default:
            break
        }
        
        if drawer == nil {
            print("drawer nil")
            if drawer!.centerViewController.navigationController == nil {
                print("nav nil")
            }
        }
        
        drawer!.reloadCenterViewControllerUsingBlock { () -> Void in
//            self.drawer?.removeGestureRecognizerFromView()
//            (self.drawer?.centerViewController as! UINavigationController).pushViewController(about, animated: false)
            
            (self.drawer?.centerViewController as! UINavigationController).viewControllers[0].view.backgroundColor = color
        }
    }
}

/**
user info type

- simple: simple info to display
*/
enum UserInfoViewType {
    case simple
}

/// User info to display
class UserInfoView: UIView {
    // Avatar to display
    let avatarView: UIImageView
    /// Display type
    var viewType: UserInfoViewType
    
    init(viewType: UserInfoViewType, viewWidth: CGFloat) {
        // initialzed avatar View
        avatarView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 60, height: 60)))
        
        // View Type
        self.viewType = viewType
        var rect = CGRectZero
        switch viewType {
        case .simple:
            rect =  CGRect(origin: CGPointZero, size: CGSize(width: viewWidth, height: 60 + 100))
        }
        
        super.init(frame: rect)
        
        // Current Setting
        avatarView.image = UIImage(named: "avatarDefault")
        addSubview(avatarView)
        backgroundColor = UIColor.grayColor()
        
        settingSimpleView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserInfoView {
    ///  set simple view
    func settingSimpleView() {
        let avatarViewSize = avatarView.frame.size
        avatarView.center = CGPoint(x: avatarViewSize.width/2.0 + 20, y: avatarViewSize.height/2.0 + 50)
    }
}


