//
//  Blog+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Hiroaki Komatsu on 2016/04/06.
//  Copyright © 2016年 Hiroaki Komatsu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Blog {

    @NSManaged var title: String?
    @NSManaged var uuid: String?
    @NSManaged var articles: NSSet?

}
