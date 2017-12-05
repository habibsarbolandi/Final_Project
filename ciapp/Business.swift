//
//  File.swift
//  ciapp
//
//  Created by kwame on 11/6/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import Foundation

//class for Businesses

class Business {
    var id:Int
    var name: String
    var services:String
    var location:String
    var direction:String
    var workingHours:String
    var contact:String
    
    init(id: Int, name: String, services: String, location: String, direction: String, workingHours: String, contact: String) {
        self.id = id
        self.name = name
        self.services = services
        self.location = location
        self.direction = direction
        self.workingHours = workingHours
        self.contact = contact
    }
}
