//
//  CalendarDayDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 11/1/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class CalendarDayDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var dayArray: [String] = []
    var houseString: String = ""
    
    override init() {
        super.init()
    }
    
    func setHouseName(name: String) {
        self.houseString = name
    }
    
    func setData(items:[String]) {
        self.dayArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DayCell")
        cell.textLabel!.text = dayArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ref = Database.database().reference().child("/houses").child(houseString).child("/chores").child(self.dayArray[indexPath.row])
        let delete = UITableViewRowAction(style: .destructive, title: "Done") { (action, indexPath) in
            // delete item at indexPath
            let changes = ["done": "t"]
            ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
            })
            
            self.dayArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
        
        let inProgress = UITableViewRowAction(style: .default, title: "In Progress") { (action, indexPath) in
            // share item at indexPathlet ref = Database.database().reference().child("/chores").child(self.toDoArray[indexPath.row])
            let changes = ["inProgress": "t"]
            ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
            })
            
            self.dayArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
        inProgress.backgroundColor = UIColor.lightGray
        return [delete, inProgress]
        
    }
}
