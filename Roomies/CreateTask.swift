//
//  CreateTask.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class CreateTask: UIViewController {
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateTaskToSettingsSegue", sender: self)
    }
    
    @IBAction func AddNewButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateTaskToAddNewSegue", sender: self)
    }
    
    @IBAction func AddTaskButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CreateTaskToToDoSegue", sender: self)
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
