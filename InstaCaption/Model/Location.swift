//
//  Location.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/29/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import Foundation

struct Location {
    
    let name : String?
    let country : String?
    let state : String?
    let city : String?
    
    init(name : String?, country : String?, state : String?, city : String?) {
        self.name = name
        self.country = country
        self.state = state
        self.city = city
    }
}
