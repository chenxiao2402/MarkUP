//
//  ImageAlert.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

extension ImageSelectorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(
            title: LocalizationKey.InputImageName,
            message: "",
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: { (textField) in
            textField.delegate = self
            self.inputTextField = textField
        })
        okAction = .init(
            title: LocalizationKey.Yes,
            style: .default,
            handler: { (_) in
                self.addImage(selectedImage)
        })
        okAction.isEnabled = false;
        alert.addAction(okAction)
        alert.addAction(.init(
            title: LocalizationKey.Cancel,
            style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}

extension ImageSelectorVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        okAction.isEnabled = !((text.lengthOfBytes(using: .utf8) == 1) && (range.length == 1))
        return true
    }
    
    func addImage(_ image: UIImage) {
        let success = imageManager.addImage(inputTextField.text!, image: image)
        if success {
            imageList = imageManager.loadImages()
            tableView.reloadData()
            resetSize()
        } else {
            let alert = UIAlertController(
                title: LocalizationKey.DuplicateImageName,
                message: "",
                preferredStyle: .alert
            )
            alert.addAction(.init(
                title: LocalizationKey.Yes,
                style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
}
