//
//  ChoresDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class HomeCellViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var choresArray: [String] = []
    var giverArray: [String] = []
    var categoriesArray: [String] = []
    var timesArray: [String] = []
    var houseName: String
    
    var isToDo = true
    
    init(house: String, isToDo: Bool) {
        self.houseName = house
        self.isToDo = isToDo
        super.init()
    }
    
    func setData(chores:[String], givers:[String], categories:[String], times:[String]) {
        self.choresArray = chores
        self.giverArray = givers
        self.categoriesArray = categories
        self.timesArray = times
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HomeCellView! = (tableView.dequeueReusableCell(withIdentifier: "HomeCellView") as! HomeCellView)
        cell.choreLabel!.text = choresArray[indexPath.row]
        cell.assignerLabel!.text = "Assigned by " + giverArray[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ref = Database.database().reference().child("houses").child(self.houseName).child("/chores").child(self.timesArray[indexPath.row])
        if (self.isToDo) {
            let delete = UITableViewRowAction(style: .destructive, title: "Done") { (action, indexPath) in
                // delete item at indexPath
                let changes = ["done": "t"]
                ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        return
                    }
                })
                self.choresArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.reloadData()
            }
            
            return [delete]
        } else {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                // delete item at indexPath
                self.choresArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                ref.removeValue() { (error, ref) in
                    if error != nil {
                        print("error")
                        return
                    }
                }
                tableView.reloadData()
            }
            
            return [delete]
        }
    }
}
