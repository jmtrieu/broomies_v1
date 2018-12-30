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

class HouseSettings: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    var houseName: String!
    var email: String!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color one is bottom right corner and Color two is top left corner
        self.gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.textField.text = self.houseName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HouseToSettingsSegue", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HouseToSettingsSegue", sender: self)
    }
    @IBAction func leaveButtonPressed(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Leave", style: .default) { (action) in
                self.leaveHouse()
                self.performSegue(withIdentifier: "LeaveHouseSegue", sender: self)
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                print("cancel")
            }
        let alert = UIAlertController(title: "Leave House",
                                      message: "Are you sure you want to leave?",
                                      preferredStyle: .alert)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func leaveHouse() {
        var found = false
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: {snapshot in
            if (snapshot.exists() && !found) {
                for s in snapshot.children {
                    let id = (s as! DataSnapshot).childSnapshot(forPath: "/houseID").value as? Int
                    if ((s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email && id != 0) {
                        let key = (s as! DataSnapshot).key
                        let changes : [String: Any] = [
                            "house": "NA",
                            "houseID": 0]
                        ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                return
                            }
                        })
                        found = true
                    }
                }
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HouseToSettingsSegue") {
            let vc = segue.destination as! Settings
            vc.houseName = self.houseName
            vc.email = self.email
        }
    }
    
    
}
