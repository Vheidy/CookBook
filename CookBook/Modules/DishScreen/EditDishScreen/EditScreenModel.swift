//
//  EditScreenModel.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 18.03.2021.
//

import Foundation
import UIKit

// struct ConstantSection {
//    let title: String
//    let placeholderArray: [String]
// }
//
// struct ConstantNamesView {
//    static let array: [ConstantSection] = [ConstantSection(title: "Image", placeholderArray: []),
//                                           ConstantSection(title: "Base Info", placeholderArray: ["Dish Name", "Dish Type"]),
//                                           ConstantSection(title: "Ingredients", placeholderArray: ["Ingredient"]),
//                                           ConstantSection(title: "Order of Action", placeholderArray: ["Action"]),
//                                           ConstantSection(title: "Extra", placeholderArray: ["Cuisine", "Calories"])
//    ]
// }

// struct DishModel {
//    var name: String = ""
//    var typeDish: String = ""
//    var ingredient: [IngredientModel] = []
//    var orderOfAction: [String] = []
//    var imageName: String?
//    var cuisine: String?
//    var calories: Int32?
//    var id: Date
// }

enum EditScreenItemType {
    case image
    case inputItem(placeholder: String, inputedText: String?)
    case labelItem(title: String)
}

enum EditScreenHeaderType: Equatable {
    case need(title: String)
    case notNeeded
}

struct EditScreenModelSection {
    let title: String
//    let section: EditScreenSectionType
    var needsHeader: EditScreenHeaderType = .notNeeded
    var isRemovable: Bool = false
    var items: [EditScreenItemType]
    
    func checkRemavable() -> Bool {
        isRemovable && items.count > 1
    }
}

enum EditScreenSectionType {
    case photoHeader
    case baseInfo
    case ingredients
    case actions
    case extraInfo
}

enum EditScreenBaseInfoType {
    case title
    case type
}

enum EditScreenConvertationModelHelper {

    static func convertate(with dish: DishModel) -> [EditScreenModelSection] {
        var array = [EditScreenModelSection]()
        
        array.append(EditScreenModelSection(title: "Image", items: [.image]))
        array.append(EditScreenModelSection(title: "Base Info",
                                            items: [.inputItem(placeholder: "Dish Name",
                                                               inputedText: dish.name), .inputItem(placeholder: "Dish Type",
                                                                                                   inputedText: dish.typeDish)]))
        
        var ingredientItems = [EditScreenItemType]()
        for ingredient in dish.ingredient {
            ingredientItems.append(.labelItem(title: ingredient.name))
        }
        array.append(EditScreenModelSection(title: "Ingredients",
                                            needsHeader: .need(title: "Ingredients"),
                                            isRemovable: true,
                                            items: ingredientItems))

        var actionsItems = [EditScreenItemType]()
        for action in dish.orderOfAction {
            actionsItems.append(.inputItem(placeholder: "Action", inputedText: action))
        }
        array.append(EditScreenModelSection(title: "Order of Action",
                                            needsHeader: .need(title: "Order of Action"),
                                            isRemovable: true,
                                            items: actionsItems))
        let calories: String = (dish.calories != nil && dish.calories != 0) ? String(dish.calories!) : ""
        array.append(EditScreenModelSection(title: "Extra",
                                            items: [.inputItem(placeholder: "Cuisine",
                                                               inputedText: dish.cuisine),
                                                    .inputItem(placeholder: "Calories",
                                                               inputedText: calories)]))
        
//        array.append(EditScreenModelSection(title: "Extra", items: [.inputItem(placeholder: "Cuisine", inputedText: dish.cuisine), .inputItem(placeholder: "Calories", inputedText: String(dish.calories)?)]))
        
        return array
    }
}

class EditScreenModel {
    
    //    var sectionNames = ["Image", "Base Info", ]
    
    // Contains a structure of view in Edit Screen
    private var array: [EditScreenModelSection] = [ EditScreenModelSection(title: "Image",
                                                                           needsHeader: .notNeeded,
                                                                           items: [.image]),
                                                    EditScreenModelSection(title: "Base Info",
                                                                           needsHeader: .notNeeded,
                                                                           items: [.inputItem(placeholder: "Dish Name",
                                                                                              inputedText: nil),
                                                                                   .inputItem(placeholder: "Dish Type",
                                                                                              inputedText: nil)]),
                                                    EditScreenModelSection(title: "Ingredients",
                                                                           needsHeader: .need(title: "Ingredients"),
                                                                           isRemovable: true,
                                                                           items: [ .inputItem(placeholder: "Ingredient", inputedText: nil)]),
                                                    EditScreenModelSection(title: "Order of Action",
                                                                           needsHeader: .need(title: "Order of Action"),
                                                                           isRemovable: true,
                                                                           items: [.inputItem(placeholder: "Action",
                                                                                              inputedText: nil)]),
                                                    EditScreenModelSection(title: "Extra",
                                                                           needsHeader: .notNeeded,
                                                                           items: [.inputItem(placeholder: "Cuisine",
                                                                                              inputedText: nil),
                                                                                   .inputItem(placeholder: "Calories",
                                                                                              inputedText: nil)])
    ]
    
    func setDish(_ dishModel: DishModel) {
        array = EditScreenConvertationModelHelper.convertate(with: dishModel)
    }
    
    var sectionCount: Int {
        array.count
    }
    
    // Return type of the cell
    func getRow(for indexPath: IndexPath) -> EditScreenItemType? {
        guard array.indices.contains(indexPath.section), array[indexPath.section].items.indices.contains(indexPath.row) else { return nil }
        return array[indexPath.section].items[indexPath.row]
    }
   
    // Add the new cell in section and return the indexPath of this cell

    func appEnd(section: Int, ingredient: IngredientModel?) -> IndexPath {
       let mySection = array[section]
       let indexPath = IndexPath(row: mySection.items.count, section: section)
       switch mySection.title {
       case "Ingredients":
        if let newIngredient = ingredient, TabBarViewController.extraFunctionality {
            array[section].items.append(.labelItem(title: newIngredient.name))
        } else {
            array[section].items.append(.inputItem(placeholder: "Ingredient", inputedText: nil))
        }
       case "Order of Action":
        array[section].items.append(.inputItem(placeholder: "Action", inputedText: nil))
       default:
           break
       }
       return indexPath
   }
    
    // Check if the cells need to be delete
    func checkDeleting(indexPath: IndexPath) -> Bool {
        guard array.indices.contains(indexPath.section), array[indexPath.section].items.indices.contains(indexPath.row)  else { return false }
       let section = array[indexPath.section]
        guard section.checkRemavable() else { return false }
       array[indexPath.section].items.remove(at: indexPath.row)
       return true
   }
   
    // Количесто рядов в секции
    func getRowsInSectionCount(section: Int) -> Int {
        guard let mySection = getSection(section: section) else { return 0 }
      return mySection.items.count
   }
   
    // Возвращает ряды секции
   func getRowsInSection(section: Int) -> [EditScreenItemType] {
    guard let mySection = getSection(section: section) else { return [] }
    return mySection.items
   }
   
    // Возвращает название секции
    func getTitleSection(section: Int) -> String? {
        getSection(section: section)?.title
   }
    
    // Возвращает секцию
    func getSection(section: Int) -> EditScreenModelSection? {
        guard array.indices.contains(section) else { return nil }
        return array[section]
    }
 
}
