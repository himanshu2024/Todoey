//
//  Category.swift
//  Todoey
//
//  Created by Himanshu Chaurasiya on 01/09/19.
//  Copyright © 2019 HPC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
