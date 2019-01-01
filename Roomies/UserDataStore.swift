//
//  UserDataStore.swift
//  Broomies
//
//  Created by Cameron Kato on 11/9/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

final class UserDataStore {
    var houseName: String!
    
    var user: User!
    
    init(name: String) {
        houseName = name
    }
    
    var users: [myUser] = []
    
    func getUsers(completion: @escaping () -> Void) {
        self.user = Auth.auth().currentUser!
        
        let houseQuery = Database.database().reference().child("users")
        houseQuery.observe(.value, with: { snapshot in
            if snapshot.exists() {
                for s in snapshot.children {
                    if (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String == self.houseName {
                        let first = (s as! DataSnapshot).childSnapshot(forPath: "/firstName").value as? String
                        let last = (s as! DataSnapshot).childSnapshot(forPath: "/lastName").value as? String
                        let email = (s as! DataSnapshot).childSnapshot(forPath: "/email").value as? String
                        let phoneNumber = (s as! DataSnapshot).childSnapshot(forPath: "/phoneNumber").value as? String
                        let house = (s as! DataSnapshot).childSnapshot(forPath: "/house").value as? String
                        self.users.append(myUser(first: first!, last: last!, email: email!, phone: phoneNumber!, house: house!))
                    }
                }
                completion()
            }
        })
    }
}
