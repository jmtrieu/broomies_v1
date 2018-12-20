//
//  CreateTask.swift
//  Broomies
//
//  Created by Nathan Tu on 8/15/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import Firebase
import CoreGraphics
import PhotosUI

class CreateTask: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //buttons
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var cleaningButton: UIButton!
    @IBOutlet weak var billsButton: UIButton!
    var sbPressed = false
    var cbPressed = false
    var bbPressed = false
    
    var fromSingleUser = false
    var fromCalendar = false
    
    @IBOutlet weak var taskDueDate: UIDatePicker!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    var curUserEmail: String = ""
    var curUserName: String = ""
    
    //nc listens for select user
    let nc = NotificationCenter.default
    var passedVal: String!
    var passedDate: Date!
    
    var houseName: String!
    var category: String!
    
    var user: User!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    @IBOutlet weak var usersTable: UITableView!
    var usersDataSource: UserCellDataSource!
    var usersArray = [String]()
    
    @IBOutlet weak var taskNameBar: UIView!
    var taskNameBarTapped = false;
    
    @IBOutlet weak var assignToBar: UIView!
    var assignToBarTapped = false;
    
    @IBOutlet weak var imagePreview: UIImageView!
    var imageURL: URL!
    
    @objc func getValue(notification: Notification) {
        let userInfo:Dictionary<String, String> = notification.userInfo as! Dictionary<String, String>
        let item = userInfo["user"]! as String
        self.userName.text! = item
        self.userName.textColor = UIColor.black
    }
    
    func prepareUsersTable(){
        let items1 = usersArray
        usersDataSource = UserCellDataSource(house: self.houseName!)
        self.usersTable.dataSource = usersDataSource
        self.usersTable.delegate = usersDataSource
        usersDataSource.setData(items: items1)
        self.usersTable.register(UINib(nibName: "UserCellView", bundle: Bundle.main), forCellReuseIdentifier: "UserCellView")
        self.usersTable.tableFooterView = UIView()
    }
    
    
    @IBAction func shoppingButtonPresed(_ sender: Any) {
        if (!sbPressed) {
            shoppingButton.setTitleColor(UIColor(hex: "4A84D2"), for: [])
            cleaningButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            billsButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            sbPressed = true
            cbPressed = false
            bbPressed = false
            taskNameBar.frame.size.height = 1
            taskNameBarTapped = false
            assignToBar.frame.size.height = 1
            assignToBarTapped = false
            usersTable.isHidden = true
        }
    }
    @IBAction func cleaningButtonPressed(_ sender: Any) {
        if (!cbPressed) {
            shoppingButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            cleaningButton.setTitleColor(UIColor(hex: "4A84D2"), for: [])
            billsButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            cbPressed = true
            sbPressed = false
            bbPressed = false
            taskNameBar.frame.size.height = 1
            taskNameBarTapped = false
            assignToBar.frame.size.height = 1
            assignToBarTapped = false
            usersTable.isHidden = true
        }
    }
    
    @IBAction func billsButtonPressed(_ sender: Any) {
        if (!bbPressed) {
            shoppingButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            cleaningButton.setTitleColor(UIColor(hex: "BDBDBD"), for: [])
            billsButton.setTitleColor(UIColor(hex: "48A4D2"), for: [])
            bbPressed = true
            sbPressed = false
            cbPressed = false
            taskNameBar.frame.size.height = 1
            taskNameBarTapped = false
            assignToBar.frame.size.height = 1
            assignToBarTapped = false
            usersTable.isHidden = true
        }
    }
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CancelAddTask", sender: self)
    }
    
    
    
    
    @IBAction func taskNamePressed(_ sender: Any) {
        if (!taskNameBarTapped) {
            //bolden taskBar
            self.taskNameBar.frame.size.height = 2
            taskNameBarTapped = true
            //unbold assigned bar
            assignToBar.frame.size.height = 1
            assignToBarTapped = false
            usersTable.isHidden = true
        } else {
            self.taskNameBar.frame.size.height = 1
            taskNameBarTapped = false
            usersTable.isHidden = true
        }
    }
    
    @IBAction func assignedPressed(_ sender: Any) {
        if (!assignToBarTapped) {
            assignToBar.frame.size.height = 2
            assignToBarTapped = true
            taskNameBar.frame.size.height = 1
            dropDownButton.setImage(UIImage(named: "Vector (4)"), for: UIControlState.normal)
            usersTable.isHidden = false
            taskNameBarTapped = false
        } else {
            
            assignToBar.frame.size.height = 1
            assignToBarTapped = false
            dropDownButton.setImage(UIImage(named: "Vector (1)"), for: UIControlState.normal)
            usersTable.isHidden = true
            taskNameBarTapped = false
        }
    }
    
    func assignCategory() {
        if (self.sbPressed) {
            self.category = "Shopping"
        } else if (self.bbPressed) {
            self.category = "Bill"
        } else {
            self.category = "Cleaning"
        }
    }
    
    @IBAction func AddTaskButtonPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        if ((!bbPressed && !sbPressed && !cbPressed) || taskName.text == "" || userName.text == "") {
            var title = ""
            var message = ""
            if (taskName.text == "") {
                title = "Invalid Task Name"
                message = "Fill out a task"
            }
            if (userName.text == "") {
                title = "Invalid User"
                message = "Fill out a user"
            }
            if (!bbPressed && !sbPressed && !cbPressed) {
                title = "Invalid Category"
                message = "Please select a category"
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.assignCategory()
            let choresDB = Database.database().reference().child("houses").child(houseName!).child("chores")
            if ((imageURL) != nil) {
                let choresDictionary : NSDictionary = ["assignee" : userName.text!,
                                                   "assigner" : self.curUserName,
                                                   "category" : category!,
                                                   "done" : "f",
                                                   "house" : houseName!,
                                                   "duedate" : formatter.string(from: taskDueDate.date),
                                                   "enumID" : 2,
                                                   "id" : 2,
                                                   "inProgress" : "f",
                                                   "image" : imageURL.absoluteString,
                                                   "name" : taskName.text!,
                                                   "toDo" : "t",
                                                   "whenMade" : Date.init().description
                ]
                choresDB.child(Date.init().description).setValue(choresDictionary) {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Message saved successfully!")
                    }
                }
            }
            else {
                let choresDictionary : NSDictionary = ["assignee" : userName.text!,
                                                       "assigner" : self.curUserName,
                                                       "category" : category!,
                                                       "done" : "f",
                                                       "house" : houseName!,
                                                       "duedate" : formatter.string(from: taskDueDate.date),
                                                       "enumID" : 2,
                                                       "id" : 2,
                                                       "inProgress" : "f",
                                                       "image" : "no image",
                                                       "name" : taskName.text!,
                                                       "toDo" : "t",
                                                       "whenMade" : Date.init().description]
                choresDB.child(Date.init().description).setValue(choresDictionary) {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Message saved successfully!")
                    }
                }
            }
            
            self.performSegue(withIdentifier: "CreateTaskToHomeSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CreateTaskToHomeSegue") {
            let vc = segue.destination as! Home
            vc.houseName = self.houseName
        }
    }
    
    @IBAction func showUsersDropdown(_ sender: Any) {
        if (usersTable.isHidden) {
            dropDownButton.setImage(UIImage(named: "Vector (4)"), for: UIControlState.normal)
            usersTable.isHidden = false
            taskNameBarTapped = false
            assignToBarTapped = true
            assignToBar.frame.size.height = 2
        } else {
            dropDownButton.setImage(UIImage(named: "Vector (1)"), for: UIControlState.normal)
            usersTable.isHidden = true
            taskNameBarTapped = false
            assignToBarTapped = false
            assignToBar.frame.size.height = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUser()
        self.taskName.textColor = UIColor.black
        if (self.fromSingleUser) {
            self.userName.text = self.passedVal
        }
        if (self.fromCalendar) {
            self.taskDueDate.date = self.passedDate
        }
        
        taskName.clipsToBounds = true
        userName.clipsToBounds = true
        
        nc.addObserver(self, selector: #selector(self.getValue(notification:)), name: Notification.Name(rawValue: "assigner"), object: nil)
        usersTable.isHidden = true
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        self.tableQueries()
        self.taskName.delegate = self
       // self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getUser() {
        self.curUserEmail = Auth.auth().currentUser!.email!
        
        let houseQuery = Database.database().reference().child("users")
        houseQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String == self.curUserEmail {
                        self.curUserName = ((s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String)!
                    }
                }
            }
        })
    }
    
    
    func tableQueries() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let today = formatter.string(from: Date())
        
        let usersQuery = Database.database().reference().child("users")
        usersQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                print("snaphshot is: ")
                //clears past data
                self.usersArray.removeAll()
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/house").value as! String != self.houseName! {
                        continue;
                    }
                    self.usersArray.append((s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as! String)
                }
            }
            self.prepareUsersTable()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openGalleryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
             imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imagePreview.image = image
        let url = info[UIImagePickerControllerReferenceURL] as? URL
        imageURL = url;
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
}

