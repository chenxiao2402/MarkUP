//
//  ProjectKey.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/29.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

struct FileSystemKey {
    static let DefaultGroup = "Default"
    static let ImageDirectory = "Images"
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func url(_ groupName: String, _ fileName: String) -> URL {
        return FileSystemKey.DocumentDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
    }
}
