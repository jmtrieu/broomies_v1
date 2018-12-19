//
//  CompletedTask.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class CompletedTask: UIViewController {
    
    @IBOutlet weak var settingsMenu: UIView!
    @IBOutlet weak var blackMenu: UIView!
    
    let maxSettings:CGFloat = 1.0
    let maxBlack:CGFloat = 0.5
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToSettingsSegue", sender: self)
    }
    
    @IBAction func AddNewButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToAddNewSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToHomeSegue", sender: self)
    }
    
    @IBAction func CalendarButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToCalendarSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToChartsSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToNotificationsSegue", sender: self)
    }
    
    @IBAction func CompleteButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CompletedToApprovalSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        settingsMenu.isHidden = true;
        blackMenu.isHidden = true;
    }
    
    //calls view Settings to show hamburger menu
    @IBAction func gestureTap(_ sender: UITapGestureRecognizer) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

