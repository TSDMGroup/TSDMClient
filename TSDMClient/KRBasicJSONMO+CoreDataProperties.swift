//
//  KRBasicJSONMO+CoreDataProperties.swift
//  TSDMClient
//
//  Created by 王晶 on 15/10/21.
//  Copyright © 2015年 tsdmGroup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension KRBasicJSONMO {

    @NSManaged var key: String?
    @NSManaged var data: NSObject?

}
