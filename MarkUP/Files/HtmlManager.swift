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
        let url = FileSystemKey.url(groupName, fileName) .appendingPathComponent(fileName + fileExtension)
        let imageManager = ImageManager(groupName: groupName, fileName: fileName)
        let content = loadHtml(resolveMarkdown(MarkdownManager.readFile(withName: fileName, inGroup: groupName), imageManager: imageManager))
        try! content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    static func resolveMarkdown(_ content: String, imageManager: ImageManager) -> String {
        var htmlContent = try! EFMarkdown().markdownToHTML(content, options: .default)
        
        let pattern = "<img src=\".*?\" alt=\"\" />"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let res = regex.matches(in: htmlContent, options: [], range: NSMakeRange(0, htmlContent.count))
        
        var imageNameList: [String] = []
        for checkingRes in res {
            var start = htmlContent.index(htmlContent.startIndex, offsetBy: checkingRes.range.location)
            let imageText = String(htmlContent.suffix(from: start).prefix(checkingRes.range.length))
            start = imageText.index(imageText.startIndex, offsetBy: 10)
            let imageName = imageText[..<imageText.index(imageText.endIndex, offsetBy: -11)].suffix(from: start)
            imageNameList.append(String(imageName))
        }

        for imageName in imageNameList {
            let originalHtml = "<img src=\"\(imageName)\" alt=\"\" />"
            let imageUrl = "<img src=\"\(imageManager.url(String(imageName)).absoluteString)\" alt=\"\" />"
            htmlContent = htmlContent.replacingOccurrences(of: originalHtml, with: imageUrl)
        }
        
        return htmlContent
    }
    
    static func loadHtml(_ content: String) -> String {
        let path = Bundle.main.path(forResource: "main-css", ofType: "css")
        let css = try! String.init(contentsOfFile: path!, encoding: .utf8)
        return "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><style type=\"text/css\">\(css)</style></head><body><main>\(content)</main></body></html>"
    }
}
