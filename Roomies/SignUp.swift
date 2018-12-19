//
//  SignUp.swift
//  Roomies
//
//  Created by Nathan Tu on 8/12/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUp: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        let pass = password.text
        let passConfirm = passwordConfirm.text
        
        //Check if the email and password field were filled out
        if email.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid Email", message: "Please enter an email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if password.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid Password", message: "Please enter a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        //Check if entered passwords match
        if pass != passConfirm {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Entered passwords are not matching. Please retype password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
                (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "SignUp2Segue", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SignUp2Segue") {
            let vc = segue.destination as! AccountInformation
            vc.curUserEmail = email.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
