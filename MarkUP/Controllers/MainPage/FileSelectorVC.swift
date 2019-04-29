//
//  FileSelectorVC.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/28.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class FileSelectorVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var fileList: [(String, String)] = []
    var directory = ProjectKey.DefaultDirectory
    weak var fileNameTextField: UITextField!
    var okAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorKey.LightGray
        fileList = MdFile.loadFiles(inDir: directory)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        setCollectionLayout()
    }
    
    private func setCollectionLayout() {
        let cellNumPerLine: CGFloat = UIDevice().model == "iPad" ? 4 : 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let space: CGFloat = 8
        let width = (view.frame.size.width - space * (cellNumPerLine + 1)) / cellNumPerLine
        let height = width * FileCell.ratio
        layout.itemSize = CGSize(width: Int(width), height: Int(height))
    }
    
    @IBAction func showInputAlert(_ sender: Any) {
        showInputAlert(okMethod: self.createFile)
    }
    
    func createFile() {
        let success = MdFile.createFile(withName: self.fileNameTextField.text!, inDir: self.directory)
        if success {
            fileList = MdFile.loadFiles(inDir: directory)
            collectionView.reloadData()
        } else {
            let alert = UIAlertController(
                title: LocalizationKey.DuplicateFileName.translate(),
                message: "",
                preferredStyle: .alert
            )
            alert.addAction(.init(
                title: LocalizationKey.Yes.translate(),
                style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func editFileName() {
        print(233)
    }
}


extension FileSelectorVC: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! FileCell
        let icon = ImageKey.Markdown
        let fileName = fileList[indexPath.row].0
        let fileTime = fileList[indexPath.row].1
        cell.dirName = self.directory
        cell.drawCell(icon: icon, filName: fileName, fileTime: fileTime)
        cell.enableEditFileName(self)
        return cell
    }
}

extension FileSelectorVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setOkAction(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setOkAction(textField)
    }
    
    private func setOkAction(_ textField: UITextField) {
        let text = textField.text ?? ""
        okAction.isEnabled = !text.isEmpty
    }
    
    @objc func showInputAlert(okMethod: @escaping () -> Void) {
        let alert = UIAlertController(
            title: LocalizationKey.InputFileName.translate(),
            message: "",
            preferredStyle: .alert
        )
        alert.addTextField(configurationHandler: { (textField) in
            textField.delegate = self
            self.fileNameTextField = textField
        })
        okAction = .init(
            title: LocalizationKey.Yes.translate(),
            style: .default,
            handler: { (_) in
                okMethod();
        })
        okAction.isEnabled = false;
        alert.addAction(okAction)
        alert.addAction(.init(
            title: LocalizationKey.Cancel.translate(),
            style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}




