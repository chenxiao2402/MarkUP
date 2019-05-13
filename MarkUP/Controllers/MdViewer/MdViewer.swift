//
//  MdViewer.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/1.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit
import WebKit

class MdViewer: UIViewController, UIDocumentInteractionControllerDelegate {
    
    var groupName: String!
    var fileName: String!
    var markView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds
        let config = WKWebViewConfiguration.init()
        config.preferences.setValue(true, forKey: WKWebViewConfigKey.AllowFileAccessFromFileURLs)
        markView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), configuration: config)
        view.addSubview(markView)

        let baseUrl = FileSystemKey.url(groupName, fileName)
        let htmlUrl = baseUrl.appendingPathComponent(fileName + HtmlManager.fileExtension)
        markView.loadFileURL(htmlUrl, allowingReadAccessTo: baseUrl)
    }

    @IBAction func exportPDF(_ sender: Any) {
        let pdfData = markView.convertToPDF()
        let pdfURL = PDFManager.saveAsPDF(withName: fileName, inGroup: groupName, pdfData: pdfData)
        
        print(pdfURL.absoluteString)
        let documentController = UIDocumentInteractionController.init(url: pdfURL)
        documentController.delegate = self;
        documentController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension WKWebView {
    func convertToPDF() -> NSMutableData {
        let page = CGRect(x: 0, y: 0, width: 595, height: 842)
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(viewPrintFormatter(), startingAtPageAt: 0)
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData( pdfData, page, nil );
        for i in 0..<render.numberOfPages{
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return pdfData;
    }
}

extension MdViewer {
    func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
