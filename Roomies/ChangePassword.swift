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
        
        self.performSegue(withIdentifier: "ChangePasswordToHomeSegue", sender: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
            let myUser = Auth.auth().currentUser
            let email = myUser?.email
           // let credential = EmailAuthProvider.credential(withEmail: email!, password: newPass!)
            Auth.auth().signIn(withEmail: email!, password: currentPassword.text!) {
                (user, error) in
         //   user?.reauthenticate(with: credential, completion: { (error) in
                if error != nil{
                    let alertController = UIAlertController(title: "Password Incorrect", message: "Current Password is incorrect, please re-enter.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    //change to new password
                    myUser?.updatePassword(to: newPass!) { (error) in
                        if error != nil {
                            print("error")
                            return
                        } else {
                            self.performSegue(withIdentifier: "ChangePasswordToHomeSegue", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(hex: "005F77"), colorTwo: UIColor(hex: "3F8698"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
