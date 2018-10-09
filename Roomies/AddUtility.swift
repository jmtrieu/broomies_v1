//
//  AddUtility.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class AddUtility: UIViewController {
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddBillToSettingsSegue", sender: self)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddBillToAddNewSegue", sender: self)
    }
    
    @IBAction func AddBillButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddBillToHomeSegue", sender: self)
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
