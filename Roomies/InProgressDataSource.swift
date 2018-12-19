//
//  InProgressDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class InProgressDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    var inProgressArray: [String] = []
    
    override init() {
        super.init()
    }
    
    func setData(items:[String]) {
        self.inProgressArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inProgressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InProgressCell")
        cell.textLabel!.text = inProgressArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ref = Database.database().reference().child("/chores").child(self.inProgressArray[indexPath.row])
        let delete = UITableViewRowAction(style: .destructive, title: "Done") { (action, indexPath) in
            // delete item at indexPath
            let changes = ["done": "t"]
            ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
            })
            
            self.inProgressArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
        
        return [delete]
        
    }
    
    
}
