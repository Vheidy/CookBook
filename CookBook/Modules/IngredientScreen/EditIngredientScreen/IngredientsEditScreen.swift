//
//  IngredientsEditScreen.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 22.03.2021.
//

import UIKit
import CoreData
//
//class IngredientEditTableViewController: UITableViewController, UITextFieldDelegate {
//    
//    var model = IngredientEditModel()
//    var ingredient: IngredientModel?
//    
//    lazy var ingredientService = IngredientsService()
//    
//    var mainScreen: IngredientScreenTableViewController?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//        setup()
//    }
//    
//    private func setup() {
//        navigationItem.title = "Edit"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addIngredient))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeScreen))
//        
//        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnScreen)))
//        
//        navigationItem.rightBarButtonItem?.isEnabled = false
//        
//        tableView.register(StandartViewCell.self, forCellReuseIdentifier: "StandartViewCell")
//    }
//    
//    @objc func tapOnScreen() {
//        view.endEditing(true)
//        
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//         model.sectionCount()
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let number = model.rowCount(in: section) {
//            return number
//        }
//        return 0
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text, !text.isEmpty {
//            ingredient = IngredientModel(name: text, id: UUID().uuidString)
//            navigationItem.rightBarButtonItem?.isEnabled = true
//        } else {
//            navigationItem.rightBarButtonItem?.isEnabled = false
//        }
//    }
//    
//    
//    @objc private func addIngredient() {
//        if let newIngredient = ingredient {
//            ingredientService.addIngredient(newIngredient, completion: nil)
//        }
//        closeScreen()
//    }
//    
//    @objc private func closeScreen() {
//        navigationController?.dismiss(animated: true, completion: nil)
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard model.array.indices.contains(indexPath.section) else { return UITableViewCell() }
//        let section = model.array[indexPath.section]
//        guard section.items.indices.contains(indexPath.row) else { return UITableViewCell() }
//        let row = section.items[indexPath.row]
//        
//        switch row {
//        case .inputItem(let placeholder, _):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StandartViewCell", for: indexPath) as? StandartViewCell else { return StandartViewCell() }
//            
//            cell.configure(with: placeholder)
//            cell.textField?.delegate = self
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            return cell
//        default:
//            break
//        }
//        
//        return UITableViewCell()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
