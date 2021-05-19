//
//  StandartViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 17.03.2021.
//

import UIKit

class InputViewCell: UITableViewCell {
    
    var textField: UITextField?
    var mainView: UIView

//    static let identifier = "StandartViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        mainView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Colors.lightPink
        setMainView()
        setTextField()
        
    }
    
    private func setMainView() {
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
//        let num = Int.random(in: 1...100)

        mainView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3 * Constants.margin),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3 * Constants.margin)
        ])
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
        textField.textColor = Colors.textColor
        
        textField.backgroundColor = Colors.lightBlue
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
        self.textField?.layer.borderWidth = 2
        self.textField?.layer.borderColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
