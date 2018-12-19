//
//  InviteHousemates.swift
//  Roomies
//
//  Created by Nathan Tu on 8/12/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BuildHouse: UIViewController {
    
    var ref: DatabaseReference!
    var user: User!
    
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var curUserEmail: String!
    
    @IBOutlet weak var houseName: UITextField!
    @IBOutlet weak var housemateEmail: UITextField!
    @IBOutlet weak var housemateNumber: UITextField!

    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    //Build house invite housemates not yet implemented use housemateEmail & housemateNumber
    @IBAction func nextButtonPressed(_ sender: Any) {
        if houseName.text?.isEmpty ?? true  {
            let alertController = UIAlertController(title: "Invalid Housename", message: "Please enter a housename.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("buildHome fuckmyass swift")
        }
        else {
            self.performSegue(withIdentifier: "buildHome", sender: self)
            print("buildHome shit")
        }
    }
    
    //testing
    @IBAction func skipButtonPressed(_ sender: Any) {
        if houseName.text?.isEmpty ?? true  {
            let alertController = UIAlertController(title: "Invalid Housename", message: "Please enter a housename.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            print("fuckmyass swift")
        }
        else {
            self.performSegue(withIdentifier: "skipBuild", sender: self)
            print("shit")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    //Sends the information through to be used in the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "buildHome") {
            let vc = segue.destination as! WelcomePage
            vc.houseName = houseName.text!
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.phoneNumber = phoneNumber!
            vc.curUserEmail = curUserEmail!
        }
        if (segue.identifier == "skipBuild") {
            let vc = segue.destination as! WelcomePage
            vc.houseName = houseName.text!
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.phoneNumber = phoneNumber!
            vc.curUserEmail = curUserEmail!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func buildUser() {
        let usersDB = Database.database().reference().child("users")
        let usersDictionary : NSDictionary = ["house" : houseName.text!,
                                              "firstName" : firstName!,
                                              "lastName" : lastName!,
                                              "email" : curUserEmail,
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
    */
    
}
