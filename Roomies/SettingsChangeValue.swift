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
    var value: String!
    @IBOutlet weak var textField: UITextField!
    var type: Int!
    var key: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
            self.textField.text = self.value
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
 
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ChangeNameToSettingsSegue", sender: self)
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        var changes: [AnyHashable : Any]!
        if (self.type == 0) {
            changes = ["firstName": self.textField.text as! String]
        }
        let ref = Database.database().reference().child("/users").child(self.key)
        ref.updateChildValues(changes as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if err != nil {
                return
            }
        })
        self.performSegue(withIdentifier: "SaveChangeNameToSettingsSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
