//
//  DoneDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class DoneDataSource: NSObject, UITableViewDataSource, UITableViewDelegate  {
    var doneArray: [String] = []
    
    override init() {
        super.init()
    }
    
    func setData(items:[String]) {
        self.doneArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DoneCell")
        cell.textLabel!.text = doneArray[indexPath.row]
        cell.backgroundColor = UIColor.clear;
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ref = Database.database().reference().child("/chores").child(self.doneArray[indexPath.row])
       
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.doneArray.remove(at: indexPath.row)
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
