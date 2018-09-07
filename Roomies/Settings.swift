//
//  Settings.swift
//  Broomies
//
//  Created by Nathan Tu on 8/16/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    
    @IBAction func AddNewButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToAddNewSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToHomeSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToCalendarSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChartsSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToNotificationsSegue", sender: self)
    }
    
    @IBAction func ChangeHouseButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangePasswordSegue", sender: self)
    }
    
    @IBAction func ChangeEmailButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangeEmailSegue", sender: self)
    }
    
    @IBAction func ChangePasswordButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SettingsToChangePasswordSegue", sender: self)
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
