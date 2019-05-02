//
//  FileEditor.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/1.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

extension FileSelectorVC {
    @objc func handleEditButton() {
        isEditing ? quitEditMode() : enterEditMode()
    }
    
    func enterEditMode() {
        isEditing = true
        let trash = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(FileSelectorVC.removeFiles))
        trash.tintColor = .red
        leftBarItems = navigationItem.leftBarButtonItems!
        navigationItem.leftBarButtonItems?.removeAll()
        navigationItem.leftBarButtonItem = trash
    }
    
    func quitEditMode() {
        isEditing = false
        navigationItem.leftBarButtonItems = leftBarItems
        for cell in collectionView.visibleCells {
            let fileCell = cell as? FileCell
            fileCell!.isSelectedByUser = false
        }
    }
    
    @objc func removeFiles() {
        var filesToRemove: [String] = []
        for cell in collectionView.visibleCells {
            let fileCell = cell as? FileCell
            if fileCell!.isSelectedByUser {
                filesToRemove.append(fileCell!.fileName)
            }
        }
        MarkdownManager.removeFiles(fileList: filesToRemove, inGroup: currentGroup)
        fileList = MarkdownManager.loadFiles(inGroup: currentGroup)
        collectionView.reloadData()
    }
}
