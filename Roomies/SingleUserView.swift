//
//  HouseViewViewController.swift
//  Broomies
//
//  Created by Cameron Kato on 11/8/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SingleUserView: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var toDoTable: UITableView!
    var toDoDataSource: NotificationsDataSource!
    var toDoArray = [String]()
    var timesArray = [String]()
    var giversArray = [String]()
    var doersArray = [String]()
    var categoriesArray = [String]()
    
    var person: myUser!

    func prepareToDoTable(){
        let itemsC = toDoArray
        let itemsT = timesArray
        let itemsG = giversArray
        let itemsD = doersArray
        let itemsCat = categoriesArray
        
        toDoDataSource = NotificationsDataSource(house: person.house)
        toDoDataSource.setData(notifications: itemsC, times: itemsT, givers: itemsG, doers: itemsD, categories: itemsCat)
        self.toDoTable.dataSource = toDoDataSource
        self.toDoTable.delegate = toDoDataSource
        self.toDoTable.register(UINib(nibName: "ChoreView", bundle: Bundle.main), forCellReuseIdentifier: "ChoreView")
        self.toDoTable.tableFooterView = UIView()
    }
    
    func tableQueriesByWeek() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        let today = Date()
        
        let choresQuery = Database.database().reference().child("houses").child(person.house).child("chores")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print("snaphshot is: ")
                //clears past data
                self.toDoArray.removeAll()
                for s in snapshot.children {
                    let cur = formatter.date(from: (s as! DataSnapshot).childSnapshot(forPath: "/duedate").value as! String)
                    if cur != nil && !Calendar.current.isDate(today, equalTo: cur!, toGranularity: .weekOfYear) {
                        continue;
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String != self.person.firstName {
                        continue;
                    }
                    /// checks if in todo or inprogress
                    if (((s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String == "f")) {
                        /// if in todo, delete extra
                        if (((s as! DataSnapshot).childSnapshot(forPath: "/inProgress").value as! String == "f")) {
                            self.toDoArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                            self.giversArray.append((s as! DataSnapshot).childSnapshot(forPath: "assigner").value as! String)
                            self.doersArray.append(self.person.firstName)
                            self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "category").value as! String)
                            /// go to inprogress
                            
                            //appends converted time to timeArray
                            let qTime = (s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String
                            let startDate = formatter.date(from: qTime)
                            let components = Calendar.current.dateComponents([ .year, .month, .day, .hour, .minute], from: startDate!, to: Date())
                            let years = components.year
                            let months = components.month
                            let days = components.day
                            let hours = components.hour
                            let minutes = components.minute
                            if (years == 0) {
                                if (months == 0) {
                                    if (days == 0) {
                                        if (hours == 0) {
                                            self.timesArray.append("\(minutes!)m")
                                        } else {
                                            self.timesArray.append("\(hours!)h")
                                        }
                                    } else {
                                        self.timesArray.append("\(days!)d")
                                    }
                                } else {
                                    self.timesArray.append("\(months!)mon")
                                }
                            } else {
                                self.timesArray.append("\(years!)y")
                            }
                        }
                    }
                    
                }
                
            }
            self.prepareToDoTable()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SingleUserToHouseSegue") {
            let vc = segue.destination as! HouseView
            vc.houseName = person.house
        }
        if (segue.identifier == "SingleUserBackSegue") {
            let bc = segue.destination as! HouseView
            bc.houseName = person.house
        }
        if (segue.identifier == "SingleUserToNotificationsSegue") {
            let nc = segue.destination as! Notifications
            nc.houseName = person.house
        }
        if (segue.identifier == "SingleUserToCalendarSegue") {
            let cc = segue.destination as! ViewController
            cc.houseName = person.house
        }
        if (segue.identifier == "SingleUserToCreateTaskSegue") {
            let ctc = segue.destination as! CreateTask
            ctc.houseName = person.house
            ctc.fromSingleUser = true
            ctc.passedVal = person.firstName
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserToHomeSegue", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserToCreateTaskSegue", sender: self)
    }
    
    @IBAction func houseButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserToHouseSegue", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserBackSegue", sender: self)
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserToCalendarSegue", sender: self)
    }
    
    @IBAction func notificationsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SingleUserToNotificationsSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = person.firstName
        tableQueriesByWeek()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
