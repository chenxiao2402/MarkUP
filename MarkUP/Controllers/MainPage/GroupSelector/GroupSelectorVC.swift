//
//  GroupSelector.swift
//  MarkUP
//
//  Created by Midrash Elucidator on 2019/4/30.
//  Copyright © 2019 Midrash Elucidator. All rights reserved.
//

import UIKit

class GroupSelectorVC: UITableViewController {
    
    var groupList: [String] = []
    var fileSelectorVC: FileSelectorVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupList = MdFile.loadGroups()
        navigationItem.title = LocalizationKey.Group
        preferredContentSize = CGSize(width: 200, height: min(groupList.count * 48, 280))
    }

    @IBAction func showAddGroupAlert(_ sender: Any) {
        fileSelectorVC.showInputAlert(owner: self, okMethod: fileSelectorVC!.createGroup)
        
    }
    
}


extension GroupSelectorVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardKey.GroupSelectorCell, for: indexPath) as! GroupSelectorCell
        cell.groupName = groupList[indexPath.row]
        cell.setSelected(fileSelectorVC.currentGroup == cell.groupName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fileSelectorVC.currentGroup = groupList[indexPath.row]
        for tableCell in tableView.visibleCells {
            let cell = tableCell as! GroupSelectorCell
            cell.setSelected(fileSelectorVC.currentGroup == cell.groupName)
        }
        fileSelectorVC.fileList = MdFile.loadFiles(inGroup: fileSelectorVC.currentGroup)
        fileSelectorVC.collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

