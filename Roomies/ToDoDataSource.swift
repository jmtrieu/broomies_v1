//
//  ChoresDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class ToDoDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var toDoArray: [String] = []
    var houseName: String
    
    init(house: String) {
        self.houseName = house
        super.init()
    }
    
    func setData(items:[String]) {
        self.toDoArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell.textLabel!.text = toDoArray[indexPath.row]
        cell.backgroundColor = UIColor.clear;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ref = Database.database().reference().child("houses").child(self.houseName).child("/chores").child(self.toDoArray[indexPath.row])
        let delete = UITableViewRowAction(style: .destructive, title: "Done") { (action, indexPath) in
            // delete item at indexPath
            let changes = ["done": "t"]
            ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
            })
            
            self.toDoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
        
        return [delete]
       /* let inProgress = UITableViewRowAction(style: .default, title: "In Progress") { (action, indexPath) in
            // share item at indexPathlet ref = Database.database().reference().child("/chores").child(self.toDoArray[indexPath.row])
            let changes = ["inProgress": "t"]
            ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
            })
            
            self.toDoArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }*/
        /*inProgress.backgroundColor = UIColor.lightGray
        return [delete, inProgress]
        */
    }
    
    
    
}
