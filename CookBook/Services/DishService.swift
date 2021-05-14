//
//  MainScreenViewModel.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 16.03.2021.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

struct DishModel: Encodable, Decodable {
    var name: String = ""
    var typeDish: String = ""
    var ingredient: [IngredientModel] = []
    var orderOfAction: [String] = []
    var imageName: String?
    var cuisine: String?
    var calories: Int32?
    var id: Date
}

//FIXME: UIImage shouldn't be there 
struct DisplayItem {
    let name: String
    let type: String
    var image: UIImage?
    let ingrediensCount: Int
}

protocol MainScreenViewModelProtocol: AnyObject {
    func countCells() -> Int
    func getFields(for index: Int) -> DisplayItem?
    func addDish(dish: DishModel)
    func deleteRows(index: Int)
    var updateScreen: (() -> ())? {get set}
}

class DishService {
    @AppStorage("dishes", store: UserDefaults(suiteName: "group.com.vheidy.CookBook.CookBookWidget"))
    var dishesData = Data()
    
    var fetchController = NSFetchedResultsController<Dish>()
//    var updateScreen: (() -> ())?
    
    private let coreDataService: CoreDataService
    private var currentContext: NSManagedObjectContext
    
    var sectionCount: Int {
        return fetchController.sections?.count ?? 0
    }
    
    init(dishes: [DishModel], completion: VoidCallback?) {
        coreDataService = CoreDataService()
        self.currentContext = coreDataService.persistentContainer.newBackgroundContext()
        loadSavedData()
    }
    
    /// Delete ingredients from ingredientsStrore for given indexPath
    func deleteRows(indexPath: IndexPath, completion: VoidCallback?) {
        let dish = fetchController.object(at: indexPath)
        currentContext.delete(dish)
        do {
            try currentContext.save()
            loadSavedData()
            completion?()
        } catch {
            print(error)
        }
    }
    
