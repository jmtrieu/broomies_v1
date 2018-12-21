//
//  Calendar.swift
//  Broomies
//
//  Created by Nathan Tu on 8/16/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    let formatter = DateFormatter()
    let nc = NotificationCenter.default
    var ip: IndexPath!
    var ipTapped = false
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var houseName: String!
    
    @IBOutlet weak var monthLabel: UILabel!
    var tappedDate: Date!
    
    @IBOutlet weak var dayChoresTable: UITableView!
    var dayChoresDataSource: CalendarDayDataSource!
    var dayChoresArray = [String]()
    var giverArray: [String] = []
    var categoriesArray: [String] = []
    var timesArray: [String] = []
    var idArray: [Int] = []
    
    @IBOutlet weak var gradientView: UIView!
    
    var userEmail: String = ""
    var userName: String = ""
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalenderToHomeBackSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToHomeSegue", sender: self)
    }
    
    @IBAction func HouseViewButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToHouseViewSegue", sender: self)
    }
    
    @IBAction func AddTaskButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CalendarToAddTaskSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToNotificationsSegue", sender: self)
    }
    
    //gets value sent from notificationcenter
    @objc func getValue(notification: Notification) {
        let userInfo:Dictionary<String, IndexPath> = notification.userInfo as! Dictionary<String, IndexPath>
        let item = userInfo["dateIP"]! as IndexPath
        self.ip = item
        let cell = self.dayChoresTable.cellForRow(at: ip) as! HomeCellView
        self.performSegue(withIdentifier: "CalendarToChoreSegue", sender: cell)
    }

    override func viewDidAppear(_ animated: Bool) {
        //sets up notifications center
        nc.addObserver(self, selector: #selector(self.getValue(notification:)), name: Notification.Name(rawValue: "calendarChore"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.register(UINib(nibName: "CellView", bundle: Bundle.main), forCellWithReuseIdentifier: "CellView")
        self.getUser()
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
        self.addButton.isHidden = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CalendarToHouseViewSegue") {
            let vc = segue.destination as! HouseView
            vc.houseName = self.houseName
        }
        if (segue.identifier == "CalendarToChoreSegue") {
            let chc = segue.destination as! Chore
            chc.passedChoreName = (sender as! HomeCellView).choreLabel.text
            chc.id = (sender as! HomeCellView).id
            chc.houseName = self.houseName
        }
        if (segue.identifier == "CalendarToAddTaskSegue") {
            let cc = segue.destination as! CreateTask
            cc.houseName = self.houseName
            cc.fromCalendar = true
            cc.passedDate = self.tappedDate
        }
        if (segue.identifier == "CalendarToHomeSegue") {
            let hc = segue.destination as! Home
            hc.houseName = self.houseName
        }
        if (segue.identifier == "CalendarToNotificationsSegue") {
            let nc = segue.destination as! Notifications
            nc.houseName = self.houseName
        }
    }
    
}

extension ViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CellView
        //sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            if myCustomCell.selectedView.isHidden {
                myCustomCell.dayLabel.textColor = UIColor.black
            } else {
                myCustomCell.dayLabel.textColor = UIColor.white
            }
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = UIColor.black
            } else {
                myCustomCell.dayLabel.textColor = UIColor.gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  5
            if myCustomCell.selectedView.isHidden {
                myCustomCell.selectedView.isHidden = false
            } else {
                //resets selectionview to hidden
                myCustomCell.selectedView.isHidden = true
            }
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    func prepareDayChoresTable(){
        let itemsD = self.dayChoresArray
        let itemsG = self.giverArray
        let itemsC = self.categoriesArray
        let itemsT = self.timesArray
        let itemsI = self.idArray
        dayChoresDataSource = CalendarDayDataSource()
        dayChoresDataSource.setHouseName(name: houseName!)
        dayChoresDataSource.setData(itemsD: itemsD, itemsG: itemsG, itemsC: itemsC, itemsT: itemsT, itemsI: itemsI)
        self.dayChoresTable.dataSource = dayChoresDataSource
        self.dayChoresTable.delegate = dayChoresDataSource
        self.dayChoresTable.register(UINib(nibName: "HomeCellView", bundle: Bundle.main), forCellReuseIdentifier: "HomeCellView")
        self.dayChoresTable.tableFooterView = UIView()
    }
    
    func removeAll() {
        self.dayChoresArray.removeAll()
        self.giverArray.removeAll()
        self.categoriesArray.removeAll()
        self.timesArray.removeAll()
        self.idArray.removeAll()
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        addButton.isHidden = false
        displayEvents(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        addButton.isHidden = true
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        self.removeAll()
        self.prepareDayChoresTable()
    }
    
    func displayEvents(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView else {
            return
        }
        tappedDate = formatter.date(from: myCustomCell.formattedDate)
        queryDayEvents(day: myCustomCell.formattedDate)
    }
    
    func queryDayEvents(day: String) {
        formatter.dateFormat = "yyyy MM dd"
        let choresQuery = Database.database().reference().child("houses").child(houseName!).child("chores")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.removeAll()
                print("snaphshot is: ")
                //clears past data
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String != self.userName {
                        continue;
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/duedate").value as! String == day {
                        if (((s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String == "f")) {
                            self.dayChoresArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                            self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                            self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                            self.timesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                            self.idArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                        }
                    }
                }
                self.prepareDayChoresTable()
            }
        })
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let generateInDates: InDateCellGeneration = .forAllMonths
        let generateOutDates: OutDateCellGeneration = .tillEndOfGrid
        
        let startDate = formatter.date(from: "2018 11 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2019 11 01")!            // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        //correctly formats months
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        monthLabel.text = monthFormatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: cellState.date)!)
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let curDate = formatter.string(from: cellState.date)
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        myCustomCell.dayLabel.text = cellState.text
        myCustomCell.formattedDate = curDate
        
        if cellState.dateBelongsTo == .thisMonth {
           /* if Calendar.current.isDateInToday(date) {
                myCustomCell.backgroundColor = UIColor.red
            }*/
            myCustomCell.dayLabel.textColor = UIColor.black
        } else {
            myCustomCell.dayLabel.textColor = UIColor.gray
        }
        myCustomCell.selectedView.isHidden = true
        return myCustomCell
    }
}
