//
//  ImageManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class ImageManager {
    
    var groupName: String!
    var fileName: String!
    var baseUrl: URL!
    let fileManager = FileManager.default
    let fileExtension = ".png"
    
    init(groupName: String, fileName: String) {
        self.groupName = groupName
        self.fileName = fileName
        self.baseUrl = FileSystemKey.SourceDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName).appendingPathComponent(FileSystemKey.ImageDirectory)
    }
    
    func loadImages() -> [String] {
        do {
            let result = try fileManager.contentsOfDirectory(atPath: baseUrl.path)
            return result.map { nameWithExtension -> String in
                let lastIndex = nameWithExtension.index(nameWithExtension.endIndex, offsetBy: -fileExtension.count)
                return String(nameWithExtension[..<lastIndex])
            }
        } catch {
            return []
        }
    }
    
    func addImage(_ imageName: String, image: UIImage) -> Bool {
        if !fileManager.fileExists(atPath: baseUrl.path) {
            try! fileManager.createDirectory(at: baseUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        let imageUrl = url(imageName)
        if !fileManager.fileExists(atPath: imageUrl.path) {
            let data = image.pngData()
            try! data?.write(to: imageUrl)
            return true
        } else {
            return false
        }
    }
    
    func removeImage(_ imageName: String) {
        let imageUrl = url(imageName)
        if fileManager.fileExists(atPath: imageUrl.path) {
            try! fileManager.removeItem(atPath: imageUrl.path)
        }
    }
    
    func url(_ imageName: String) -> URL {
        return baseUrl.appendingPathComponent(imageName + fileExtension)
    }
}
