//
//  SearchResultViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 09.04.2021.
//

import UIKit

class SearchResultViewCell: UICollectionViewCell {
    var imageDish: UIImageView
    var label: UILabel
    
    override init(frame: CGRect) {
        imageDish = UIImageView()
        label = UILabel()
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        let stackView = UIStackView(arrangedSubviews: [imageDish, label])
        contentView.addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.backgroundColor = #colorLiteral(red: 0.9332640171, green: 0.9333797693, blue: 0.9371676445, alpha: 1)
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true

        imageDish.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        label.numberOfLines = 0
        label.textAlignment = .center
        imageDish.layer.cornerRadius = 10
        imageDish.layer.masksToBounds = true
        
        label.font = UIFont(name: "Kohinoor Telugu", size: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, title: String) {
        imageDish.image = image
        
        label.text = title
    }
}
