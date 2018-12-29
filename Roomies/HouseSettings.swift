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
        let defaultAction = UIAlertAction(title: "Leave", style: .default, handler: { _  in
                self.performSegue(withIdentifier: "LeaveHouseSegue", sender: self)
            })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HouseToSettingsSegue") {
            let vc = segue.destination as! Settings
            vc.houseName = self.houseName
            vc.email = self.email
        }
        if (segue.identifier == "LeaveHouseSegue") {
            let vc = segue.destination as! NoHouse
            vc.fromSettings = true
        }
    }
    
    
}
