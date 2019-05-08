//
//  Captions.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/23/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import Foundation

struct Caption {
    // Properties
    let numberOfFaces : Int
    let text : String
    
    init(faces : Int, caption : String) {
        self.numberOfFaces = faces
        self.text = caption
    }
    
}
