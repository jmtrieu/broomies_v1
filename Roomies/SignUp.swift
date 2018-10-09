//
//  SignUp.swift
//  Roomies
//
//  Created by Nathan Tu on 8/12/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class SignUp: UIViewController {
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        
        print("Next Button Pressed")
        self.performSegue(withIdentifier: "SignUp2Segue", sender: self)
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
