//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by Hiroaki Komatsu on 2016/04/02.
//  Copyright © 2016年 Hiroaki Komatsu. All rights reserved.
//

import UIKit
import CoreData

struct EntityName {
    static let blog = "Blog"
    static let article = "Article"
}

class CoreDataManager: NSObject {
    class var sharedInstance: CoreDataManager {
        struct Singleton {
            static let instance: CoreDataManager = CoreDataManager()
        }
        return Singleton.instance
    }
    
    private let Entity_Blog = "Blog"
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var blogs: [Blog]? {
        get {
            let fetchRequest = NSFetchRequest(entityName: EntityName.blog)
            do {
                let entities = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [Blog]
                return entities!
            } catch let error as NSError {
                print(error)
            }
            return nil
        }
    }
    
    private func search(entityName: String, _ uuid: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
        do {
            let entities = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
//            let entities = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [Blog]
            if entities.count > 0 {
                return entities[0] as? NSManagedObject
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func addBlog(title: String) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(EntityName.blog, inManagedObjectContext: self.appDelegate.managedObjectContext) as! Blog
        entity.uuid = NSUUID().UUIDString
        entity.title = title
        self.appDelegate.saveContext()
    }
    
    func deleteBlog(uuid: String) {
        let entity = self.search(EntityName.blog, uuid)
        if entity != nil {
            self.appDelegate.managedObjectContext.deleteObject(entity!)
            self.appDelegate.saveContext()
        }
    }
    
    func updateBlog(uuid: String, title: String) {
        let entity = self.search(EntityName.blog, uuid) as? Blog
        if entity != nil {
            entity!.title = title
            self.appDelegate.saveContext()
        }
    }
    
    func articles(blog_uuid: String) -> [Article]? {
        let fetchRequest = NSFetchRequest(entityName: EntityName.article)
        fetchRequest.predicate = NSPredicate(format: "blog.uuid = %@", blog_uuid)
        do {
            let entities = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [Article]
            return entities
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func article(uuid: String) -> Article? {
        let fetchRequest = NSFetchRequest(entityName: EntityName.article)
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
        do {
            let entities = try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [Article]
            if entities?.count > 0 {
                return entities![0]
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func addArticle(blog_uuid: String, title: String, body: String) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName(EntityName.article, inManagedObjectContext: self.appDelegate.managedObjectContext) as! Article
        entity.uuid = NSUUID().UUIDString
        entity.body = body
        entity.title = title
        entity.blog = self.search(EntityName.blog, blog_uuid) as? Blog
        self.appDelegate.saveContext()
    }
    
    func deleteArticle(uuid: String) {
        let entity = self.search(EntityName.article, uuid)
        if entity != nil {
            self.appDelegate.managedObjectContext.deleteObject(entity!)
            self.appDelegate.saveContext()
        }
    }
    
    func updateArticle(uuid: String, title: String) {
        let entity = self.search(EntityName.article, uuid) as? Article
        if entity != nil {
            entity!.title = title
            self.appDelegate.saveContext()
        }
    }
    
    func updateArticle(uuid: String, active: Bool) {
        let entity = self.search(EntityName.article, uuid) as? Article
        if entity != nil {
            entity!.active = active
            self.appDelegate.saveContext()
        }
    }
    
}
