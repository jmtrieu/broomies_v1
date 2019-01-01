//
//  Home.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Home: UIViewController {
    
    //notications center
    let nc = NotificationCenter.default
    var ip: IndexPath!
    var ipTapped = false
    
    var fromSettings = false
    var fromDoneTable = false
   
    @IBOutlet weak var gradientView: UIView!
    
    //Day View & Weekly View Buttons
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    
    @IBOutlet weak var toDoTable: UITableView!
    var toDoDataSource: HomeCellViewDataSource!
    var toDoArray = [String]()
    var giverArray = [String]()
    var categoriesArray = [String]()
    var timesArray = [String]()
    var idArray = [Int]()
    
    var doneGiverArray = [String]()
    var doneCategoriesArray = [String]()
    var doneTimesArray = [String]()
    var doneIdArray = [Int]()
    
    var houseName: String!
    var houseID: Int!
    var user: User!
    
    @IBOutlet weak var curDate: UILabel!
    
    @IBOutlet weak var inProgressTable: UITableView!
    var inProgressDataSource: InProgressDataSource!
    var inProgressArray = [String]()
    
    @IBOutlet weak var doneTable: UITableView!
    var doneDataSource: HomeDoneDataSource!
    var doneArray = [String]()
    
    @IBOutlet weak var settingsMenu: UIView!
    let maxSettings:CGFloat = 1.0
    let maxBlack:CGFloat = 0.5
    var userEmail:String = ""
    var userName: String = ""
    @IBOutlet weak var blackMenu: UIView!
    
    var isDay = true;
    
    @IBOutlet weak var hamburgerName: UILabel!
    
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var fullBar: UIView!
    var doneCount = 0
    var allCount = 0
    @IBOutlet weak var progressLabel: UILabel!
    
    func prepareToDoTable(){
        let itemsN = toDoArray
        let itemsG = giverArray
        let itemsC = categoriesArray
        let itemsT = timesArray
        let itemsI = idArray
        toDoDataSource = HomeCellViewDataSource(house: self.houseName!, isToDo: true)
        toDoDataSource.setData(chores: itemsN, givers: itemsG, categories: itemsC, times: itemsT, ids: itemsI)
        self.toDoTable.dataSource = toDoDataSource
        self.toDoTable.delegate = toDoDataSource
        self.toDoTable.register(UINib(nibName: "HomeCellView", bundle: Bundle.main), forCellReuseIdentifier: "HomeCellView")
        self.toDoTable.tableFooterView = UIView()
    }
    
    
    func prepareDoneTable(){
        let itemsN = doneArray
        let itemsG = doneGiverArray
        let itemsC = doneCategoriesArray
        let itemsT = doneTimesArray
        let itemsI = doneIdArray
        doneDataSource = HomeDoneDataSource(house: self.houseName!, isToDo: false)
        doneDataSource.setData(chores: itemsN, givers: itemsG, categories: itemsC, times: itemsT, ids: itemsI)
        self.doneTable.dataSource = doneDataSource
        self.doneTable.delegate = doneDataSource
        self.doneTable.register(UINib(nibName: "HomeCellView", bundle: Bundle.main), forCellReuseIdentifier: "DoneCellView")
        self.doneTable.tableFooterView = UIView()
    }
    
    @IBAction func blackViewTapped(_ sender: Any) {
        if !blackMenu.isHidden {
            blackMenu.isHidden = true
            settingsMenu.isHidden = true
        }
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddSegue", sender: self)
    }
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "HomeToSettingsSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "HomeToChartsSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "HomeToCalendarSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "HomeToNotificationsSegue", sender: self)
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "HomeToCompletedSegue", sender: self)
    }
    
    @IBAction func ChangeHouseViewButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToHouseViewSegue", sender: self)
    }
    
    @IBAction func ChangePasswordButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToChangePassword", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddSegue") {
            let vc = segue.destination as! CreateTask
            vc.houseName = self.houseName
        }
        if (segue.identifier == "HomeToSettingsSegue") {
            let sc = segue.destination as! Settings
            sc.houseName = self.houseName
            sc.email = self.user.email
        }
        if (segue.identifier == "HomeToChoreSegue") {
            let chc = segue.destination as! Chore
            chc.passedChoreName = (sender as! HomeCellView).choreLabel.text
            chc.id = (sender as! HomeCellView).id
            chc.houseName = self.houseName
            chc.done = self.fromDoneTable
        }
        if (segue.identifier == "HomeToHouseViewSegue") {
            let ac = segue.destination as! HouseView
            ac.houseName = self.houseName
        }
        if (segue.identifier == "HomeToCalendarSegue") {
            let cc = segue.destination as! ViewController
            cc.houseName = self.houseName
        }
        if (segue.identifier == "HomeToNotificationsSegue") {
            let nc = segue.destination as! Notifications
            nc.houseName = self.houseName
        }
    }
    
    
    func getHouseNameAndID() {
        self.user = Auth.auth().currentUser!
        if (!fromSettings) {
            self.userEmail = user.email as String!
        }
        let houseQuery = Database.database().reference().child("users")
        houseQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as! String == self.userEmail {
                        self.houseName = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String
                        self.houseID = (s as! DataSnapshot).childSnapshot(forPath: "/houseID").value as? Int
                    }
                }
            }
            if self.isDay {
                self.tableQueriesByDay()
            } else {
                self.tableQueriesByWeek()
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        //sets up notifications center
        nc.addObserver(self, selector: #selector(self.getValue(notification:)), name: Notification.Name(rawValue: "chore"), object: nil)
        nc.addObserver(self, selector: #selector(self.getValue(notification:)), name: Notification.Name(rawValue: "done"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets up date formatter
        let homeFormatter = DateFormatter()
        homeFormatter.dateStyle = .medium
        homeFormatter.timeStyle = .none
        homeFormatter.locale = Locale(identifier: "en_US")
        getUser()
        getHouseNameAndID()
        curDate.text = homeFormatter.string(from: Date())
        settingsMenu.isHidden = true;
        blackMenu.isHidden = true;
        
        //sets week image to gray
        let img = UIImage(named: "week_view")!.alpha(0.6)
        weekButton.setImage(img, for: .normal)
        
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
    }
    
    func formatProgressBar() {
        self.doneCount = self.doneArray.count
        self.allCount = self.doneArray.count + self.toDoArray.count
        let percentage = Float(Float(self.doneCount) / Float(self.allCount))
        self.progressLabel.text = "\(Int(percentage*100))% completed"
        let newWidth = self.fullBar.frame.size.width
        self.progressBar.frame.size.width = CGFloat(percentage) * newWidth
    }
    
    //gets value sent from notificationcenter
    @objc func getValue(notification: Notification) {
        let userInfo:Dictionary<String, IndexPath> = notification.userInfo as! Dictionary<String, IndexPath>
        let item = userInfo["ip"]! as IndexPath
        self.ip = item
        if notification.name.rawValue == "chore" {
            let cell = self.toDoTable.cellForRow(at: ip) as! HomeCellView
            self.fromDoneTable = false
            self.performSegue(withIdentifier: "HomeToChoreSegue", sender: cell)
        }
        if notification.name.rawValue == "done" {
            let cell = self.doneTable.cellForRow(at: ip) as! HomeCellView
            self.fromDoneTable = true
            self.performSegue(withIdentifier: "HomeToChoreSegue", sender: cell)
        }
    }

    
    func getUser() {
        if (!fromSettings) {
            self.userEmail = Auth.auth().currentUser!.email!
        }
        let houseQuery = Database.database().reference().child("users")
        houseQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == self.userEmail {
                        self.userName = ((s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String)!
                        self.hamburgerName.text = self.userName
                    }
                    
                }
            }
        })
    }
    
    func removeAll() {
        self.toDoArray.removeAll()
        self.doneArray.removeAll()
        self.giverArray.removeAll()
        self.categoriesArray.removeAll()
        self.timesArray.removeAll()
        self.idArray.removeAll()
        
        self.doneGiverArray.removeAll()
        self.doneCategoriesArray.removeAll()
        self.doneTimesArray.removeAll()
    }
    
    //display tables by day
    func tableQueriesByDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let today = formatter.string(from: Date())
        
        let choresQuery = Database.database().reference().child("houses").child(houseName!).child("chores")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print("snaphshot is: ")
                //clears past data
                self.removeAll()
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/duedate").value as! String != today {
                        continue;
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String != self.userName as! String {
                        continue;
                    }
                    var doneString = (s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String
                    /// checks if in todo or inprogress
                    if (((s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String == "f")) {
                        /// if in todo, delete extra
                        if (((s as! DataSnapshot).childSnapshot(forPath: "/inProgress").value as! String == "f")) {
                            self.toDoArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                            self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                            self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                            self.timesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                            self.idArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                        /// go to inprogress
                        } else {
                            if self.toDoArray.contains(doneString) {
                                self.toDoArray = self.toDoDataSource.choresArray
                            }
                        }
                    } else {
                        if self.toDoArray.contains(doneString) {
                            self.toDoArray = self.toDoDataSource.choresArray
                        }
                        self.doneArray.append(doneString)
                        self.doneGiverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                        self.doneCategoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                        self.doneTimesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                        self.doneIdArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                    }
                    
                }
                
            } else if !snapshot.exists(){
                if self.doneArray.count != 0{
                    self.doneArray = self.doneDataSource.choresArray
                }
            }
            self.prepareToDoTable()
            self.prepareDoneTable()
            self.formatProgressBar()
        })
    }
    
    //queries by week
    func tableQueriesByWeek() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let today = Date()
        
        let choresQuery = Database.database().reference().child("houses").child(houseName!).child("chores")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print("snaphshot is: ")
                //clears past data
                self.removeAll()
                for s in snapshot.children {
                    let cur = formatter.date(from: (s as! DataSnapshot).childSnapshot(forPath: "/duedate").value as! String)
                    if cur != nil && !Calendar.current.isDate(today, equalTo: cur!, toGranularity: .weekOfYear) {
                        continue;
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String != self.userName as! String {
                        continue;
                    }
                    var doneString = (s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String
                    /// checks if in todo or inprogress
                    if (((s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String == "f")) {
                        /// if in todo, delete extra
                        if (((s as! DataSnapshot).childSnapshot(forPath: "/inProgress").value as! String == "f")) {
                            self.toDoArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                            self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                            self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                            self.timesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                            self.idArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                            /// go to inprogress
                        } else {
                            if self.toDoArray.contains(doneString) {
                                self.toDoArray = self.toDoDataSource.choresArray
                            }
                            self.inProgressArray.append(doneString)
                        }
                    } else {
                        if self.toDoArray.contains(doneString) {
                            self.toDoArray = self.toDoDataSource.choresArray
                        }
                        self.doneArray.append(doneString)
                        self.doneGiverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                        self.doneCategoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                        self.doneTimesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                        self.doneIdArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                    }
                    
                }
                
            } else if !snapshot.exists(){
                if self.doneArray.count != 0{
                    self.doneArray = self.doneDataSource.choresArray
                }
            }
            self.prepareToDoTable()
            self.prepareDoneTable()
            self.formatProgressBar()
        })
    }
    
    //calls view Settings to show hamburger menu
    @IBAction func gestureSwipe(_ sender: Any) {
        if settingsMenu.isHidden == true {
            self.viewSettings()
        } else {
            self.hideSettings()
        }
    }
    
    //side swipe allowed
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if settingsMenu.isHidden == true {
                self.viewSettings()
            }
        }
    }
    
    //calls view Settings to show hamburger menu
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        if settingsMenu.isHidden == true {
            self.viewSettings()
        } else {
            self.hideSettings()
        }
    }
    
    //Change table to day view
    @IBAction func gestureTapChangeTables(_ sender: Any) {
        let img = UIImage(named: "week_view")!.alpha(0.6)
        let def_img = UIImage(named: "day_view")!

        if isDay == false {
            isDay = true
            weekButton.setImage(img, for: .normal) //When day view is selected gray out week view
            dayButton.setImage(def_img, for: .normal)
            self.tableQueriesByDay()
        }
        self.prepareToDoTable()
        self.prepareDoneTable()
    }
    
    //Change table to weekly view
    @IBAction func gestureTapChangeTablesToWeek(_ sender: Any) {
        let img = UIImage(named: "day_view")!.alpha(0.6)
        let def_img = UIImage(named: "week_view")!

        if isDay == true {
            isDay = false
            dayButton.setImage(img, for: .normal)
            weekButton.setImage(def_img, for: .normal)
            
            self.tableQueriesByWeek()
        }
        self.prepareToDoTable()
        self.prepareDoneTable()
        self.formatProgressBar()
    }
    
    
    
    @IBAction func viewSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn,
            animations: {
                self.view.layoutIfNeeded()
                self.settingsMenu.alpha = 1
                self.blackMenu.alpha = self.maxBlack
                self.settingsMenu.isHidden = false;
                self.blackMenu.isHidden = false;
            },
            completion: { (complete) in print("complete")
            }
        )
    }
    
    @IBAction func hideSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.settingsMenu.alpha = self.maxSettings
                        self.settingsMenu.isHidden = true;
                        self.blackMenu.isHidden = true;
                        },
                       completion: { (complete) in print("complete")
                        }
        )
    }
    
    @IBAction func archivedTasksButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToArchivedTasksSegue", sender: self)
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToChangePasswordSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
