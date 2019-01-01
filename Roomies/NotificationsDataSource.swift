//
//  ChoresDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class NotificationsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var notificationsArray: [String] = []
    var timesArray: [String] = []
    var giverArray: [String] = []
    var doerArray: [String] = []
    var categoriesArray: [String] = []
    var houseName: String
    
    init(house: String) {
        self.houseName = house
        super.init()
    }
    
    func setData(notifications:[String], times:[String], givers:[String], doers:[String], categories:[String]) {
        self.notificationsArray = notifications
        self.timesArray = times
        self.giverArray = givers
        self.doerArray = doers
        self.categoriesArray = categories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChoreView! = tableView.dequeueReusableCell(withIdentifier: "ChoreView") as! ChoreView
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let assigner = NSMutableAttributedString(string: giverArray[tableView.numberOfRows(inSection: 0) - indexPath.row - 1], attributes: attrs)
        cell.choreName!.text = (assigner.mutableString as String) + " assigned " + doerArray[tableView.numberOfRows(inSection: 0) - indexPath.row - 1] + " to " + notificationsArray[tableView.numberOfRows(inSection: 0) - indexPath.row - 1]
        cell.time!.text = timesArray[tableView.numberOfRows(inSection: 0) - indexPath.row - 1]
        cell.backgroundColor = UIColor(hex: "E5E5E5")
        let cat = self.categoriesArray[tableView.numberOfRows(inSection: 0) - indexPath.row - 1]
        if (cat == "user") {
            cell.choreImage.image = UIImage(named: "profile")
        } else if (cat == "Cleaning") {
            cell.choreImage.image = UIImage(named: "myCleaning")
        } else if (cat == "Shopping") {
            cell.choreImage.image = UIImage(named: "myShopping")
        }
        else {
            cell.choreImage.image = UIImage(named: "myBill")
        }
        cell.backgroundColor = UIColor.white
        return cell
    }
}
