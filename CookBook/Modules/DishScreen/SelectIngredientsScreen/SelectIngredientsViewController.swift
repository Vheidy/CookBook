//
//  ViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 22.03.2021.
//

import UIKit

class SelectIngredientsViewController: UITableViewController {

    var ingredientService: IngredientsService
    var saveSelectedCells: (_ cells: [IngredientModel]) -> ()
    
    init(saveCellsAction: @escaping (_ cells: [IngredientModel]) -> ()) {
        ingredientService = IngredientsService()
        saveSelectedCells = saveCellsAction
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientService.fetchAllElements { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setup() {
        view.backgroundColor = .white
        navigationItem.title = "Ingredient"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addIngredients)), animated: true)
        tableView.register(SelectTableViewCell.self, forCellReuseIdentifier: "SelectTableViewCell")
    }
 
    // Find selected cells and returns it in ingredient form
    @objc func addIngredients() {
        var selectedIngredients = [IngredientModel]()
        let section = 0
        
        for row in 0...tableView.numberOfRows(inSection: section) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SelectTableViewCell, let selectButton = cell.selectButton else {break}
            
            if !selectButton.isHidden {
                guard let name = cell.title?.text, let id = cell.id else { break }
                selectedIngredients.append(IngredientModel(name: name, id: id))
            }
        }
        
        self.saveSelectedCells(selectedIngredients)
        closeScreen()
    }
    
    @objc func closeScreen() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientService.ingredientsCount
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTableViewCell", for: indexPath) as? SelectTableViewCell else {
            return UITableViewCell()
        }
        
        guard let currentIngredient = ingredientService.fetchIngredient(for: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.title?.text = currentIngredient.name
        cell.id = currentIngredient.id
        
        return cell
    }
    
    
}
