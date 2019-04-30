//
//  MdFile.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/28.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

class MdFile {
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let fileManager = FileManager.default

}

extension MdFile {
    static func getGroup(byName groupName: String) -> URL {
        let url = MdFile.DocumentsDirectory.appendingPathComponent(groupName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    static func createGroup(_ groupName: String) -> Bool {
        let url = MdFile.DocumentsDirectory.appendingPathComponent(groupName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return true
        } else {
            return false
        }
    }
    
    static func loadGroups() -> [String] {
        do {
            var result = try fileManager.contentsOfDirectory(atPath: MdFile.DocumentsDirectory.path)
            result = result.filter { group -> Bool in
                return group != FileSystemKey.DefaultGroup
            }
            try result.sort { (g1, g2) -> Bool in
                let path1 = MdFile.DocumentsDirectory.appendingPathComponent(g1).path
                let attributes1 = try fileManager.attributesOfItem(atPath: path1)
                let creationDate1 = attributes1[FileAttributeKey.creationDate] as! Date
                let path2 = MdFile.DocumentsDirectory.appendingPathComponent(g2).path
                let attributes2 = try fileManager.attributesOfItem(atPath: path2)
                let creationDate2 = attributes2[FileAttributeKey.creationDate] as! Date
                return creationDate1 > creationDate2
            }
            result.insert(FileSystemKey.DefaultGroup, at: 0)
            return result
        } catch {
            return []
        }
    }
    
    static func loadFiles(inGroup groupName: String) -> [(String, String)] {
        do {
            let dirURL = getGroup(byName: groupName)
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
        let url = MdFile.DocumentsDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            return true
        } else {
            return false
        }
    }
    
    static func renameFile(withName fileName: String, inGroup groupName: String, newFileName: String) -> Bool {
        let url = MdFile.DocumentsDirectory.appendingPathComponent(groupName)
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
}
