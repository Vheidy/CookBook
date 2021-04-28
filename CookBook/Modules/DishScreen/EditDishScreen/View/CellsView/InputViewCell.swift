//
//  StandartViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 17.03.2021.
//

import UIKit

class InputViewCell: UITableViewCell {
    
    var textField: UITextField?

//    static let identifier = "StandartViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setTextField()
        
    }
    
    // Set placeholder for textField
    func configure(with title: String) {
        textField?.placeholder = title
    }
    
    private func setTextField() {
        let textField = UITextField()
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.font = UIFont(name: "Verdana", size: 20)
        textField.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = Constants.margin
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin)
        ])
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
    
        self.textField = textField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
