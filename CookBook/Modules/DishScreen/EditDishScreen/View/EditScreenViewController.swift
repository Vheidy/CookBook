//
//  EditScreenTableViewController.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 15.03.2021.
//

import UIKit

class EditDishViewController: UIViewController, UINavigationControllerDelegate {

    var dish: DishModel
    var tableView: UITableView
    var editModel: EditScreenModel
    var imageView: UIImage?
    var isFull: Bool = false
    
    private var saveDish: (_ dish: DishModel)->()
    
    private lazy var logger = CBLogger()

    override func viewDidAppear(_ animated: Bool) {
        logger.printLog("Screen did appear")
    }
    
    // Hightlight cells if they needs to be full
    private var isHightlight = false {
        didSet {
            if isHightlight {
                hightlightCells()
            }
        }
    }
    
    // INIT, saveAction - action for save dish in mainScreen
    init(with model: EditScreenModel, saveAction: @escaping (_ dish: DishModel)->(), whichIsFull dishModel: DishModel?) {
        self.saveDish = saveAction
        self.editModel = model
        if let dish = dishModel {
            self.dish = dish
            isFull = true
            model.setDish(dish)
        } else {
            self.dish = DishModel(id: Date())
        }

        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
        

        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        setTableView()
        setup()
        if isFull {
            updateButtonDone()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Needs to save dish in mainScreen and close editScreen
    @objc func addRecipe() {
        logger.printLog("Tap save button")
        self.saveDish(dish)
        closeScreen()
    }
    
    @objc func closeScreen() {
        logger.printLog("Close screen")
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // Remove selection when text editing is over
    @objc func tapOnTableView() {
        view.endEditing(true)
        
        if editModel.getRowsInSectionCount(section: 2) != 0, editModel.getRowsInSectionCount(section: 3) != 0 {
            updateActions()
            updateIngredients()
        }
        
        isHightlight = true
    }
    
    
    private func updateActions() {
        dish.orderOfAction = []
        for row in 0..<editModel.getRowsInSectionCount(section: 3) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 3)) as? InputViewCell, let text = cell.textField?.text {
                dish.orderOfAction.append(text)
            }
        }
    }
    
    private func updateIngredients() {
        dish.ingredient = []
        for row in 0..<editModel.getRowsInSectionCount(section: 2) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 2)) as? InputViewCell, let text = cell.textField?.text {
                dish.ingredient.append(IngredientModel(name: text, id: UUID().uuidString))
            }
        }
    }
    
    // Present screen with ingredient selection functionality
    @objc func presentChooseIngredientScreen(in _: Int) {
        logger.printLog("Tap add ingredient button")
        let selectViewController = SelectIngredientsViewController(saveCellsAction: addIngredientCells)
        
        navigationController?.pushViewController(selectViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let modelSection = editModel.getSection(section: section)
        if let condition = modelSection?.needsHeader, condition != .notNeeded {
            return 60
        } else {
            return 0
        }
    }
    
    // MARK: - Adding cells in sections
    
    // Adding the cells with one label + updateButtomDone
    private func addIngredientCells(_ models: [IngredientModel]) {
        tableView.beginUpdates()
        for model in models {
            let indexPath = editModel.appEnd(section: 2, ingredient: model)
            tableView.insertRows(at: [indexPath], with: .automatic)
            dish.ingredient.append(model)
        }
        tableView.endUpdates()
        updateButtonDone()
    }
    
    // Adding the cells with one textField, also highlited this cells if needed + updateButtomDone
    func addInputCells(in section: Int) {
        logger.printLog("Tap button adding input cells")
        tableView.beginUpdates()
        let indexPath = editModel.appEnd(section: section, ingredient: nil)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        if isHightlight {
            guard let cell = tableView.cellForRow(at: indexPath) as? InputViewCell else { return }
            addBorder(for: cell)
        }
        updateButtonDone()
    }
    
    // MARK: - All about highlighted cells
    
    // Check can the done button be enabled
    func updateButtonDone() {
        if !checkMainFields {
            isHightlight = true
            navigationItem.rightBarButtonItem?.isEnabled = false
//            createDish()
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // Check if the required cells are filled (Name, Type, Ingredients, Actions)
    private var checkMainFields: Bool {
        var flag = true
        for sectionNum in 1...3 {
            let rows = editModel.getRowsInSection(section: sectionNum)
            if sectionNum == 2, rows.isEmpty {
                flag = false
                break
            }
            for row in rows.indices {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: sectionNum)) as? InputViewCell,
                   let textCell = cell.textField?.text, textCell.isEmpty {
                    flag = false
                    break
                }
            }
        }
        return flag
    }
    
    // Highlights some of required cells if they have not been filled
    private func hightlightCells() {
        for sectionNum in 1...3 {
            let rows = editModel.getRowsInSection(section: sectionNum)
            for row in rows.indices {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: sectionNum)) as? InputViewCell,
                   let textCell = cell.textField?.text, textCell.isEmpty {
                    addBorder(for: cell)
                }
            }
        }
    }
  
    private func addBorder(for cell: InputViewCell) {
        cell.textField?.layer.borderWidth = 2
        cell.textField?.layer.borderColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2).cgColor
    }
    
    // MARK: - Setup
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setup() {
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.backgroundColor = Colors.lightPink
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnTableView)))
        
        configureNavigationItem()
        addRegister()
    }

    private func configureNavigationItem() {
        self.navigationItem.title = "Edit"
        self.navigationController?.navigationBar.barTintColor = Colors.lightPink
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                                              target: self, action: #selector(self.addRecipe)), animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                                             target: self, action: #selector(closeScreen)), animated: true)
    }

    private func addRegister() {
        tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.register(ImageEditCell.self, forCellReuseIdentifier: "ImageEditCell")
        tableView.register(InputViewCell.self, forCellReuseIdentifier: "InputViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
