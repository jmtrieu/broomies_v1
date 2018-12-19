//
//  CellView.swift
//  Broomies
//
//  Created by Cameron Kato on 10/24/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CellView: JTAppleCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    var formattedDate: String!
}
