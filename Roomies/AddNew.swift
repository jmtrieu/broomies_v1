//
//  AddNew.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class AddNew: UIViewController {
    @IBOutlet weak var settingsMenu: UIView!
    @IBOutlet weak var blackMenu: UIView!
    
    let maxSettings:CGFloat = 1.0
    let maxBlack:CGFloat = 0.5
    var houseName: String!
    
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToNotificationsSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToHomeSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToChartsSegue", sender: self)
    }
    
    @IBAction func AddTaskButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewToTaskSegue", sender: self)
    }
    
    
    @IBAction func AddBillButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewToBillSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToCalendarSegue", sender: self)
    }
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddNewToSettingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddNewToTaskSegue") {
            let vc = segue.destination as! CreateTask
            vc.houseName = self.houseName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        settingsMenu.isHidden = true
        blackMenu.isHidden = true
    }
    @IBAction func gestureTap(_ sender: Any) {
        if settingsMenu.isHidden == true {
            self.viewSettings()
        } else {
            self.hideSettings()
        }
    }
    
    @IBAction func viewSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.settingsMenu.alpha = 1
                        self.blackMenu.alpha = self.maxBlack
                        self.settingsMenu.isHidden = false;
                        self.blackMenu.isHidden = false;
        },
                       completion: { (complete) in print("complete")
        }
        )
    }
    
    @IBAction func hideSettings() {
        // Do any additional setup after loading the view, typically from a nib.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.settingsMenu.alpha = self.maxSettings
                        self.settingsMenu.isHidden = true;
                        self.blackMenu.isHidden = true;
        },
                       completion: { (complete) in print("complete")
        }
        )
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
