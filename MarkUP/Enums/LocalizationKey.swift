//
//  LocalizationKey.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/28.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

enum LocalizationKey: String {
    case Yes = "Yes"
    case No = "No"
    case Cancel = "Cancel"
    case InputFileName = "InputFileName"
    case DuplicateFileName = "DuplicateFileName"
}

extension LocalizationKey {
    func translate() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
