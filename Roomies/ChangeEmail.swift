//
//  ChangeEmail.swift
//  Broomies
//
//  Created by Nathan Tu on 8/29/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ChangeEmail: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var emailField: UITextField!
        //TODO check to make sure the changed UITextField is a correct email

    @IBAction func backButtonPressed(_ sender: Any) {
        //TODO save the new name to the data base
        self.performSegue(withIdentifier: "ChangeEmailToSettingsSegue", sender: self)
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        //TODO save the new name to the data base
        self.performSegue(withIdentifier: "ChangeEmailToHomeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Display user's email field name
        
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(red: 0, green: 0.37, blue: 0.47, alpha: 1.0), colorTwo: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
