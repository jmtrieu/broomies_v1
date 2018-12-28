//
//  Settings.swift
//  Broomies
//
//  Created by Cameron Kato 12/22/18.
//  Copyright © 2018 Cameron Kato. All rights reserved.
//

//TODO CREATE SEGUES AND PAGES FROM SEGUES & CONNECT SEGUES

import UIKit
import Firebase
import FirebaseAuth

class SettingsChangeValue: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    var email: String!
    var value: String!
    @IBOutlet weak var textField: UITextField!
    var type: Int!
    var houseName: String!
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var mySubTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
            self.textField.text = self.value
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        if (self.type == 0) {
            self.myTitle.text = "Change Name"
            self.mySubTitle.text = "Profile Name"
        } else if (self.type == 1) {
            self.myTitle.text = "Change Number"
            self.mySubTitle.text = "Phone Number"
            self.textField.keyboardType = UIKeyboardType.numberPad
        } else if (self.type == 2) {
            self.myTitle.text = "Change Email"
            self.mySubTitle.text = "Email Address"
        }
    }
 
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToSettingsSegue", sender: self)
    }
    
    func changeAssignNames() {
        let ref = Database.database().reference().child("/houses").child(self.houseName).child("chores")
        ref.observe(.value, with: {snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assignee").value as? String == self.value {
                        let key = (s as! DataSnapshot).key
                        let changes = ["assignee": self.textField.text]
                        ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                return
                            }
                        })
                    }
                    if (s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as? String == self.value {
                        let key = (s as! DataSnapshot).key
                        let changes = ["assigner": self.textField.text]
                        ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                return
                            }
                        })
                    }
                }
            }
        })
    }
    
    func changeEmail() {
        let user = Auth.auth().currentUser
        user?.updateEmail(to: self.textField.text!) { error in
            if let error = error {
                print(error)
            } else {
                print("completed")
            }
        }
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        var category: String!
        if (self.type == 0) {
            self.changeAssignNames()
            category = "firstName"
        } else if (self.type == 1) {
            category = "phoneNumber"
        } else if (self.type == 2) {
            self.changeEmail()
            category = "email"
        }
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: {snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/" + category).value as? String == self.value {
                        let key = (s as! DataSnapshot).key
                        let changes = [category: self.textField.text]
                        ref.child(key).updateChildValues(changes as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                            if err != nil {
                                return
                            }
                        })
                    }
                }
            }
        })
        self.performSegue(withIdentifier: "SaveChangeNameToSettingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SaveChangeNameToSettingsSegue") {
            let sc = segue.destination as? Settings
            sc?.houseName = self.houseName
            if (self.type == 2) {
                sc?.email = self.textField.text!
            } else {
                sc?.email = self.email
            }
        }
        if (segue.identifier == "BackToSettingsSegue") {
            let sc = segue.destination as? Settings
            sc?.houseName = self.houseName
            sc?.email = self.email
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
