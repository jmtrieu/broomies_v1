//
//  AddNew.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class AddNew: UIViewController {
    
    @IBAction func AddTaskButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToTaskSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToNotificationsSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToHomeSegue", sender: self)
    }
    
    @IBAction func AddBillButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToBillSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToChartsSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToCalendarSegue", sender: self)
    }
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToSettingsSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
