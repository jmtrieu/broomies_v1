//
//  ForgotPassword.swift
//  Roomies
//
//  Created by Nathan Tu on 8/10/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {
    
    @IBAction func ContinueButtonPressed(_ sender: Any) {
        
        print("Continue Button Pressed")
        
        self.performSegue(withIdentifier: "ForgotContinueSegue", sender: self)
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
