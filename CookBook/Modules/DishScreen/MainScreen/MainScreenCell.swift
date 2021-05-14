//
//  MainScreenTableViewCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 16.03.2021.
//

import UIKit

enum Constants {
    enum Image {
        static let height: CGFloat = Constants.heightCell - 2 * Constants.margin
        static let cornerRaduis: CGFloat = Constants.Image.height / 2 - 10
    }
    
    enum LabelParameters {
        static let backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        static let cornerRadius: CGFloat = 5
        static let topOffset = 15
        static let textColor = #colorLiteral(red: 0.1786063015, green: 0.2343459725, blue: 0.3751766086, alpha: 1)
        enum Font {
            static let fontName = UIFont(name: "Helvetica Bold", size: Constants.heightCell * 0.2)
            static let fontType = UIFont(name: "Verdana", size: Constants.heightCell * 0.15)
        }
    }
    static let margin: CGFloat = 10
    static let heightCell: CGFloat = 120
}

enum Colors {
    static let main = #colorLiteral(red: 0.8409824967, green: 0.9568938613, blue: 0.9243165851, alpha: 1)
    static let cellsGreen = #colorLiteral(red: 0.6720742583, green: 0.8773115277, blue: 0.7998310924, alpha: 1)
    static let cellsPink = #colorLiteral(red: 0.9380218387, green: 0.7540807128, blue: 0.7400147319, alpha: 1)
    static let textColor = #colorLiteral(red: 0.1788931489, green: 0.2340304255, blue: 0.3876610994, alpha: 1)
    static let lightPink = #colorLiteral(red: 0.9244260192, green: 0.8318447471, blue: 0.8198770881, alpha: 1)
    static let lightBlue = #colorLiteral(red: 0.7655597925, green: 0.9119005799, blue: 0.9162506461, alpha: 1)
}

class MainScreenTableViewCell: UITableViewCell {

    var dishImage: UIImageView?
    var nameLabel: UILabel?
    var dishTypeLabel: UILabel?
    var isEven: Bool = false {
        didSet {
            if isEven {
                mainView.backgroundColor = Colors.cellsGreen
            } else {
                mainView.backgroundColor = Colors.cellsPink
            }
        }
    }
    private(set) var mainView: UIView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
//        contentView.backgroundColor = #colorLiteral(red: 0.7450413108, green: 0.950304091, blue: 0.7759206891, alpha: 1)
        mainView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Colors.main
        
        setMainView()
        
        setImageConstraints()
        setLabelConstraints()
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
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3 * Constants.margin),
        ])
    }

    private func setLabelConstraints() {
        let name = UILabel()
        let dishType = UILabel()

        contentView.addSubview(name)
        contentView.addSubview(dishType)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        dishType.translatesAutoresizingMaskIntoConstraints = false


        name.font = Constants.LabelParameters.Font.fontName
//        name.font =
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
                name.topAnchor.constraint(lessThanOrEqualTo: mainView.topAnchor, constant: 18),
                name.leadingAnchor.constraint(equalTo: dishImage!.trailingAnchor, constant: 2*Constants.margin),
                name.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Constants.margin),
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
            imageDish.topAnchor.constraint(equalTo: mainView.topAnchor, constant: Constants.margin),
            imageDish.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -Constants.margin),
            imageDish.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Constants.margin),
            imageDish.widthAnchor.constraint(equalToConstant: Constants.Image.height)
        ])
        imageDish.layer.cornerRadius = Constants.Image.cornerRaduis
        imageDish.layer.masksToBounds = true
        
        self.dishImage = imageDish
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
