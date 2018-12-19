//
//  ChoresDataSource.swift
//  Broomies
//
//  Created by Cameron Kato on 10/20/18.
//  Copyright © 2018 Nathan Tu. All rights reserved.
//

import UIKit

class ToDoDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var toDoArray: [String] = []
    
    override init() {
        super.init()
    }
    
    func setData(items:[String]) {
        self.toDoArray = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell.textLabel!.text = toDoArray[indexPath.row]
        
        return cell
    }
}
