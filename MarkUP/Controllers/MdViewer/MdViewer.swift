//
//  MdViewer.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/1.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit
import WebKit

class MdViewer: UIViewController {
    
    var groupName: String!
    var fileName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        let config = WKWebViewConfiguration.init()
        config.preferences.setValue(true, forKey: WKWebViewConfigKey.AllowFileAccessFromFileURLs)
        let markView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), configuration: config)
        markView.sizeToFit()
        view.addSubview(markView)

        let baseUrl = FileSystemKey.SourceDirectory.appendingPathComponent(groupName).appendingPathComponent(fileName)
        let htmlUrl = baseUrl.appendingPathComponent(fileName + HtmlManager.fileExtension)
        markView.loadFileURL(htmlUrl, allowingReadAccessTo: baseUrl)
        
//        markView.loadHTMLString(htmlContent, baseURL: url)
        
//        markView.load(markdown: markdownContent, options: [.default]) {
//            [weak self] (_, _) in
//            if let _ = self {
//                // 可选：你可以通过在此处传入一个百分比来改变字体大小
//                markView.setFontSize(percent: 128)
//                printLog("load finish!")
//
//            }
//        }
    }
    
    func testMarkdownFileContent() -> String {
        if let templateURL = Bundle.main.url(forResource: "sample1", withExtension: "md") {
            do {
                var result = try String(contentsOf: templateURL, encoding: String.Encoding.utf8)
                return result
            } catch {
                return ""
            }
        }
        return ""
    }

}
