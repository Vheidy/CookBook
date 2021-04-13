//
//  IngredientEditModel.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 22.03.2021.
//

import Foundation

class IngredientEditModel {
    var array: [EditScreenModelSection] = [EditScreenModelSection(title: "Main", needsHeader: .notNeeded, items: [.inputItem(placeholder: "Name", inputedText: nil)])]
    
    func sectionCount() -> Int {
        return array.count
    }
    
    func rowCount(in section: Int) -> Int? {
        guard array.indices.contains(section) else { return nil}
        return array[section].items.count
    }
}
