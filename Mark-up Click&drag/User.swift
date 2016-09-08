//
//  User.swift
//  Mark-up Click&drag
//
//  Created by Qualan Woodard on 8/28/16.
//  Copyright © 2016 Pushbox, LLC'. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var dateCreated: String = ""
    var scores: [Int]!
    var age: Int!
    var profilepic: UIImage?
    
    convenience init(name: String, profilepic: UIImage) {
        self.init()
        self.name = name
        self.profilepic = profilepic
    }
    
    
}

class Score: NSObject {
    var num: Float!
    var date: String!
    var program: String!
    
    convenience init(num: Float, date: String!, program: String) {
        self.init()
        self.num = num
        self.date = date
        self.program = program
    }
}