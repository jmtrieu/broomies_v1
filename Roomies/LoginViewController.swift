//
//  ViewController.swift
//  Roomies
//
//  Created by Nathan Tu on 8/8/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    var houseName: String!
    
    @IBAction func SignInButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
            (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapGestureRecognizer(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.performSegue(withIdentifier: "SignInSegue", sender: self)
                
            })
            
        }
    }
    
    @IBAction func ForgotPasswordButtonPressed(_ sender: Any) {
        
        print("Forgot Password Button Pressed")
        self.performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
    }
    
    func queryUser(email: String) {
        let choresQuery = Database.database().reference().child("users")
        choresQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as! String == email {
                       self.houseName! = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as! String
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signIn.layer.cornerRadius = 5
        signIn.clipsToBounds = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:
            self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeSegue", sender: self)
    }
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "UpSegue", sender: self)
    }
    
    
    /*
    @IBAction func SignInButtonPressed(_ sender: Any) {
        print("Sign In Button Pressed")
        self.performSegue(withIdentifier: "SignInSegue", sender: self)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

