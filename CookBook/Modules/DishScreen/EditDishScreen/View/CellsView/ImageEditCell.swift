//
//  ImageEditCell.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 17.03.2021.
//

import UIKit

struct Parameters {
    struct image {
        static let height: CGFloat = 100
        static let topMargin: CGFloat = 40
    }
    struct button {
        static let topMardin: CGFloat = 10
    }
}



class ImageEditCell: UITableViewCell {
    
    var editButton: UIButton?
    var imageDish: UIImageView?
    var addPhoto: (() -> ())?
    
//    static let identifier = "ImageEditCell"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.8979603648, green: 0.8980897069, blue: 0.8979321122, alpha: 1)
        setImage()
        setButton()
    }
    
    private func setButton() {
        let editButton = UIButton()
        
        contentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        editButton.setTitle("Add photo", for: .normal)
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "Verdana", size: 15)
        
        guard let image = imageDish else {
            return
        }
        
        NSLayoutConstraint.activate([
            editButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Parameters.button.topMardin),
            editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.margin
            )
        ])
        
        editButton.addAction(UIAction(handler: { [unowned self] action in
            self.addPhoto?()
        }), for: .touchUpInside)
        
        self.editButton = editButton
    }
    
    private func setImage() {
//        let imageDish = self.imageDish ?? UIImageView(image: UIImage(named: "plate"))

        let imageDish = UIImageView()
        contentView.addSubview(imageDish)
        imageDish.translatesAutoresizingMaskIntoConstraints = false
        
        imageDish.layer.cornerRadius = Parameters.image.height / 2
        imageDish.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageDish.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageDish.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Parameters.image.topMargin),
            imageDish.widthAnchor.constraint(equalToConstant: Parameters.image.height),
            imageDish.heightAnchor.constraint(equalToConstant: Parameters.image.height)
        ])
        
        self.imageDish = imageDish
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
