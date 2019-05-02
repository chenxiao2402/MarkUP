//
//  MdEditor.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class MdEditor: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    var fileName: String!
    var groupName: String!
    var imageManager: ImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = fileName
        inputTextView.text = MarkdownManager.readFile(withName: fileName, inGroup: groupName)
        imageManager = ImageManager(groupName: groupName, fileName: fileName)
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: UIApplication.shared,
            queue: OperationQueue.main,
            using: { _ in
                MarkdownManager.saveFile(withName: self.fileName, inGroup: self.groupName, content: self.inputTextView.text)
                HtmlManager.saveAsHtml(withName: self.fileName, inGroup: self.groupName)
        })
    }

    @IBAction func quit(_ sender: UIBarButtonItem) {
        MarkdownManager.saveFile(withName: fileName, inGroup: groupName, content: inputTextView.text)
        HtmlManager.saveAsHtml(withName: self.fileName, inGroup: self.groupName)
        dismiss(animated: true, completion: nil)
    }
}


extension MdEditor: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? "") {
        case StoryboardKey.ShowImageSelector:
            let navigation = segue.destination as! UINavigationController
            let imageSelectorVC = navigation.viewControllers.first as! ImageSelectorVC
            let popoverController = navigation.popoverPresentationController
            imageSelectorVC.mdEditor = self
            popoverController?.delegate = self
        case StoryboardKey.ShowMdViewer:
            MarkdownManager.saveFile(withName: fileName, inGroup: groupName, content: inputTextView.text)
            HtmlManager.saveAsHtml(withName: self.fileName, inGroup: self.groupName)
            let mdViewer = segue.destination as! MdViewer
            mdViewer.groupName = groupName
            mdViewer.fileName = fileName
        default:
            return
        }
    }
}

