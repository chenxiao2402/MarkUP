//
//  GroupManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

class GroupManager {
    
    static let fileManager = FileManager.default
    
    static func getGroup(byName groupName: String) -> URL {
        let url = FileSystemKey.DocumentDirectory.appendingPathComponent(groupName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    static func createGroup(_ groupName: String) -> Bool {
        let url = FileSystemKey.DocumentDirectory.appendingPathComponent(groupName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return true
        } else {
            return false
        }
    }
    
    static func removeGroup(_ groupName: String) -> Bool {
        if groupName == FileSystemKey.DefaultGroup {
            return false
        }
        
        let url = FileSystemKey.DocumentDirectory.appendingPathComponent(groupName)
        if fileManager.fileExists(atPath: url.path) {
            try! fileManager.removeItem(atPath: url.path)
        }
        return true
    }
    
    static func loadGroups() -> [String] {
        do {
            var result = try fileManager.contentsOfDirectory(atPath: FileSystemKey.DocumentDirectory.path)
            result = result.filter { group -> Bool in
                return group != FileSystemKey.DefaultGroup
            }
            try result.sort { (g1, g2) -> Bool in
                let path1 = FileSystemKey.DocumentDirectory.appendingPathComponent(g1).path
                let attributes1 = try fileManager.attributesOfItem(atPath: path1)
                let creationDate1 = attributes1[FileAttributeKey.creationDate] as! Date
                let path2 = FileSystemKey.DocumentDirectory.appendingPathComponent(g2).path
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
}
