//
//  Approval.swift
//  Broomies
//
//  Created by Nathan Tu on 8/17/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase

class Chore: UIViewController {
    @IBOutlet weak var choreName: UILabel!
    var passedChoreName: String!
    var id: Int!
    
    var houseName: String!
    var timeID: String!
    
    @IBOutlet weak var assignedByLabel: UILabel!
    var assigner: String!
    
    var dueDate: Date!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    var type: String!
    
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String!
    
    @IBOutlet weak var myButton: UIButton!
    var done = false
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ChoreToHomeSegue", sender: self)
    }
    
    @IBAction func CompletedButtonPressed(_ sender: Any) {
        let ref = Database.database().reference().child("houses").child(self.houseName).child("/chores").child(self.timeID)
        if (!done) {
            let defaultAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                let changes = [
                    "inProgress": "f",
                    "done": "t"]
                ref.updateChildValues(changes, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        return
                    }
                })
                self.performSegue(withIdentifier: "ChoreToHomeSegue", sender: self)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                print("cancel")
            }
            let alert = UIAlertController(title: "Done",
                                          message: "Are you sure this chore is done?",
                                          preferredStyle: .alert)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        } else {
            let defaultAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                ref.removeValue() { (error, ref) in
                    if error != nil {
                        print("error")
                        return
                    }
                }
                self.performSegue(withIdentifier: "ChoreToHomeSegue", sender: self)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                print("cancel")
            }
            let alert = UIAlertController(title: "Done",
                                          message: "Are you sure you want to delete this chore?",
                                          preferredStyle: .alert)
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ChoreToHomeSegue") {
            let hc = segue.destination as! Home
            hc.houseName = self.houseName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.choreName.text = self.passedChoreName
        if (done) {
            self.myButton.setGradientBackground(colorOne: UIColor(hex: "EB5757"), colorTwo: UIColor(hex: "EB5757"))
            self.myButton.setTitle("Delete Task", for: .normal)
        }
        self.getInfo();
    }
    
    func getInfo() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let ref = Database.database().reference().child("houses").child(self.houseName!).child("chores")
        ref.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/id").value as? Int == self.id {
                        self.assigner = (s as! DataSnapshot).childSnapshot(forPath: "/assigner").value as? String
                        self.type = (s as! DataSnapshot).childSnapshot(forPath: "/category").value as? String
                        self.typeLabel.text = "Type: " + self.type
                        self.imageURL = (s as! DataSnapshot).childSnapshot(forPath: "/image").value as? String
                        self.timeID = (s as! DataSnapshot).childSnapshot(forPath: "/whenMade").value as? String
                        //takes care of duedate
                        self.dueDate = formatter.date(from: ((s as! DataSnapshot).childSnapshot(forPath: "/duedate").value as? String)!)
                        self.dueDateLabel.text = "Due on " + dateFormatter.string(from: self.dueDate)
                    }
                    
                }
                self.assignedByLabel.text = "Assigned by " + self.assigner
                if (self.imageURL == "no image") {
                    if (self.type == "Cleaning") {
                        self.imageView.image = UIImage(named: "cleaning")
                    } else if (self.type == "Shopping") {
                        self.imageView.image = UIImage(named: "Vector")
                    } else {
                        self.imageView.image = UIImage(named: "sidebar_payments")                }
                } else {
                    
                    
                    let url = URL(string: self.imageURL)
                    if let data = try? Data(contentsOf: url!)
                    {
                        self.imageView.image = UIImage(data: data)
                    } else {
                        if (self.type == "Cleaning") {
                            self.imageView.image = UIImage(named: "cleaning")
                        } else if (self.type == "Shopping") {
                            self.imageView.image = UIImage(named: "Vector")
                        } else {
                            self.imageView.image = UIImage(named: "sidebar_payments")                }
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

