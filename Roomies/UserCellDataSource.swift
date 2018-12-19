//
//  ChoresDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class UserCellDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var usersArray: [String] = []
    var houseName: String
    
    init(house: String) {
        self.houseName = house
        super.init()
    }
    
    func setData(items:[String]) {
        self.usersArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCellView! = tableView.dequeueReusableCell(withIdentifier: "UserCellView") as! UserCellView
        cell.username!.text = usersArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = usersArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(rawValue: "assigner"), object: nil, userInfo: ["user" : word])
    }
   
}
