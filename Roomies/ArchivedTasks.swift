//
//  ArchivedTasks.swift
//  Broomies
//
//  Created by Cameron Kato on 12/30/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ArchivedTasks: UIViewController {
   
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var doneTable: UITableView!
    var doneDataSource: HomeCellViewDataSource!
    var doneArray = [String]()
    var giverArray = [String]()
    var categoriesArray = [String]()
    var timesArray = [String]()
    var idArray = [Int]()
    
    var houseName: String!
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
        self.getUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getHouseName() {
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: {snapshot in
            if (snapshot.exists()) {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email {
                        self.houseName = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String
                    }
                }
            }
            self.tableQuery()
        })
    }
    
    func getUser() {
        let ref = Database.database().reference().child("/users")
        let curEmail = Auth.auth().currentUser?.email
        ref.observe(.value, with: {snapshot in
            if (snapshot.exists()) {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == curEmail {
                        let name = (s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String
                        self.nameLabel.text = name
                        self.userName = name
                    }
                }
            }
            self.getHouseName()
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ArchivedTasksToHomeSegue", sender: self)
    }
    
    func tableQuery() {
        let choresQuery = Database.database().reference().child("/houses").child(self.houseName!).child("chores")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print("snaphshot is: ")
                //clears past data
                self.removeAll()
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as? String != self.userName {
                        continue;
                    }
                    /// checks if in todo or inprogress
                    if (((s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String == "t")) {
                            self.doneArray.append((s as! DataSnapshot).childSnapshot(forPath: "/name").value as! String)
                            self.giverArray.append((s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as! String)
                            self.categoriesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/category").value as! String)
                            self.timesArray.append((s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as! String)
                            self.idArray.append((s as! DataSnapshot).childSnapshot(forPath: "/id").value as! Int)
                            /// go to inprogress
                        }
                }
                self.prepareDoneTable()
            }
        })
    }
    
    func removeAll() {
        self.doneArray.removeAll()
        self.giverArray.removeAll()
        self.categoriesArray.removeAll()
        self.timesArray.removeAll()
        self.idArray.removeAll()
    }
    
    func prepareDoneTable() {
        let itemsN = doneArray
        let itemsG = giverArray
        let itemsC = categoriesArray
        let itemsT = timesArray
        let itemsI = idArray
        doneDataSource = HomeCellViewDataSource(house: self.houseName!, isToDo: true)
        doneDataSource.setData(chores: itemsN, givers: itemsG, categories: itemsC, times: itemsT, ids: itemsI)
        self.doneTable.dataSource = doneDataSource
        self.doneTable.delegate = doneDataSource
        self.doneTable.register(UINib(nibName: "HomeCellView", bundle: Bundle.main), forCellReuseIdentifier: "HomeCellView")
        self.doneTable.tableFooterView = UIView()
    }
    
}
