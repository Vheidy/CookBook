//
//  CoreDataService.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 08.04.2021.
//

import Foundation
import CoreData

@objc protocol SaveObjectProtocol {
    func save(objectName: String, params: [String: Any]) throws
    func fetchObjectsCount(request: NSFetchRequest<NSManagedObject>) -> Int
}

@objc class CoreDataService: NSObject, SaveObjectProtocol {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IngredientsModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.newBackgroundContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(objectName: String, params: [String: Any] = [:]) throws {
        let currentContext = self.persistentContainer.newBackgroundContext()
        
        let object = NSEntityDescription.insertNewObject(forEntityName: objectName, into: currentContext)
        for (key, value) in params {
            object.setValue(value, forKey: key)
        }
        if let initObject = object as? Initialization {
            initObject.id = UUID()
        }
        do {
            try currentContext.save()
        } catch let error as NSError {
            throw(error)
        }
    }
    
    func fetchObjectsCount(request: NSFetchRequest<NSManagedObject>) -> Int {
        do {
            let objects = try fetchObjects(request: request)
            return objects.count
        } catch {
            print(error)
            return 0
        }
    }
    
    func fetchObjects(request: NSFetchRequest<NSManagedObject>) throws -> [NSManagedObject] {
        let currentContext = self.persistentContainer.newBackgroundContext()
        do {
            let ingredientsObjects = try currentContext.fetch(request)
            return ingredientsObjects
        } catch {
            throw(error)
        }
    }
}
