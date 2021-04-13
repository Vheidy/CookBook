//
//  MainScreenViewModel.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 16.03.2021.
//

import Foundation
import UIKit
import CoreData

struct DishModel {
    var name: String = ""
    var typeDish: String = ""
    var ingredient: [IngredientModel] = []
    var orderOfAction: [String] = []
    var imageName: String?
    var cuisine: String?
    var calories: Int32?
    var id: Date
}

struct DisplayItem {
    let name: String
    let type: String
    var image: UIImage?
}

protocol MainScreenViewModelProtocol: AnyObject {
    func countCells() -> Int
    func getFields(for index: Int) -> DisplayItem?
    func addDish(dish: DishModel)
    func deleteRows(index: Int)
    var updateScreen: (() -> ())? {get set}
}

class DishService {
    
    var fetchController = NSFetchedResultsController<Dish>()
    var updateScreen: (() -> ())?
    
    private let coreDataService: CoreDataService
    private var currentContext: NSManagedObjectContext
    
    var sectionCount: Int {
        return fetchController.sections?.count ?? 0
    }
    
    func rowsInSections(_ section: Int) -> Int {
        guard let sections = fetchController.sections, sections.indices.contains(section), let sectionInfo = fetchController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    init(dishes: [DishModel], completion: VoidCallback?) {
        coreDataService = CoreDataService()
        self.currentContext = coreDataService.persistentContainer.newBackgroundContext()
        loadSavedData()
    }
    
    
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
    
    func loadSavedData() {
        let request = NSFetchRequest<Dish>(entityName: "Dish")
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: currentContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    //Return dish for indexPath
    func fetchDish(for indexPath: IndexPath) -> DishModel? {
        guard let dishObjects = fetchController.fetchedObjects, dishObjects.indices.contains(indexPath.row) else { return nil }
        let dishObject = dishObjects[indexPath.row]
        guard let ingredients = dishObject.ingredients as? Set<Ingredient>, let arrayOfIngredients = transform(ingredients: ingredients),  let actions = dishObject.orderOfActions as? Set<Action>, let arrayOfActions = transform(actions: actions), let name = dishObject.name, let typeDish = dishObject.typeDish, let id = dishObject.id  else { return nil}
        
        return DishModel(name: name, typeDish: typeDish, ingredient: arrayOfIngredients, orderOfAction: arrayOfActions, imageName: dishObject.imageName, cuisine: dishObject.cuisine, calories: dishObject.calories, id: id)
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
    
    func getFields(for indexPath: IndexPath) -> DisplayItem? {
        var imageDish: UIImage?
        let dish = fetchController.object(at: indexPath)
        guard let name = dish.name, let dishType = dish.typeDish else { return nil }
        if let imageName = dish.imageName {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            var path = paths[0] as String
            path.append(imageName)
            imageDish = UIImage(contentsOfFile: path)
        }
        let displayModel = DisplayItem(name: name, type: dishType, image: imageDish)
        return displayModel
    }
    

    //MARK: - Add Dish in Core Data

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
        addIngredientsandSaveContext(dish, dishObject)
        
        do {
            try currentContext.save()
            loadSavedData()
            completion?()
        } catch {
            print("Save failed")
            print(error)
        }
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
