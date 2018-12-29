//
//  NoHouse.swift
//  Broomies
//
//  Created by Cameron Kato 12/28/18.
//  Copyright © 2018 Cameron Kato. All rights reserved.
//

//TODO CREATE SEGUES AND PAGES FROM SEGUES & CONNECT SEGUES

import UIKit
import Firebase
import FirebaseAuth

class NoHouse: UIViewController {
    
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var curUserEmail: String!
    
    var fromSettings = false
    var found = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
        // Do any additional setup after loading the view, typically from a nib.
        if (fromSettings) {
            self.leaveHouse()
        }
    }

    func leaveHouse() {
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: {snapshot in
            if (snapshot.exists()) {
                for s in snapshot.children {
                    if (self.found) {
                        return;
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email {
                        let key = (s as! DataSnapshot).key
                        let changes : [String: Any] = [
                            "house": "NA",
                            "houseID": 0]
                        ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                return
                            }
                        })
                        self.found = true;
                    }
                }
            }
        })
    }
    
    func getUserInfo() {
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: {snapshot in
            if (snapshot.exists()) {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email {
                        self.curUserEmail = (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String
                        self.firstName = (s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String
                        self.lastName = (s as! DataSnapshot).childSnapshot(forPath: "/lastName").value as? String
                        self.phoneNumber = (s as! DataSnapshot).childSnapshot(forPath: "/phoneNumber").value as? String
                    }
                }
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "JoinHouseSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "JoinHouseSegue") {
            let jc = segue.destination as! JoinHouse
            jc.firstName = self.firstName
            jc.lastName = self.lastName
            jc.phoneNumber = self.phoneNumber
            jc.curUserEmail = self.curUserEmail
            jc.fromPriorAccount = true
        }
    }
    
    
}
