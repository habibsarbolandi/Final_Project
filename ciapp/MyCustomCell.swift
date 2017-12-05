//
//  MyCustomCell.swift
//  ciapp
//
//  Created by kwame on 11/5/17.
//  Copyright © 2017 iOS class. All rights reserved.
//

import UIKit

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    //locationIcon is of type UILabel because though an icon, it's just a text with 
    //font family FontAwesome
    
    @IBOutlet weak var locationIconLabel: UILabel!
    
    @IBOutlet weak var businessLocationLabel: UILabel!
    @IBOutlet weak var servicesDescLabel: UILabel!
}

