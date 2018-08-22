//
//  ToDo.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ToDo: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBAction func InProgressButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ToDoToInProgressSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.layer.borderWidth = 2.0
        label1.layer.borderColor = UIColor.black.cgColor
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
