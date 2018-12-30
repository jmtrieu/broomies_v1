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
    var fromPriorAccount = false
    
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
            if snapshot.exists() && myId != 0 {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/houseID").value as? Int == myId {
                        self.houseName = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String
                    }
                }
                if (self.houseName != nil && self.houseName != "NA") {
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
            let myID = uid!
            wc.houseName = houseName
            wc.firstName = firstName!
            wc.lastName = lastName!
            wc.phoneNumber = phoneNumber!
            wc.curUserEmail = curUserEmail!
            wc.uid = myID
            wc.fromJoin = true
            wc.fromPriorAccount = self.fromPriorAccount
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