    /// Returns number of rows in given section
    /// - Parameter section: number of section
    /// - Returns: number of rows
    func rowsInSections(_ section: Int) -> Int {
        guard let sections = fetchController.sections, sections.indices.contains(section), let sectionInfo = fetchController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    private func loadSavedData() {
        let request = NSFetchRequest<Dish>(entityName: "Dish")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        fetchController = NSFetchedResultsController(fetchRequest: request,
                                                     managedObjectContext: currentContext,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
        do {
            try fetchController.performFetch()
            guard let dishes = fetchController.fetchedObjects else { return }
            if let dish = dishes.first, let dishModel = transormInDishModel(dishObject: dish) {
                saveData(dishModel)
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    func updateDish(_ dish: DishModel, completion: VoidCallback?) {
        guard let dishObject = fetchController.fetchedObjects else { return }
        let currentDishes = dishObject.filter({ $0.id == dish.id })
        guard !currentDishes.isEmpty else { return }
        let currentDish = currentDishes[0]
        currentDish.name = dish.name
        currentDish.typeDish = dish.typeDish
        currentDish.cuisine = dish.cuisine
        currentDish.imageName = dish.imageName
        currentDish.calories = dish.calories ?? 0
        
        transformIngredientsInObjects(dish, currentDish)
        transormActionsInObjects(dish, currentDish)
        
        do {
            try currentContext.save()
            loadSavedData()
            completion?()
        } catch {
            print("Save failed")
            print(error)
        }
    }
    
    private func saveData(_ dish: DishModel) {
        guard let dishesDataLoaded = try? JSONEncoder().encode(dish) else { return }
        self.dishesData = dishesDataLoaded
    }

    //Return dish for indexPath
    func fetchDish(for indexPath: IndexPath) -> DishModel? {
        guard let dishObjects = fetchController.fetchedObjects, dishObjects.indices.contains(indexPath.row) else { return nil }
        return transormInDishModel(dishObject: dishObjects[indexPath.row])
    }
    
    private func transormInDishModel(dishObject: Dish) -> DishModel? {
        guard let ingredients = dishObject.ingredients as? Set<Ingredient>,
              let arrayOfIngredients = transform(ingredients: ingredients),
              let actions = dishObject.orderOfActions as? Set<Action>,
              let arrayOfActions = transform(actions: actions),
              let name = dishObject.name, let typeDish = dishObject.typeDish,
              let id = dishObject.id
        else { return nil}
        
        return DishModel(name: name, typeDish: typeDish,
                         ingredient: arrayOfIngredients,
                         orderOfAction: arrayOfActions,
                         imageName: dishObject.imageName,
                         cuisine: dishObject.cuisine,
                         calories: dishObject.calories,
                         id: id)
    }
    
    // Transforn [Action] -> [String]
    private func transform(actions: Set<Action>) -> [String]? {
        var arrayOfActions: [String] = []
        for action in actions {
            guard let actionText = action.text else { return nil }
            arrayOfActions.append(actionText)
        }
        return arrayOfActions
    }
    
    // Transform [Ingredient] -> [IngredientModel]
    private func transform(ingredients: Set<Ingredient>) -> [IngredientModel]? {
        var arrayOfIngredients: [IngredientModel] = []
        for ingredient in ingredients {
            guard let name = ingredient.name, let id = ingredient.id else { return nil }
            let ingredientModel = IngredientModel(name: name, id: id)
            arrayOfIngredients.append(ingredientModel)
        }
        return arrayOfIngredients
    }
    
    /// Return the displayItem for indexPath
    /// - Parameter indexPath
    /// - Returns: DisplayItem which includes name, type and image of cells
    func getFields(for indexPath: IndexPath) -> DisplayItem? {
        var imageDish: UIImage?
        let dish = fetchController.object(at: indexPath)
        guard let name = dish.name, let dishType = dish.typeDish, let ingredients = dish.ingredients else { return nil }
        if let imageName = dish.imageName {
            let imageManager = DataFileManager()
            if let data = imageManager.read(fromDocumentsWithFileName: imageName) {
                
                imageDish = UIImage(data: data)
            }
//            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//            var path = paths[0] as String
//            path.append(imageName)
        }
        let displayModel = DisplayItem(name: name, type: dishType, image: imageDish, ingrediensCount: ingredients.count)
        return displayModel
    }
    
    // MARK: - Add Dish in Core Data
    // Transform DishModel in DishObject and save it in Coredata
    func addDish(dish: DishModel, completion: VoidCallback?) {
        let dishObject = Dish(context: currentContext)
        dishObject.name = dish.name
        dishObject.typeDish = dish.typeDish
        dishObject.cuisine = dish.cuisine
        dishObject.id = dish.id
        dishObject.imageName = dish.imageName
        dishObject.calories = dish.calories ?? 0
        
        transormActionsInObjects(dish, dishObject)
        if ExtraFunctionality.enabled {
            addIngredientsandSaveContext(dish, dishObject)
        } else {
            transformIngredientsInObjects(dish, dishObject)
        }
        
        do {
            try currentContext.save()
            loadSavedData()
            completion?()
        } catch {
            print("Save failed")
            print(error)
        }
    }
    
    // Transform [String] -> NSSet<Ingredients>
    private func transformIngredientsInObjects(_ dish: DishModel, _ dishObject: Dish) {
        var setIngredients = Set<Ingredient>()
        for ingredient in dish.ingredient {
            let ingredientObject = Ingredient(context: currentContext)
            ingredientObject.name = ingredient.name
            ingredientObject.id = ingredient.id
            setIngredients.insert(ingredientObject)
        }
        dishObject.ingredients = setIngredients as NSSet
    }
    
    // Transform [String] -> NSSet<Action>
    private func transormActionsInObjects(_ dish: DishModel, _ dishObject: Dish) {
        var setActions = Set<Action>()
        for action in dish.orderOfAction {
            let actionObject = Action(context: currentContext)
            actionObject.text = action
            setActions.insert(actionObject)
        }
        dishObject.orderOfActions = setActions as NSSet
    }
    
    // Fetch ingredients from CoreData
    private func addIngredientsandSaveContext(_ dish: DishModel, _ dishObject: Dish) {
        var setIngredients = Set<Ingredient>()
        let ingredientService = IngredientsService()
        let ingredientIDs = dish.ingredient.map({ $0.id })
        let objects = ingredientService.fetchIngredient(for: ingredientIDs, context: currentContext)
        for object in objects {
            setIngredients.insert(object)
        }
        dishObject.ingredients = setIngredients as NSSet
    }

}
