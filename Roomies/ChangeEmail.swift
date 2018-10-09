//
//  ChangeEmail.swift
//  Broomies
//
//  Created by Nathan Tu on 8/29/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ChangeEmail: UIViewController {
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ChangeEmailToSettingsSegue", sender: self)
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
