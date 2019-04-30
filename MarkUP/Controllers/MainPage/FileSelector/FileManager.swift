//
//  FileManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/30.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

extension FileSelectorVC {
    
    func createFile(alertOwner: UIViewController) {
        let success = MdFile.createFile(withName: inputTextField.text!, inGroup: currentGroup)
        if success {
            fileList = MdFile.loadFiles(inGroup: currentGroup)
            collectionView.reloadData()
        } else {
            let alert = UIAlertController(
                title: LocalizationKey.DuplicateFileName,
                message: "",
                preferredStyle: .alert
            )
            alert.addAction(.init(
                title: LocalizationKey.Yes,
                style: .default))
            alertOwner.present(alert, animated: true, completion: nil)
        }
    }
    
    func renameFile(alertOwner: UIViewController) {
        let success = MdFile.renameFile(withName: fileName, inGroup: currentGroup, newFileName: inputTextField.text!)
        if success {
            fileList = MdFile.loadFiles(inGroup: currentGroup)
            collectionView.reloadData()
        } else {
            let alert = UIAlertController(
                title: LocalizationKey.DuplicateFileName,
                message: "",
                preferredStyle: .alert
            )
            alert.addAction(.init(
                title: LocalizationKey.Yes,
                style: .default))
            alertOwner.present(alert, animated: true, completion: nil)
        }
    }
}
