//
//  MainScreenTableViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 15.03.2021.
//

import UIKit
import CoreData


class MainScreenTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var dishService = DishService(dishes: [], completion: nil)
    var indexPath: IndexPath?
    
    private lazy var logger = CBLogger()

    override func viewDidAppear(_ animated: Bool) {
        logger.printLog("Screen did appear")
    }
    
    init(with dishes: [DishModel]) {
        super.init(nibName: nil, bundle: nil)
        dishService = DishService(dishes: dishes, completion: { [weak self] in
            self?.tableView.reloadData()
        })
//        self.dishService.updateScreen = tableView.reloadData
        self.dishService.fetchController.delegate = self

        setup()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        presentEditScreen()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        self.indexPath = nil
    }
    
    private func setup() {
        navigationItem.title = "CookBook"

        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add , target: self, action: #selector(presentEditScreen))
        addButton.accessibilityLabel = "Add new dish"
        navigationItem.setRightBarButton(addButton, animated: true)
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    // Add dish to the model
    func addDish(_ dish: DishModel) {
        dishService.addDish(dish: dish, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    // Create and present EditScreen
    @objc func presentEditScreen() {
        logger.printLog("Tap create or edit dish button")
        var editScreen: EditDishViewController
        if let index = self.indexPath {
            editScreen = EditDishViewController(with: EditScreenModel(), saveAction: self.addDish(_:), whichIsFull: dishService.fetchDish(for: index))
        } else {
            editScreen = EditDishViewController(with: EditScreenModel(), saveAction: self.addDish(_:), whichIsFull: nil)
        }
        let navigationController = UINavigationController(rootViewController: editScreen)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - TableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightCell
    }
    
    // MARK: - TableViewDataSource implementation
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dishService.deleteRows(indexPath: indexPath) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        dishService.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishService.rowsInSections(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainScreenTableViewCell else {return UITableViewCell() }
        cell.dishImage?.image = UIImage(named: "dish")
        if let item = dishService.getFields(for: indexPath) {
            cell.nameLabel?.text = item.name
            cell.dishTypeLabel?.text = item.type
            // FIXME: Change this
            cell.dishImage?.image = item.image ?? UIImage(named: "dish")
            cell.isAccessibilityElement = true
            cell.accessibilityHint = "You can tap and see more information"
        }
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
