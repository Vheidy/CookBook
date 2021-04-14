//
//  IngredientScreenTableViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 15.03.2021.
//

import UIKit
import CoreData


class IngredientScreenTableViewController: UITableViewController {
    
    private lazy var ingredientService =  IngredientsService()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
//        navigationItem.title = "Ingredients"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentEditScreen))
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ingredients"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentEditScreen))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ingredientService.fetchAllElements { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // Present alert to input ingredient name
    @objc func presentEditScreen() {
        let alertController = UIAlertController(title: "Add ingredient", message: "Enter ingredient name", preferredStyle: .alert)
        
        let actionDone = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            
            guard let textField = alertController.textFields?.first, let nameToSave = textField.text, !nameToSave.isEmpty else { return }
            ingredientService.addIngredient(IngredientModel(name: nameToSave, id: UUID().uuidString)) { [weak self] in
                self?.tableView.reloadData()
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(actionDone)
        alertController.addAction(actionCancel)
        alertController.addTextField(configurationHandler: nil)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - TableViewDataSourse implementation
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientService.deleteIngredient(index: indexPath.row) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientService.ingredientsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = ingredientService.fetchIngredient(for: indexPath.row)?.name
        
        return cell
    }
    
}
