//
//  DirectorySelectorCell.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/30.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class GroupSelectorCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    var groupName: String! {
        didSet {
            label.text = groupName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    // 自定义的设置cell是否被选择（更改cell颜色和type）
    func setSelected(_ selected: Bool) {
        accessoryType = selected ? .checkmark : .none
    }
}
