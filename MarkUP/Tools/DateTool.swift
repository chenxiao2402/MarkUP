//
//  DateTool.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/29.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

class DateTool {
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
        //        String转Date
        //        let dateTime = dateFormatter.date(from: stringTime)
    }
}
