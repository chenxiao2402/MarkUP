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
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let MarkdownDirectory = FileSystemKey.DocumentsDirectory.appendingPathComponent("Markdown")
    static let SourceDirectory = FileSystemKey.DocumentsDirectory.appendingPathComponent("Source")
}
