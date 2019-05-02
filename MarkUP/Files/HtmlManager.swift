//
//  HtmlManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation
import EFMarkdown

class HtmlManager {
    
    static let fileManager = FileManager.default
    static let fileExtension = ".html"
    
    static func saveAsHtml(withName fileName: String, inGroup groupName: String) {
        var url = FileSystemKey.SourceDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        url = url.appendingPathComponent(fileName + fileExtension)
        let imageManager = ImageManager(groupName: groupName, fileName: fileName)
        let content = loadHtml(resolveMarkdown(MarkdownManager.readFile(withName: fileName, inGroup: groupName), imageManager: imageManager))
        try! content.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    }
    
    static func resolveMarkdown(_ content: String, imageManager: ImageManager) -> String {
        var result = ""

        for line in content.split(separator: "\n") {
            var oneline = String(line)
            let pattern = "\\!\\[\\]\\(.*\\)"
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let res = regex.matches(in: oneline, options: [], range: NSMakeRange(0, line.count))
            
            var imageNameList: [String] = []
            for checkingRes in res {
                var start = oneline.index(oneline.startIndex, offsetBy: checkingRes.range.location)
                let imageText = String(oneline.suffix(from: start).prefix(checkingRes.range.length))
                start = imageText.index(imageText.startIndex, offsetBy: 4)
                let imageName = imageText[..<imageText.index(before: imageText.endIndex)].suffix(from: start)
                imageNameList.append(String(imageName))
            }
            
            oneline = try! EFMarkdown().markdownToHTML(oneline)
            
            for imageName in imageNameList {
                let originalHtml = "<img src=\"\(imageName)\" alt=\"\" />"
                let imageUrl = "<img src=\"\(imageManager.url(String(imageName)).absoluteString)\" alt=\"\" />"
                oneline = oneline.replacingOccurrences(of: originalHtml, with: imageUrl)
            }
            result += "\(oneline)"
        }
        return result
    }
    
    static func loadHtml(_ content: String) -> String {
        let path = Bundle.main.path(forResource: "main-css", ofType: "css")
        let css = try! String.init(contentsOfFile: path!, encoding: .utf8)
        return "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><style type=\"text/css\">\(css)</style></head><body><main>\(content)</main></body></html>"
    }
}
