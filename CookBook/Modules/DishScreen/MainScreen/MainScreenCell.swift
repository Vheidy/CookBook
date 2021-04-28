//
//  MainScreenTableViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 16.03.2021.
//

import UIKit

struct Constants {
    struct Image {
        static let width: CGFloat = Constants.heightCell - 2 * Constants.margin
        static let cornerRaduis: CGFloat = Constants.Image.width / 2
    }
    
    struct LabelParameters {
        static let backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        static let cornerRadius: CGFloat = 5
        static let topOffset = 15
        static let textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        struct Font {
            static let fontName = UIFont(name: "Verdana", size: Constants.heightCell * 0.2)
            static let fontType = UIFont(name: "Verdana", size: Constants.heightCell * 0.15)
        }
    }
    static let margin: CGFloat = 10
    static let heightCell: CGFloat = 100
}

class MainScreenTableViewCell: UITableViewCell {

    var dishImage: UIImageView?
    var nameLabel: UILabel?
    var dishTypeLabel: UILabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setImageConstraints()
        setLabelConstraints()
    }

    private func setLabelConstraints() {
        let name = UILabel()
        let dishType = UILabel()

        contentView.addSubview(name)
        contentView.addSubview(dishType)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        dishType.translatesAutoresizingMaskIntoConstraints = false

        name.font = Constants.LabelParameters.Font.fontName
        dishType.font = Constants.LabelParameters.Font.fontType
        
        name.backgroundColor = Constants.LabelParameters.backgroundColor
        dishType.backgroundColor = Constants.LabelParameters.backgroundColor

        name.numberOfLines = 2
        dishType.numberOfLines = 1

        name.textColor = Constants.LabelParameters.textColor
        dishType.textColor = Constants.LabelParameters.textColor
        name.layer.cornerRadius = Constants.LabelParameters.cornerRadius
        dishType.layer.cornerRadius = Constants.LabelParameters.cornerRadius
        name.layer.masksToBounds = true
        dishType.layer.masksToBounds = true
        
        if dishImage != nil {
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 18),
                name.leadingAnchor.constraint(equalTo: dishImage!.trailingAnchor, constant: Constants.margin),
                name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
                dishType.topAnchor.constraint(equalTo: name.bottomAnchor, constant: Constants.margin),
                dishType.leadingAnchor.constraint(equalTo: dishImage!.trailingAnchor, constant: Constants.margin)
            ])
        }
                
        self.nameLabel = name
        self.dishTypeLabel = dishType
    }
    
    private func setImageConstraints() {
        let imageDish = UIImageView()
        contentView.addSubview(imageDish)
        imageDish.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageDish.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            imageDish.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin),
            imageDish.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
            imageDish.widthAnchor.constraint(equalToConstant: Constants.Image.width)
        ])
        imageDish.layer.cornerRadius = Constants.Image.cornerRaduis
        imageDish.layer.masksToBounds = true
        
        self.dishImage = imageDish
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
