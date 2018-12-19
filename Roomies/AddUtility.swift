//
//  AddUtility.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class AddUtility: UIViewController {
    
    @IBOutlet weak var utilityName: UITextField!
    @IBOutlet weak var utilityAmount: UITextField!
    @IBOutlet weak var utilityDueDate: UIDatePicker!
    
    @IBOutlet weak var utilityUser: UITextField!
    @IBOutlet weak var utilityComment: UITextView!
    
    @IBOutlet weak var settingsMenu: UIView!
    @IBOutlet weak var blackMenu: UIView!
    var user: User!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    let maxSettings:CGFloat = 1.0
    let maxBlack:CGFloat = 0.5
    
    var houseName: String!
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddBillToSettingsSegue", sender: self)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddBillToAddNewSegue", sender: self)
    }
    
    @IBAction func AddBillButtonPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let billsDB = Database.database().reference().child("bills")
        let billsDictionary : NSDictionary = [
                                               "user" : Auth.auth().currentUser!.email as String!,
                                               "amount" : utilityAmount.text!,
                                               "comments" : utilityComment.text!,
                                               "done" : "f",
                                               "duedate" : formatter.string(from: utilityDueDate.date),
                                               "enumID" : 2,
                                               "id" : 2,
                                               "inProgress" : "f",
                                               "name" : utilityName.text!,
                                               "toDo" : "t",
                                               "whenMade" : Date.init().description
                                            ]
        billsDB.childByAutoId().setValue(billsDictionary) {
            (error, ref) in
            if error != nil {
                print(error!)
            } else {
                print("Message saved successfully!")
            }
        }
        self.performSegue(withIdentifier: "AddBillToHomeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        settingsMenu.isHidden = true;
        blackMenu.isHidden = true;
    }
    
    
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
        if settingsMenu.isHidden == true {
            self.viewSettings()
        } else {
            self.hideSettings()
        }
    }
    
    @IBAction func viewSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.settingsMenu.alpha = 1
                        self.blackMenu.alpha = self.maxBlack
                        self.settingsMenu.isHidden = false;
                        self.blackMenu.isHidden = false;
        },
                       completion: { (complete) in print("complete")
        }
        )
    }
    
    @IBAction func hideSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.settingsMenu.alpha = self.maxSettings
                        self.settingsMenu.isHidden = true;
                        self.blackMenu.isHidden = true;
        },
                       completion: { (complete) in print("complete")
        }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeHouseButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangePasswordSegue", sender: self)
    }
    
    @IBAction func ChangeEmailButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangeEmailSegue", sender: self)
    }
    
    @IBAction func ChangePasswordButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangePasswordSegue", sender: self)
    }
    
}
