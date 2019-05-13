//
//  MarkdownManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

class MarkdownManager {
    
    static let fileManager = FileManager.default
    static let mdExtension = ".md"
    static let pdfExtension = ".pdf"
    static let htmlExtension = ".html"
    
    static func loadFiles(inGroup groupName: String) -> [(String, String)] {
        do {
            let dirURL = GroupManager.getGroup(byName: groupName)
            let fileList = try fileManager.contentsOfDirectory(atPath: dirURL.path).sorted()
            var result = try fileList.map { fileName -> (String, String) in
                let filePath = dirURL.appendingPathComponent(fileName).path
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                let creationDate = attributes[FileAttributeKey.creationDate] as! Date
                return (fileName, DateTool.dateToString(creationDate))
            }
            // 按照文件的创建时间的倒叙进行排列
            result.sort { $0.1 > $1.1}
            return result
        } catch {
            return []
        }
    }
    
    static func createFile(withName fileName: String, inGroup groupName: String) -> Bool {
        let mdFileUrl = mdUrl(groupName, fileName)
        if !fileManager.fileExists(atPath: mdFileUrl.path) {
            try! fileManager.createDirectory(at: FileSystemKey.url(groupName, fileName), withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: mdFileUrl.path, contents: nil, attributes: nil)
            return true
        } else {
            return false
        }
    }
    
    static func renameFile(withName fileName: String, inGroup groupName: String, newFileName: String) -> Bool {
        let originPath = FileSystemKey.url(groupName, fileName)
        let destinationPath = FileSystemKey.url(groupName, newFileName)
        do {
            try fileManager.moveItem(at: originPath, to: destinationPath)
            for fileExtension in [mdExtension, pdfExtension, htmlExtension] {
                let originFile = destinationPath.appendingPathComponent(fileName + fileExtension)
                let destinationFile = destinationPath.appendingPathComponent(newFileName + fileExtension)
                try fileManager.moveItem(at: originFile, to: destinationFile)
            }
            return true
        } catch {
            return false
        }
    }
    
    static func removeFiles(fileList: [String], inGroup groupName: String) {
        for fileName in fileList {
            let fileUrl = FileSystemKey.url(groupName, fileName)
            if fileManager.fileExists(atPath: fileUrl.path) {
                try! fileManager.removeItem(atPath: fileUrl.path)
            }
        }
    }
    
    static func saveFile(withName fileName: String, inGroup groupName: String, content: String) {
        let url = mdUrl(groupName, fileName)
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        try! content.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    }
    
    static func readFile(withName fileName: String, inGroup groupName: String) -> String {
        do {
            let url = mdUrl(groupName, fileName)
            return try String.init(contentsOfFile: url.path, encoding: .utf8)
        } catch {
            return ""
        }
    }
    
    static func mdUrl(_ groupName: String, _ fileName: String) -> URL {
        return FileSystemKey.url(groupName, fileName).appendingPathComponent(fileName + mdExtension)
    }
}
