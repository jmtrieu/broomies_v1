//
//  Calendar.swift
//  Broomies
//
//  Created by Nathan Tu on 8/16/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class Calendar: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToSettingsSegue", sender: self)
    }
    
    
    @IBAction func AddNewButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToAddNewSegue", sender: self)
    }
    
    @IBAction func HomeButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToHomeSegue", sender: self)
    }
    
    @IBAction func ChartsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToChartsSegue", sender: self)
    }
    
    @IBAction func NotificationsButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "CalendarToNotificationsSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // label1 border set-up
        label1.layer.borderWidth = 2.0
        label1.layer.borderColor = UIColor.black.cgColor
        
        // label2 border set-up
        label2.layer.borderWidth = 2.0
        label2.layer.borderColor = UIColor.black.cgColor
        
        //label3 border set-up
        label3.layer.borderWidth = 2.0
        label3.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
