//
//  PDFManager.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/3.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class PDFManager {
    
    static let fileManager = FileManager.default
    static let fileExtension = ".pdf"
    
    static func getUrl(withName fileName: String, inGroup groupName: String) -> URL {
        return FileSystemKey.url(groupName, fileName).appendingPathComponent(fileName + fileExtension)
    }
    
    static func saveAsPDF(withName fileName: String, inGroup groupName: String, pdfData: NSMutableData) -> URL {
        let pdfURL = PDFManager.getUrl(withName: fileName, inGroup: groupName)
        pdfData.write(to: pdfURL, atomically: true)
        return pdfURL
    }
}
