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
    @IBOutlet weak var directorySelector: UIBarButtonItem!
    var fileList: [(String, String)] = []
    weak var inputTextField: UITextField!
    var okAction: UIAlertAction!
    var fileName: String = ""
    var currentGroup: String! {
        didSet {
            navigationItem.title = currentGroup
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorKey.LightGray
        currentGroup = FileSystemKey.DefaultGroup
        fileList = MdFile.loadFiles(inGroup: currentGroup)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        setCollectionLayout()
    }
}


extension FileSelectorVC: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    private func setCollectionLayout() {
        let cellNumPerLine: CGFloat = UIDevice().model == "iPad" ? 4 : 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let space: CGFloat = 8
        let width = (view.frame.size.width - space * (cellNumPerLine + 1)) / cellNumPerLine
        let height = width * FileCell.ratio
        layout.itemSize = CGSize(width: Int(width), height: Int(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! FileCell
        let icon = ImageKey.Markdown
        let fileName = fileList[indexPath.row].0
        let fileTime = fileList[indexPath.row].1
        cell.fileSelectorVC = self
        cell.drawCell(icon: icon, filName: fileName, fileTime: fileTime)
        cell.enableEditFileName()
        return cell
    }
}


