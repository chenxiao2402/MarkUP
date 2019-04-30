//
//  AlertManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/30.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

extension FileSelectorVC: UITextFieldDelegate {
    
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
    
    @IBAction func showCreateFileAlert(_ sender: Any) {
        showInputAlert(owner: self, okMethod: self.createFile)
    }
    
    @objc func showInputAlert(owner: UIViewController, okMethod: @escaping (UIViewController) -> Void) {
        let title = (owner == self) ? LocalizationKey.InputFileName : LocalizationKey.InputGroupName
        let alert = UIAlertController(
            title: title,
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
                okMethod(owner);
        })
        okAction.isEnabled = false;
        alert.addAction(okAction)
        alert.addAction(.init(
            title: LocalizationKey.Cancel,
            style: .cancel))
        owner.present(alert, animated: true, completion: nil)
    }
}
