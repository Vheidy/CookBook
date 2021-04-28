//
//  InitializationHandler.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

import UIKit
import CoreData

@objc class InitializationHandler: NSObject {

    private let coreDataService: CoreDataService
    
    override init() {
        coreDataService = CoreDataService()
    }
    
    @objc func saveInitialization() {
//        DispatchQueue.global(qos: .default).async {
            let currentContext = self.coreDataService.persistentContainer.newBackgroundContext()
            
            let initObject = Initialization(context: currentContext)
            initObject.id = UUID()
            do {
                try currentContext.save()
//                print("ok")
            } catch let error as NSError {
                print("Could not save new initialization. \(error), \(error.userInfo)")
            }
//        }
    }
    
    @objc func fetchNumberOfInitialization() -> Int {
        let currentContext = coreDataService.persistentContainer.newBackgroundContext()
        
//        let fetchRequest = NSFetchRequest<Initialization>()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Initialization")
        do {
            let ingredientsObjects = try currentContext.fetch(fetchRequest)
            return ingredientsObjects.count
        } catch {
            print(error)
            return 0
        }
        
    }
}
