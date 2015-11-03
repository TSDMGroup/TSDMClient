//
//  KRCoreDataManager.swift
//  CoreData数据管理
//  TSDMClient
//
//  Created by 王晶 on 15/10/21.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//

import Foundation
import CoreData
/**
CoreData JSON数据键

- AreaList: 分区版块
*/
enum KRCoreDataJSONKey: Int {
    case AreaList = 1
}


 /// KRBasicJSONMO
class KRMOBasicJSON: KRCoreDataManager {
    
    init() {
        super.init(entityName: "KRBasicJSON")
    }
    
    /// 读取对应键值数据
    func readDataOFKey(title: KRCoreDataJSONKey) -> AnyObject? {
        let queryResult = queryCoreData(title)
        if !queryResult.status { return nil }
        
        for mo in (queryResult.mos as! [KRBasicJSONMO]) {
            return mo.data
        }
        return nil
    }
    
    /// 写入对应数据(如果标签数据存在,则覆盖)
    func writeData(title: KRCoreDataJSONKey, data: NSObject) -> Bool {
        let queryResult = queryCoreData(title)
        if !queryResult.status { return false }
        let mos = queryResult.mos!
        if mos.count == 0 {
            // Create
            let mo = KRBasicJSONMO(entity: entityDescription, insertIntoManagedObjectContext: context)
            mo.key = "\(title.rawValue)"
            mo.data = data
        } else {
            // Modify
            (mos[0] as! KRBasicJSONMO).data = data
        }
        return saveData()// 保存
    }
    
    /**
    查询数据
    
    - parameter key: 查询Key
    
    - returns: (status: 查询结果状态,true: 查询成功, false: 查询失败; result: 查询结果：注：查询失败时为nil)
    */
    private func queryCoreData(key: KRCoreDataJSONKey) -> (status: Bool, mos: [AnyObject]?) {
        let predicate = NSPredicate(format: "key LIKE %@", "\(key.rawValue)")
        return queryCoreData(predicate)
    }
}


class KRCoreDataManager {
    /// CoreData对象管理
    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    /// 实体描述
    private var entityDescription: NSEntityDescription {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
    }
    
    /// 实体名称
    private let entityName: String
    
    init(entityName: String) {
        self.entityName = entityName
    }

}

private extension KRCoreDataManager {
    /**
    CoreData数据查询
    
    - parameter predicate: 查询谓语
    
    - returns: (status: 查询结果状态,true: 查询成功, false: 查询失败; result: 查询结果：注：查询失败时为nil)
    */
    func queryCoreData(predicate: NSPredicate? = nil) -> (status: Bool, mos: [AnyObject]?) {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            let mos = try context.executeFetchRequest(request)
            return (true, mos)
        } catch {
            print("CoreData查询出错")
            return (false, nil)
        }
    }
    /**
    保存数据
    
    - returns: 保存结果(true: 成功, false: 失败)
    */
    func saveData() -> Bool {
        return (try? context.save()) != nil
    }
}

