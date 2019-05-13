//
//  FileCell.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/28.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class FileCell: UICollectionViewCell {
    
    static let ratio: CGFloat = 1.2  // 高度 / 宽度的比例
    var iconView = UIImageView()  // 绘制的图像（奖杯/植物），位于圆形的中间
    var touchLabel: UIView!   // 用于管理下面两个label的点击事件的
    var fileNameLabel = UILabel()  // 展示你设置的文字，位于圆形的下方
    var fileTimeLabel = UILabel()  // 展示你设置的文字，位于圆形的下方
    var icon: UIImage!  // 在iconView中要画的图像
    var fileName: String!  // fileNameLabel中的文字
    var fileTime: String!  // fileNameLabel中的文字
    var fileSelectorVC: FileSelectorVC! // 对应的fileSelector
    var isSelectedByUser = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawIconView()
        drawFileNameLabel()
        drawFileTimeLabel()
        if isSelectedByUser {
            layer.borderWidth = 2.0;
            layer.borderColor = ColorKey.Orange.cgColor
            layer.opacity = 0.7
        } else {
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.clear.cgColor
            layer.opacity = 1.0
        }
    }
    
    func drawIconView() {
        let sideLength = frame.size.width * 0.75
        let drawCenter = CGPoint(x: frame.size.width / 2.0, y: sideLength * 0.6)
        iconView.removeFromSuperview()
        iconView.frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)
        iconView.image = icon
        iconView.center = drawCenter
        addSubview(iconView)
    }
    
    func drawFileNameLabel() {
        fileNameLabel.removeFromSuperview()
        let fontSize: CGFloat = UIDevice().model == "iPad" ? 18.0 : 14.0
        fileNameLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: fontSize * 1.1)
        fileNameLabel.text = fileName
        fileNameLabel.font = UIFont.init(name: "Verdana", size: fontSize)
        fileNameLabel.textAlignment = NSTextAlignment.center
        fileNameLabel.textColor = ColorKey.Blue
        fileNameLabel.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.width * 0.96)
        addSubview(fileNameLabel)
    }
    
    func drawFileTimeLabel() {
        fileTimeLabel.removeFromSuperview()
        let fontSize: CGFloat = UIDevice().model == "iPad" ? 12.0 : 10.0
        fileTimeLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: fontSize * 1.1)
        fileTimeLabel.text = fileTime
        fileTimeLabel.font = UIFont(name: "Verdana", size: fontSize)
        fileTimeLabel.textAlignment = NSTextAlignment.center
        fileTimeLabel.textColor = ColorKey.DimGray
        fileTimeLabel.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.width * 1.1)
        addSubview(fileTimeLabel)
    }
    
    func drawCell(icon: UIImage?, filName: String, fileTime: String) {
        self.icon = icon
        self.fileName = filName
        self.fileTime = fileTime
        self.isSelectedByUser = false
    }
}

extension FileCell {
    func enableEditFileName() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FileCell.showRenameFileAlert))
        fileNameLabel.addGestureRecognizer(tapGesture)
        fileNameLabel.isUserInteractionEnabled = true
    }
    
    @objc func showRenameFileAlert() {
        fileSelectorVC.showInputAlert(owner: fileSelectorVC, okMethod: fileSelectorVC.renameFile)
        fileSelectorVC.fileName = fileName
        fileSelectorVC.inputTextField.text = fileName
        fileSelectorVC.okAction.isEnabled = true
    }
}
