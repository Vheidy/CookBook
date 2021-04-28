//
//  ImagePickerDelegate.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 05.04.2021.
//

import UIKit

extension EditDishViewController: UIImagePickerControllerDelegate {
    // Show the alert to choose where get photos
    @objc func addPhoto() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        createAction(alert: alertController, type: .camera)
        createAction(alert: alertController, type: .photoLibrary)
        createAction(alert: alertController, type: nil)

        self.present(alertController, animated: true, completion: nil)
    }

    // Create action for choose photo alert
    private func createAction(alert: UIAlertController, type: UIImagePickerController.SourceType?) {
        let action: UIAlertAction
        switch type {
        case .camera:
            action = UIAlertAction(title: "Camera", style: .default) { [unowned self]  _ in
                pickPhoto(type: .camera)
            }
            action.setValue(UIImage(systemName: "camera"), forKey: "image")
            action.setValue(0, forKey: "titleTextAlignment")
        case .photoLibrary:
            action = UIAlertAction(title: "Library", style: .default) { [unowned self]  _ in
                pickPhoto(type: .photoLibrary)
            }
            action.setValue(UIImage(systemName: "photo.on.rectangle"), forKey: "image")
            action.setValue(0, forKey: "titleTextAlignment")
        default:
            action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        }
        alert.addAction(action)
    }

    // Save the photo when the picking did finish
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        self.imageView = image
        tableView.reloadData()
        var path = NSTemporaryDirectory()
        let name = UUID().uuidString + ".jpeg"
        path.append(name)
        editModel.saveImageToDocuments(image: image, withName: name)
        dish.imageName = name
        self.dismiss(animated: true, completion: nil)
    }
    
    // Show the picker according the type
    private func pickPhoto(type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
}
