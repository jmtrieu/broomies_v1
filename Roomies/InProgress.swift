//
//  InProgress.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class InProgress: UIViewController {
    
    @IBAction func ChoresDoneButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "InProgressToDoneSegue", sender: self)
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
