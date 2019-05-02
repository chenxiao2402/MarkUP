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
    
    static func loadFiles(inGroup groupName: String) -> [(String, String)] {
        do {
            let dirURL = GroupManager.getGroup(byName: groupName)
            let fileList = try fileManager.contentsOfDirectory(atPath: dirURL.path).sorted()
            var result = try fileList.map { fileName -> (String, String) in
                let filePath = dirURL.path + "/\(fileName)"
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
        let url = FileSystemKey.MarkdownDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            return true
        } else {
            return false
        }
    }
    
    static func renameFile(withName fileName: String, inGroup groupName: String, newFileName: String) -> Bool {
        let url = FileSystemKey.MarkdownDirectory.appendingPathComponent(groupName)
        let originPath = url.appendingPathComponent(fileName)
        let destinationPath = url.appendingPathComponent(newFileName)
        do {
            // 如果移动到一个已经存在的、但是不是originPath的路径，会报错
            try fileManager.moveItem(at: originPath, to: destinationPath)
            return true
        } catch {
            return false
        }
    }
    
    static func removeFiles(fileList: [String], inGroup groupName: String) {
        for file in fileList {
            let url = FileSystemKey.MarkdownDirectory.appendingPathComponent(groupName).appendingPathComponent(file)
            if fileManager.fileExists(atPath: url.path) {
                try! fileManager.removeItem(atPath: url.path)
            }
        }
    }
    
    static func saveFile(withName fileName: String, inGroup groupName: String, content: String) {
        let url = FileSystemKey.MarkdownDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        let data = try! NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: false)
        try! data.write(to: url)
    }
    
    static func readFile(withName fileName: String, inGroup groupName: String) -> String {
        do {
            let url = FileSystemKey.MarkdownDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
            let fileData = try Data(contentsOf: url)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? String ?? ""
        } catch {
            return ""
        }
    }
}
