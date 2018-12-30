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
    var fromLogin = false
    
    var fromJoin =  false
    var fromPriorAccount = false
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        self.buildUser()
        self.performSegue(withIdentifier: "WelcomePagetoHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        user = Auth.auth().currentUser
        ref = Database.database().reference()
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
        let ref = Database.database().reference().child("/users")
        if (fromJoin) {
            if (fromPriorAccount) {
                ref.observe(.value, with: { snapshot in
                    if (snapshot.exists()) {
                        for s in snapshot.children {
                            if ((s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email) {
                                let key = (s as! DataSnapshot).key
                                let changes : [String : Any] = [
                                    "/house": self.houseName!,
                                    "/houseID": self.uid!
                                ]
                                ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                                    if err != nil {
                                        return
                                    }
                                })
                                break
                            }
                        }
                    }
                })
            }
            else {
                let usersDictionary : NSDictionary = ["house" : houseName!,
                                                      "houseID" : self.uid,
                                                      "firstName" : firstName!,
                                                      "lastName" : lastName!,
                                                      "email" : curUserEmail!,
                                                      "phoneNumber" : phoneNumber!,
                                                      "enumID" : 2,
                                                      "id" : 2,
                                                      ]
                ref.child(firstName!).setValue(usersDictionary) {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Message saved successfully!")
                    }
                }
            }
        } else if (fromLogin) {
            ref.observe(.value, with: { snapshot in
                if (snapshot.exists()) {
                    for s in snapshot.children {
                        if ((s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == Auth.auth().currentUser?.email) {
                            let key = (s as! DataSnapshot).key
                            let changes : [String: Any] = [
                                "house": self.houseName!,
                                "houseID": UUID().hashValue]
                            ref.child(key).updateChildValues(changes, withCompletionBlock: { (err, ref) in
                                if err != nil {
                                    return
                                }
                            })
                            break
                        }
                    }
                }
            })
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
                ref.child(firstName!).setValue(usersDictionary) {
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
