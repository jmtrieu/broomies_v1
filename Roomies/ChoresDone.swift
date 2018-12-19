//
//  ChoresDone.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

//TODO Implement the table and image

import UIKit
import Firebase
import FirebaseAuth

class ChoresDone: UIViewController {
    
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backSegueToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gradientView.setGradientBackground(colorOne: UIColor(red: 0, green: 0.37, blue: 0.47, alpha: 1.0), colorTwo: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8))
    }
    //HomeToChoresDone
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
