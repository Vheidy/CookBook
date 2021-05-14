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
        super.viewDidAppear(animated)
        logger.printLog("Screen did appear")
    }
    
    init(with dishes: [DishModel]) {
        super.init(nibName: nil, bundle: nil)
        dishService = DishService(dishes: dishes, completion: { [weak self] in
            self?.tableView.reloadData()
        })
        
        self.dishService.fetchController.delegate = self
        tableView.separatorStyle = .none
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = Colors.main
//        self.navigationController?.navigationBar.set
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
//        
//        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
//        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Bold", size: 20), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1788931489, green: 0.2340304255, blue: 0.3876610994, alpha: 1) ]
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
        
        view.backgroundColor = Colors.main
        

        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(presentEditScreen))
        addButton.accessibilityLabel = "Add new dish"
        navigationItem.setRightBarButton(addButton, animated: true)
        tableView.register(MainScreenTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // Add dish to the model
    func addDish(_ dish: DishModel) {
        dishService.addDish(dish: dish, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    func updateDish(_ dish: DishModel) {
        dishService.updateDish(dish, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }
    
    // Create and present EditScreen
    @objc func presentEditScreen() {
        logger.printLog("Tap create or edit dish button")
        var editScreen: EditDishViewController
        if let index = self.indexPath {
            editScreen = EditDishViewController(with: EditScreenModel(), saveAction: self.updateDish(_:), whichIsFull: dishService.fetchDish(for: index))
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? MainScreenTableViewCell
        else {return UITableViewCell() }
        cell.dishImage?.image = UIImage(named: "dish")
        if let item = dishService.getFields(for: indexPath) {
            cell.nameLabel?.text = item.name
            cell.dishTypeLabel?.text = "\(item.ingrediensCount) ingredients"
            cell.dishImage?.image = item.image ?? UIImage(named: "dish")
            cell.isAccessibilityElement = true
            cell.accessibilityHint = "You can tap and see more information"
            if indexPath.row % 2 == 0 {
                cell.isEven = true
            } else {
                cell.isEven = false
            }
        }
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
