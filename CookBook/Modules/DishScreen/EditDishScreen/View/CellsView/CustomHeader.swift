//
//  CustomHeader.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 18.03.2021.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    var title: UILabel?
    var addButton: UIButton?
    var section: Int?
    var mainSubView: UIView?
    
    // Adding custom cells in section in EditController
    var action: VoidCallback
    
    init(title: String, section: Int, addCells: @escaping VoidCallback) {
        self.action = addCells
        super.init(reuseIdentifier: nil)
        configureContent()
        self.title?.text = title
        self.section = section
    }
    
    private func configureContent() {
        let mainSubView = UIView()
        
        let title = UILabel()
        let addButton = UIButton()
        
        mainSubView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .clear
        mainSubView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        contentView.addSubview(mainSubView)
        mainSubView.addSubview(title)
        mainSubView.addSubview(addButton)
        
        title.font = UIFont(name: "Verdana", size: 20)
        title.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        setConstraints(mainSubView: mainSubView, title: title, addButton: addButton)
        
        self.title = title
        self.addButton = addButton
    }
    
    private func setConstraints(mainSubView: UIView, title: UILabel, addButton: UIButton) {
        NSLayoutConstraint.activate([
            mainSubView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            mainSubView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainSubView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainSubView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
  
            title.topAnchor.constraint(equalTo: mainSubView.topAnchor, constant: Constants.margin),
            title.leadingAnchor.constraint(equalTo: mainSubView.leadingAnchor, constant: Constants.margin),
            title.bottomAnchor.constraint(equalTo: mainSubView.bottomAnchor, constant: -Constants.margin),
            
            addButton.topAnchor.constraint(equalTo: mainSubView.topAnchor, constant: Constants.margin),
            addButton.bottomAnchor.constraint(equalTo: mainSubView.bottomAnchor, constant: -Constants.margin),
            addButton.trailingAnchor.constraint(equalTo: mainSubView.trailingAnchor, constant: -Constants.margin),
            addButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // Action for add cell in section of EditController
    @objc func didTap() {
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
