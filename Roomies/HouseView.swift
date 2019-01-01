//
//  HouseViewViewController.swift
//  Broomies
//
//  Created by Cameron Kato on 11/8/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HouseView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var houseName: String!
    var people: [myUser] = []
    var count: Int!
    var totalCount: Int = 0
    var p: myUser!
    
    @IBOutlet weak var tasksLeft: UILabel!
    @IBOutlet weak var curDate: UILabel!
    @IBOutlet weak var houseMembers: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    var store: UserDataStore!
    var taskString: String!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        houseMembers.text = "\(store.users.count) Members"
        return store.users.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserView", for: indexPath) as! UserView
        self.people.append(store.users[indexPath.row])
        countTasks(userName: self.people[indexPath.row].firstName, cell: cell, indexPath: indexPath)
        
       /* cell.addButtonTapAction = {
            self.performSegue(withIdentifier: "HouseToUserSegue", sender: self)
        }*/
        return cell
        
    }
    
    func countTasks(userName: String, cell: UserView, indexPath: IndexPath) {
        let ref = Database.database().reference().child("houses").child(houseName!).child("chores")
        ref.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.count = 0
                print("snaphshot is: ")
                //clears past data
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as! String == userName && (s as! DataSnapshot).childSnapshot(forPath: "/done").value as! String != "t" {
                        self.count += 1;
                        self.totalCount += 1;
                    }
                }
                self.taskString = String(self.count) + " tasks left"
                cell.displayContent(name: self.people[indexPath.row].firstName, tasks: self.taskString!, user: self.people[indexPath.row])
                self.tasksLeft.text = "\(self.totalCount) tasks left this week"
            }
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "HouseToUserSegue", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HouseToUserSegue") {
            let vc = segue.destination as! SingleUserView
            if (p == nil) {
                p = (sender as! UserView).user
            }
            vc.person = p
        }
        if (segue.identifier == "HouseViewToNotificationsSegue") {
            let nc = segue.destination as! Notifications
            nc.houseName = self.houseName
        }
        if (segue.identifier == "HouseViewToCalendarSegue") {
            let cc = segue.destination as! ViewController
            cc.houseName = self.houseName
        }
    }

    override func viewDidLoad() {
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.store = UserDataStore(name: houseName!)
        store.getUsers(completion: { () in
            self.houseLabel.text = self.houseName!
            //get curDate
            let homeFormatter = DateFormatter()
            homeFormatter.dateStyle = .medium
            homeFormatter.timeStyle = .none
            homeFormatter.locale = Locale(identifier: "en_US")
            self.curDate.text = homeFormatter.string(from: Date())
            
            // Do any additional setup after loading the view.
            //Color one is bottom right corner and Color two is top left corner
            self.gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
            self.collectionView.reloadSections(IndexSet(integer: 0))
        })
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HouseViewToHomeSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPresed(_ sender: Any) {
        self.performSegue(withIdentifier: "HouseViewToCalendarSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HouseViewToNotificationsSegue", sender: self)
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
