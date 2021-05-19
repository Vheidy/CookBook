//
//  TableViewDelegate.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 05.04.2021.
//

import UIKit

extension EditDishViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableViewDelegate implementation
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 60
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currenSection = editModel.getSection(section: section), let sectionTitle = editModel.getTitleSection(section: section) else { return nil }
        
        switch currenSection.needsHeader {
        case .need(let title):
            let headerView: CustomHeader
            if sectionTitle == "Ingredients", ExtraFunctionality.enabled {
                headerView = CustomHeader(title: title, section: section, addCells: presentChooseIngredientScreen)
            } else {
                headerView = CustomHeader(title: title, section: section, addCells: addInputCells)
            }
            return headerView
        default:
            let standartView = UIView()
            standartView.backgroundColor = Colors.lightPink
            return standartView
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        guard let currenSection = editModel.getSection(section: section), let sectionTitle = editModel.getTitleSection(section: section) else { return 0 }
//
//        if section == 0 || section == 1 ||  currenSection.needsHeader != .notNeeded {
//            return UITableView.automaticDimension
//        } else {
//            return 0
//        }
//    }
    
    // MARK: - TableViewDataSourse implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return editModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editModel.getRowsInSectionCount(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {[unowned editModel, unowned self]  _,_,_ in
            if editModel.checkDeleting(indexPath: indexPath) {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = ""
                switch indexPath.section {
                case 2:
                    if dish.ingredient.indices.contains(indexPath.row) {
                        self.dish.ingredient.remove(at: indexPath.row)
                    }
                case 3:
                    if dish.orderOfAction.indices.contains(indexPath.row) {
                    self.dish.orderOfAction.remove(at: indexPath.row)
                    }
                default:
                    break
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.updateButtonDone()
            }
        })

//            deleteAction.image = UIImage(named: "trash.png")
        deleteAction.backgroundColor = Colors.cellsPink
            return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editModel.checkDeleting(indexPath: indexPath) {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = ""
                switch indexPath.section {
                case 2:
                    if dish.ingredient.indices.contains(indexPath.row) {
                        self.dish.ingredient.remove(at: indexPath.row)
                    }
                case 3:
                    if dish.orderOfAction.indices.contains(indexPath.row) {
                        self.dish.orderOfAction.remove(at: indexPath.row)
                    }
                default:
                    break
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                updateButtonDone()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = editModel.getRow(for: indexPath) else {
            return UITableViewCell()
        }
        
        switch row {
        case .image:
            let cell = ImageEditCell()
            let dataManager = DataFileManager()
            if let name = dish.imageName, let data = dataManager.read(fromDocumentsWithFileName: name)  {
                cell.imageDish?.image = UIImage(data: data)
            } else {
                cell.imageDish?.image = UIImage(named: "plate")
            }
            cell.addPhoto = self.addPhoto
            return cell
        case .inputItem(let placeholder, let inputedText):
            return createInputItem(placeholder: placeholder, indexPath: indexPath, inputedText: inputedText)
        case .labelItem(let title):
            return createLabelItem(title: title, indexPath: indexPath)
            
        }
    }
    
    private func createLabelItem(title: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont(name: "Verdana", size: 20)
        cell.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return cell
    }
    
    private func createInputItem(placeholder: String, indexPath: IndexPath, inputedText: String?) -> InputViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InputViewCell",
                                                       for: indexPath) as? InputViewCell else { return InputViewCell() }
        
        cell.configure(with: placeholder)
        if isFull {
            cell.textField?.text = inputedText ?? ""
        }
        cell.textField?.delegate = self
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
}

extension EditDishViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Dish Name":
            dish.name = textField.text ?? ""
        case "Dish Type":
            dish.typeDish = textField.text ?? ""
        case "Cuisine":
            dish.cuisine = textField.text ?? ""
        case "Calories":
            dish.calories = Int32(textField.text ?? "") ?? 0
        default:
            break
        }
        updateButtonDone()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
}
