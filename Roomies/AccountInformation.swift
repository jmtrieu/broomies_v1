//
//  AccountInformation.swift
//  Broomies
//
//  Created by Cameron Kato on 11/8/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class AccountInformation: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var curUserEmail: String!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        //Check for empty text fields
        if firstName.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid First Name", message: "Please enter a first name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if lastName.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid Last Name", message: "Please enter a last name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if phoneNumber.text?.isEmpty ?? true {
            let alertController = UIAlertController(title: "Invalid Phone Number", message: "Please enter a phone number", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            self.performSegue(withIdentifier: "SignUp3Segue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SignUp3Segue") {
            let vc = segue.destination as! BuildHouse
            vc.curUserEmail = curUserEmail
            vc.phoneNumber = phoneNumber.text
            vc.firstName = firstName.text
            vc.lastName = lastName.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
