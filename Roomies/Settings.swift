//
//  Settings.swift
//  Broomies
//
//  Created by Nathan Tu on 8/16/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

//TODO CREATE SEGUES AND PAGES FROM SEGUES & CONNECT SEGUES

import UIKit
import Firebase
import FirebaseAuth

class Settings: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color one is bottom right corner and Color two is top left corner
        gradientView.setGradientBackground(colorOne: UIColor(red: 0, green: 0.37, blue: 0.47, alpha: 1.0), colorTwo: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
