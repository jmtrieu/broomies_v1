//
//  ChangePassword.swift
//  Broomies
//
//  Created by Nathan Tu on 8/29/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangePassword: UIViewController {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordConfirm: UITextField!
    @IBOutlet weak var gradientView: UIView!
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "BackButtonToHome", sender: self)
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        let newPass = newPassword.text
        let newPassConfirm = newPasswordConfirm.text
        
        //Check if the old password field matches the password in database
        
        //Check if new password field is filled out
        if newPassword.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid New Password", message: "Please enter a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        //Check if entered passwords match
        if newPass != newPassConfirm {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Entered passwords are not matching. Please retype password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        //Error checks complete save the new password name
        else {
            self.performSegue(withIdentifier: "ChangePasswordToHomeSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(red: 0, green: 0.37, blue: 0.47, alpha: 1.0), colorTwo: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
