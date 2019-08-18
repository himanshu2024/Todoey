//
//  Item.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 18/08/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import Foundation

class Item {
    var name : String = ""
    var checked : Bool = false
    
    init(name : String) {
        self.name = name
        self.checked = false
    }
}
