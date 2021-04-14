//
//  SelectTableViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 30.03.2021.
//

import UIKit

class SelectTableViewCell: UITableViewCell {
    
    var title: UILabel?
    var selectButton: UIButton?
    var id: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContent() {
        let title = UILabel()
        let selectButton = UIButton()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(selectButton)
        
        
        title.font = UIFont(name: "Verdana", size: 20)
        title.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        selectButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        selectButton.isHidden = true
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin),
            
            selectButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            selectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin),
            selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
            selectButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        self.title = title
        self.selectButton = selectButton
    }

    // Implement logic for show which cells are selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let buttonHidden = selectButton else {return}
        
        if isSelected, buttonHidden.isHidden {
            selectButton?.isHidden = false
        } else if  isSelected, !buttonHidden.isHidden {
            selectButton?.isHidden = true
        }
    }
    

}
