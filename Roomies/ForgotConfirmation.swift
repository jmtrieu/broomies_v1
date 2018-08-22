//
//  ForgotConfirmation.swift
//  Roomies
//
//  Created by Nathan Tu on 8/12/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ForgotConfirmation: UIViewController {
    
    @IBAction func PasswordResetPressed(_ sender: Any) {
        
        print("Password Reset!")
        
        self.performSegue(withIdentifier: "HomeResetSegue", sender: self)
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
