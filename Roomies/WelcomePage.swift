//
//  Welcome.swift
//  Broomies
//
//  Created by Andrew Yan on 11/18/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class WelcomePage: UIViewController {
    
    var ref: DatabaseReference!
    var user: User!
    var houseName: String!
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var curUserEmail: String!
    var uid: Int!
    
    var fromJoin =  false
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "WelcomePagetoHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        buildUser()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "WelcomePagetoHome") {
            let vc = segue.destination as! Home
            vc.houseName = houseName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildUser() {
        let usersDB = Database.database().reference().child("users")
        if (fromJoin) {
            let usersDictionary : NSDictionary = ["house" : houseName!,
                                                  "houseID" : self.uid,
                                                  "firstName" : firstName!,
                                                  "lastName" : lastName!,
                                                  "email" : curUserEmail!,
                                                  "phoneNumber" : phoneNumber!,
                                                  "enumID" : 2,
                                                  "id" : 2,
                                                  ]
            usersDB.child(firstName!).setValue(usersDictionary) {
                (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    print("Message saved successfully!")
                }
              }
            } else {
                let usersDictionary : NSDictionary = ["house" : houseName!,
                                                      "houseID" : UUID().hashValue,
                                                      "firstName" : firstName!,
                                                      "lastName" : lastName!,
                                                      "email" : curUserEmail!,
                                                      "phoneNumber" : phoneNumber!,
                                                      "enumID" : 2,
                                                      "id" : 2,
                                                      ]
                usersDB.child(firstName!).setValue(usersDictionary) {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Message saved successfully!")
                    }
            }
        
       
        }
    }
}
