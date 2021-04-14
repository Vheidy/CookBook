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
    

    
    func setup()
    {
        contentView.addSubview(imageDish)
        contentView.addSubview(label)
        
        contentView.backgroundColor = #colorLiteral(red: 0.9332640171, green: 0.9333797693, blue: 0.9371676445, alpha: 1)
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true

        imageDish.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
//        imageDish.isUserInteractionEnabled = false
//        label.isUserInteractionEnabled = false
        
        label.numberOfLines = 0
        label.textAlignment = .center
        imageDish.layer.cornerRadius = 40
        imageDish.layer.masksToBounds = true
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageDish.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            imageDish.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageDish.widthAnchor.constraint(equalToConstant: 100),
            imageDish.heightAnchor.constraint(equalToConstant: 100),
            label.topAnchor.constraint(equalTo: imageDish.bottomAnchor, constant: Constants.margin),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -Constants.margin)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, title: String) {
        imageDish.image = image
        
        label.text = title
    }
}
