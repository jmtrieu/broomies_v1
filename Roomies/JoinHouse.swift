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

class JoinHouse: UIViewController {
    
    var ref: DatabaseReference!
    var user: User!
    
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    var curUserEmail: String!
    var houseName: String!
    var uid: Int!

    @IBOutlet weak var houseID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if houseID.text?.isEmpty ?? true  {
            let alertController = UIAlertController(title: "Invalid HouseID", message: "Please enter an ID.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.joinHouse(id: self.houseID!.text!)
        }
    }
    
    func joinHouse(id: String) {
        let myId = Int(id)
        self.uid = myId
        let ref = Database.database().reference().child("/users")
        ref.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/houseID").value as? Int == myId {
                        self.houseName = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String
                    }
                }
                if (self.houseName != nil) {
                    self.performSegue(withIdentifier: "JoinHouseToWelcomeSegue", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Invalid HouseID", message: "Please enter a different ID.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "JoinHouseToWelcomeSegue") {
            let wc = segue.destination as! WelcomePage
            wc.houseName = houseName
            wc.firstName = firstName!
            wc.lastName = lastName!
            wc.phoneNumber = phoneNumber!
            wc.curUserEmail = curUserEmail!
            wc.uid = uid!
            wc.fromJoin = true
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
