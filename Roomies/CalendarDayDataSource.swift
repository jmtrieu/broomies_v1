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
    var giverArray: [String] = []
    var categoriesArray: [String] = []
    var timesArray: [String] = []
    var idArray: [Int] = []
    var houseString: String = ""
    
    override init() {
        super.init()
    }
    
    func setHouseName(name: String) {
        self.houseString = name
    }
    
    func setData(itemsD:[String], itemsG:[String], itemsC:[String], itemsT:[String], itemsI: [Int]) {
        self.dayArray = itemsD
        self.giverArray = itemsG
        self.categoriesArray = itemsC
        self.timesArray = itemsT
        self.idArray = itemsI
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HomeCellView! = (tableView.dequeueReusableCell(withIdentifier: "HomeCellView") as! HomeCellView)
        cell.choreLabel!.text = dayArray[indexPath.row]
        cell.assignerLabel!.text = "Assigned by " + giverArray[indexPath.row]
        cell.id = idArray[indexPath.row]
        cell.backgroundColor = UIColor(hex: "E5E5E5")
        let cat = self.categoriesArray[indexPath.row]
        if (cat == "user") {
            cell.catImage.image = UIImage(named: "profile")
        } else if (cat == "Cleaning") {
            cell.catImage.image = UIImage(named: "cleaning")
        } else if (cat == "Shopping") {
            cell.catImage.image = UIImage(named: "Vector")
        } else {
            cell.catImage.image = UIImage(named: "sidebar_payments")
        }
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "calendarChore"), object: nil, userInfo: ["dateIP" : indexPath])
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
