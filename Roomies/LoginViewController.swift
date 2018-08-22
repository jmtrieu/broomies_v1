//
//  ViewController.swift
//  Roomies
//
//  Created by Nathan Tu on 8/8/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func ForgotPasswordButtonPressed(_ sender: Any) {
        
        print("Forgot Password Button Pressed")
        self.performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
    }
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        
        print("Sign Up Button Pressed")
        self.performSegue(withIdentifier: "SignUp1Segue", sender: self)
    }
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        print("Sign In Button Pressed")
        self.performSegue(withIdentifier: "SignInSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

