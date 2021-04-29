//
//  InitializationHandler.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

import UIKit
import CoreData

@objc class MockSaveObject: NSObject, SaveObjectProtocol {
    var initialNumber = 0
    
    func save(objectName: String) throws {
        initialNumber += 1
    }
    
    func fetchObjectsCount(request: NSFetchRequest<NSManagedObject>) -> Int {
        initialNumber
    }
}

@objc class InitializationHandler: NSObject {

    private let coreDataService: SaveObjectProtocol
    
@objc init(service: SaveObjectProtocol) {
        coreDataService = service
    }
    
    @objc func saveInitialization() {
        do {
            try coreDataService.save(objectName: "Initialization")
        } catch {
            print("Could not save new initialization. \(error)")
        }
    }
    
    @objc func fetchNumberOfInitialization() -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Initialization")
        return coreDataService.fetchObjectsCount(request: fetchRequest)
    }
}
