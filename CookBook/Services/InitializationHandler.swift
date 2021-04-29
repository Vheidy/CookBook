//
//  InitializationHandler.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 27.04.2021.
//

import UIKit
import CoreData

@objc class InitializationHandler: NSObject {

    private let coreDataService: SaveObjectProtocol
    
@objc init(service: SaveObjectProtocol) {
        coreDataService = service
    }
    
    /// This method should called when you want to save current initialization
    @objc func saveInitialization() {
        do {
            try coreDataService.save(objectName: "Initialization")
        } catch {
            print("Could not save new initialization. \(error)")
        }
    }
    
    /// This method return current number of app inittialization
    /// - Returns: Number of initialization
    @objc func fetchNumberOfInitialization() -> Int {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Initialization")
        return coreDataService.fetchObjectsCount(request: fetchRequest)
    }
}
