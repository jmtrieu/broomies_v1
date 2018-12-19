//
//  User.swift
//  Broomies
//
//  Created by Cameron Kato on 11/9/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

struct myUser {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let house: String

    init(first: String, last: String, email: String, phone: String, house: String) {
        self.firstName = first
        self.lastName = last
        self.email = email
        self.phoneNumber = phone
        self.house = house
    }
}
