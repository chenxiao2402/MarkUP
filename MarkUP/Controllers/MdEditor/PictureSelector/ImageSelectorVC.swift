//
//  ImageSelector.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class ImageSelectorVC: UITableViewController {
    
    var imageManager: ImageManager!
    var imageList: [String] = []
    var mdEditor: MdEditor!
    
    weak var inputTextField: UITextField!
    var okAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageManager = mdEditor.imageManager
        imageList = imageManager.loadImages()
        navigationItem.title = LocalizationKey.Image
        resetSize()
    }
    
    func resetSize() {
        navigationController!.preferredContentSize = CGSize(width: 200, height: min(imageList.count * 48, 280))
    }
    
    @IBAction func showImagePicker(_ sender: Any) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ImageSelectorVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardKey.ImageSelectorCell, for: indexPath) as! ImageSelectorCell
        cell.imageName = imageList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = imageList[indexPath.row]
        mdEditor.inputTextView.insertText("\n![](\(image))\n")
        dismiss(animated: true, completion: nil)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            imageManager.removeImage(imageList[indexPath.row])
            imageList = imageManager.loadImages()
            tableView.reloadData()
            resetSize()
        }
    }
}


