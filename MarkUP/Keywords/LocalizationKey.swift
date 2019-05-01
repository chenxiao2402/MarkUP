//
//  LocalizationKey.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/28.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import Foundation

struct LocalizationKey {
    static let Yes = translate("Yes")
    static let No = translate("No")
    static let Cancel = translate("Cancel")
    static let InputFileName = translate("InputFileName")
    static let DuplicateFileName = translate("DuplicateFileName")
    static let Group = translate("Group")
    static let InputGroupName = translate("InputGroupName")
    static let DuplicateGroupName = translate("DuplicateGroupName")
    static let DeleteGroupPrompt = translate("DeleteGroupPrompt")
    static let CantDeleteDefaultGroup = translate("CantDeleteDefaultGroup")
    
    static func translate(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
