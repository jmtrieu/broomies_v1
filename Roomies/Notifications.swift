//
//  Notifications.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class Notifications: UIViewController {
    //declare group vs user icons
    @IBOutlet weak var userLine: UIView!
    @IBOutlet weak var groupLine: UIView!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var groupText: UILabel!
    var isUser = true;
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var notificationsTable: UITableView!
    var notificationsDataSource: NotificationsDataSource!
    var notificationsArray = [String]()
    var timesArray = [String]()
    var giverArray = [String]()
    var doerArray = [String]()
    var categoriesArray = [String]()
    var houseName: String!
    var user: User!
    
    var userEmail: String = ""
    var userName: String = ""

    @IBAction func groupTapped(_ sender: Any) {
        if (isUser) {
            groupText.textColor = UIColor(hex: "0C677E")
            userText.textColor = UIColor(hex: "000000")
            groupLine.backgroundColor = UIColor(hex: "0C677E")
            userLine.backgroundColor = UIColor(hex: "000000")
            userLine.frame.size.height = 1.0
            groupLine.frame.size.height = 3.0
            queryNotificationsGroup()
            isUser = false
        }
    }
    @IBAction func userTapped(_ sender: Any) {
        if (!isUser) {
            groupText.textColor = UIColor(hex: "000000")
            userText.textColor = UIColor(hex: "0C677E")
            groupLine.backgroundColor = UIColor(hex: "000000")
            userLine.backgroundColor = UIColor(hex: "0C677E")
            userLine.frame.size.height = 3.0
            groupLine.frame.size.height = 1.0
            queryNotificationsUser()
            isUser = true
        }
    }
    
    @IBAction func HouseButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "NotificationsToHouseSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "NotificationsToHomeSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "NotificationsToCalendarSegue", sender: self)
    }

    func prepareNotificationsTable(){
        let itemsN = notificationsArray
        let itemsT = timesArray
        let itemsG = giverArray
        let itemsD = doerArray
        let itemsC = categoriesArray
        notificationsDataSource = NotificationsDataSource(house: self.houseName!)
        notificationsDataSource.setData(notifications: itemsN, times: itemsT, givers: itemsG, doers: itemsD, categories: itemsC)
        self.notificationsTable.dataSource = notificationsDataSource
        self.notificationsTable.delegate = notificationsDataSource
        self.notificationsTable.register(UINib(nibName: "ChoreView", bundle: Bundle.main), forCellReuseIdentifier: "ChoreView")
        self.notificationsTable.tableFooterView = UIView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUser()
        self.queryNotificationsUser()
        self.notificationsTable.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
    }
    
    func getUser() {
        self.userEmail = Auth.auth().currentUser!.email!
        let houseQuery = Database.database().reference().child("users")
        houseQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == self.userEmail {
                        self.userName = ((s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String)!
                    }
                    
                }
            }
        })
    }
    
    func clearArrays() {
        self.doerArray.removeAll()
        self.giverArray.removeAll()
        self.notificationsArray.removeAll()
        self.timesArray.removeAll()
        self.categoriesArray.removeAll()
    }
    
    func queryNotificationsUser() {
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        formatter.timeZone = Calendar.current.timeZone
        
        let notificationsQuery = Database.database().reference().child("houses").child(houseName!).child("chores")
        notificationsQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.clearArrays()
                print("snaphshot is: ")
                //clears past data
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String != self.userName {
                        continue;
                    }
                    self.notificationsArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                    self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                    self.doerArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String)
                    self.categoriesArray.append("user")
                    
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
                self.prepareNotificationsTable()
            }
        })
    }
    
    func queryNotificationsGroup() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        formatter.timeZone = Calendar.current.timeZone
        
        let notificationsQuery = Database.database().reference().child("houses").child(houseName!).child("chores")
        notificationsQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.clearArrays()
                print("snaphshot is: ")
                //clears past data
                for s in snapshot.children {
                    self.notificationsArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                    self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                    self.doerArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String)
                    self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
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
                self.prepareNotificationsTable()
                
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NotificationsToHouseSegue") {
            let vc = segue.destination as! HouseView
            vc.houseName = self.houseName
        }
        if (segue.identifier == "NotificationsToHomeSegue") {
            let hc = segue.destination as! Home
            hc.houseName = self.houseName
        }
        if (segue.identifier == "NotificationsToCalendarSegue") {
            let cc = segue.destination as! ViewController
            cc.houseName = self.houseName
        }
    }
    
    
}

