//
//  UserView.swift
//  Broomies
//
//  Created by Cameron Kato on 11/9/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class UserView: UICollectionViewCell {
    @IBOutlet weak var userName: UILabel!
    var user: myUser!
    
    @IBOutlet weak var remainingTask: UILabel!
    
    func displayContent(name: String, tasks: String, user: myUser) {
        userName.text = name
        remainingTask.text = tasks
        self.user = user
    }
    
   /* @IBAction func tapGesturePressed(_ sender: Any) {
        addButtonTapAction?()
    }
    var addButtonTapAction : (()->())?*/
}
