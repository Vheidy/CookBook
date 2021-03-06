//
//  IngredientModel.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 22.03.2021.
//

import Foundation
import CoreData
import UIKit

typealias VoidCallback = () -> ()

struct IngredientModel: Encodable, Decodable {
    var name: String
    var id: String
}

protocol IngredientServiceProtocol {
    func addIngredient(_ ingredient: IngredientModel, completion: VoidCallback?)
    func deleteIngredient(index: Int, completion: VoidCallback?)
    var ingredientsCount: Int { get }
    
    func fetchIngredient(for index: Int) -> IngredientModel?
}

class IngredientsService: IngredientServiceProtocol {
    
    private var ingredientsStore = [IngredientModel]()
    private let coreDataService: CoreDataService
    
    var ingredientsCount: Int {
        ingredientsStore.count
    }
    
    init() {
        coreDataService = CoreDataService()
    }
    
    /// Return the ingredients for required IDs
    /// - Parameters:
    ///   - requiredIDs
    ///   - context: context where needs to find ingredient
    /// - Returns: array of Ingredients with required IDs
    func fetchIngredient(for requiredIDs: [String], context: NSManagedObjectContext? = nil) -> [Ingredient] {
        let currentContext = context ?? coreDataService.persistentContainer.newBackgroundContext()
        
        var array: [Ingredient] = []

        requiredIDs.forEach {
            let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
            fetchRequest.predicate = NSPredicate(format: "id == %@", $0)
            guard let ingredientsObjects = try? currentContext.fetch(fetchRequest) else { return }
            array.append(contentsOf: ingredientsObjects)
        }

        return array
    }
    
    /// Update all elements in ingredientsStore
    /// - Parameter complition: <#complition description#>
    func fetchAllElements(complition: VoidCallback?) {
        updateData(completion: complition)
    }
    
    // Add ingredient at ingredients array and CoreData
    func addIngredient(_ ingredient: IngredientModel, completion: VoidCallback?) {
        DispatchQueue.global(qos: .default).async {
            let currentContext = self.coreDataService.persistentContainer.newBackgroundContext()
            
            let ingredientObject = Ingredient(context: currentContext)
            ingredientObject.id = ingredient.id
            ingredientObject.name = ingredient.name
            do {
                try currentContext.save()
                self.updateData(completion: completion)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // Update the ingredients array from coreData
    private func updateData(completion: VoidCallback?) {
        DispatchQueue.global(qos: .default).async { [unowned self] in
            let currentContext = coreDataService.persistentContainer.newBackgroundContext()

            let fetchRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
            do {
                let ingredientsObjects = try currentContext.fetch(fetchRequest) as [Ingredient]
                ingredientsStore = []
                for element in ingredientsObjects {
                    if let name = element.value(forKey: "name") as? String, let id = element.value(forKey: "id") as? String {
                        let ingredient  = IngredientModel(name: name, id: id)
                        ingredientsStore.append(ingredient)
                    }
                }
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Delete ingredients from ingredients array and CoreData
    func deleteIngredient(index: Int, completion: VoidCallback?) {
        guard ingredientsStore.indices.contains(index) else {return}
        DispatchQueue.global(qos: .default).async { [unowned self] in
        let currentContext = coreDataService.persistentContainer.newBackgroundContext()
            let ingredient = ingredientsStore[index]
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ingredient")
            do {
                let ingredientsObjects = try currentContext.fetch(fetchRequest)
                for object in ingredientsObjects {
                    if let id = object.value(forKey: "id") as? String, id == ingredient.id {
                        currentContext.delete(object)
                        try currentContext.save()
                        updateData(completion: completion)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Get ingredient for indexPath
    func fetchIngredient(for index: Int) -> IngredientModel? {
        guard ingredientsStore.indices.contains(index) else {return nil}
        let ingredient = ingredientsStore[index]
        return  ingredient
    }

}
