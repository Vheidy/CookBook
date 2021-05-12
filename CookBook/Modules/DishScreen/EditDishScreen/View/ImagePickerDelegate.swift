//
//  ImagePickerDelegate.swift
//  CookBook
//
//  Created by OUT-Salyukova-PA on 05.04.2021.
//

import UIKit
import PhotosUI

extension EditDishViewController:  PHPickerViewControllerDelegate {
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
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        guard let image = info[.originalImage] as? UIImage else {return}
//        self.imageView = image
//        tableView.reloadData()
//        var path = NSTemporaryDirectory()
//        let name = UUID().uuidString + ".jpeg"
//        path.append(name)
//        editModel.saveImageToDocuments(image: image, withName: name)
//        dish.imageName = name
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
    
        
        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                
                provider.loadObject(ofClass: UIImage.self) { [unowned self] (image, error) in
                    guard error == nil, let currentImage = image as? UIImage, let data = currentImage.pngData() else { return }
                    self.imageView = currentImage
                    let name = UUID().uuidString + ".jpeg"
                    let dataManager = DataFileManager()
                    dataManager.saveDataToDocuments(data: data, withName: name)
                    dish.imageName = name
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
        
//        guard let image = info[.originalImage] as? UIImage else {return}
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    // Show the picker according the type
    private func pickPhoto(type: UIImagePickerController.SourceType) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] _ in
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .any(of: [.images])
            let imagePicker = PHPickerViewController(configuration: config)
            imagePicker.delegate = self
            
            //        let imagePicker = UIImagePickerController()
            //        imagePicker.delegate = self
            //        imagePicker.sourceType = type
            //        imagePicker.allowsEditing = true
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}
