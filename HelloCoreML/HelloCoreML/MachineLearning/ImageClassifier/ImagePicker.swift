//
//  ImagePicker.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/16.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI

final class ImagePickerCoordinator: NSObject {
    @Binding var image: UIImage?
    @Binding var takePhoto: Bool
    
    init(image: Binding<UIImage?>, takePhoto: Binding<Bool>) {
        _image = image
        _takePhoto = takePhoto
    }
}

struct ShowImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var image: UIImage?
    @Binding var takePhoto: Bool
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(image: $image, takePhoto: $takePhoto)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShowImagePicker>) -> ShowImagePicker.UIViewControllerType {
        let pickerControoler = UIImagePickerController()
        pickerControoler.delegate = context.coordinator
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return pickerControoler
        }
        
        switch self.takePhoto {
        case true:
            pickerControoler.sourceType = .camera
        case false:
            pickerControoler.sourceType = .photoLibrary
        }
        
        pickerControoler.allowsEditing = true
        
        return pickerControoler
    }
    
    func updateUIViewController(_ uiViewController: ShowImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ShowImagePicker>) {
        
    }
}


extension ImagePickerCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage]  as? UIImage else {
            return
        }
        
        self.image = uiImage
        picker.dismiss(animated: true)
    }
}
