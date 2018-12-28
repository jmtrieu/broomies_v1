//
//  Settings.swift
//  Broomies
//
//  Created by Nathan Tu on 8/16/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

//TODO CREATE SEGUES AND PAGES FROM SEGUES & CONNECT SEGUES

import UIKit
import Firebase
import FirebaseAuth

class Settings: UIViewController {
    //iboutlets
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    var userName: String!
    var email: String!
    var phoneNumber: String!
    var houseName: String!
    var type: Int!
    
    var user: User!
    
    @IBAction func nameButtonPressed(_ sender: Any) {
        self.type = 0
        self.performSegue(withIdentifier: "SettingsToChangeNameSegue", sender: self)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        self.type = 2
        self.performSegue(withIdentifier: "SettingsToChangeNameSegue", sender: self)
    }
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
        self.type = 1
        self.performSegue(withIdentifier: "SettingsToChangeNameSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color one is bottom right corner and Color two is top left corner
        self.getUser()
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
    }
    
    func getUser() {
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: { snapshot in
            if (snapshot.exists()) {
                for s in snapshot.children {
                    if ((s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String != self.email) {
                        continue;
                    }
                    self.userName = (s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String
                    self.nameButton.setTitle(self.userName, for: .normal)
                    self.emailButton.setTitle(self.email, for: .normal)
                    self.phoneNumber = (s as! DataSnapshot).childSnapshot(forPath: "/phoneNumber").value as? String
                    self.phoneButton.setTitle(self.phoneNumber, for: .normal)
                }
            }
        })
    }
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsToHomeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SettingsToChangeNameSegue") {
            let vc = segue.destination as! SettingsChangeValue
            if (type == 0) {
                vc.value = self.userName
            } else if (type == 1) {
                vc.value = self.phoneNumber
            } else if (type == 2) {
                vc.value = self.email
            }
            vc.type = self.type
            vc.houseName = self.houseName
            vc.email = self.email
        }
        if (segue.identifier == "SettingsToHomeSegue") {
            let vc = segue.destination as! Home
            vc.fromSettings = true
            vc.userEmail = self.email
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
