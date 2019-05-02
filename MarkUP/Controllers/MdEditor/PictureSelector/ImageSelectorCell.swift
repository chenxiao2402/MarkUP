//
//  ImageSelectorCell.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/5/2.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class ImageSelectorCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    var imageName: String! {
        didSet {
            label.text = imageName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
