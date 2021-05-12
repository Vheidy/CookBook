//
//  TableViewDelegate.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 05.04.2021.
//

import UIKit

extension EditDishViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - TableViewDelegate implementation
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = editModel.getSection(section: section), let sectionTitle = editModel.getTitleSection(section: section) else { return nil }
        
        switch cell.needsHeader {
        case .need(let title):
            let headerView: CustomHeader
            if sectionTitle == "Ingredients", TabBarViewController.extraFunctionality {
                headerView = CustomHeader(title: title, section: section, addCells: presentChooseIngredientScreen)
            } else {
                headerView = CustomHeader(title: title, section: section, addCells: addInputCells)
            }
            return headerView
        default:
            return nil
        }
    }
    
    // MARK: - TableViewDataSourse implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return editModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editModel.getRowsInSectionCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if editModel.checkDeleting(indexPath: indexPath) {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = ""
                tableView.deleteRows(at: [indexPath], with: .fade)
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
            if let name = dish.imageName {
                let path = editModel.getNewDocumentPath(with: name)
                do {
                    let data = try Data(contentsOf: path)
                    cell.imageDish?.image = UIImage(data: data)
                } catch {
                    print(error)
                }
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
        case "Action":
            dish.orderOfAction.append(textField.text ?? "")
        default:
            break
        }
        updateButtonDone()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
}
