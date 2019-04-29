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
    static func getDirectory(byName dirName: String) -> URL {
        let url = MdFile.DocumentsDirectory.appendingPathComponent(dirName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    static func loadFiles(inDir dirName: String) -> [(String, String)] {
        do {
            let dirURL = getDirectory(byName: dirName)
            let fileList = try fileManager.contentsOfDirectory(atPath: dirURL.path).sorted()
            var result = try fileList.map { fileName -> (String, String) in
                let filePath = dirURL.path + "/\(fileName)"
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                let modificationDate = attributes[FileAttributeKey.creationDate] as! Date
                return (fileName, DateTool.dateToString(modificationDate))
            }
            // 按照文件的更新时间的倒叙进行排列
            result.sort { $0.1 > $1.1}
            return result
        } catch {
            return []
        }
    }
    
    static func createFile(withName fileName: String, inDir dirName: String) -> Bool {
        let url = MdFile.DocumentsDirectory.appendingPathComponent(dirName).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            return true
        } else {
            return false
        }
    }
}
