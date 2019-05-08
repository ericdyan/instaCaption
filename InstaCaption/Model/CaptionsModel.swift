//
//  File.swift
//  InstaCaption
//
//  Created by Eric Yang on 4/23/19.
//  Copyright © 2019 Eric Yang. All rights reserved.
//

import Foundation


class CaptionsModel {
    // Singleton
    public static var shared  = CaptionsModel()
    private var captions : [Caption]
    private var locations: [Location] = []
    init() {
        captions = [
            Caption(faces: 0, caption: "People are overrated"),
            Caption(faces: 1, caption: "Han Solo"),
            Caption(faces: 2, caption: "Dynamic Duo"),
            Caption(faces: 3, caption: "Three Musketeers"),
            Caption(faces: 4, caption: "Thankful 4 you"),
            Caption(faces: 5, caption: "Squad"),
            Caption(faces: 100, caption: "The more the merrier")
        ]
    }
    // Methods
    func returnCaptions(faces : Int) -> [Caption] {
        var returnArray : [Caption] = []
        for i in 0..<captions.count {
            if captions[i].numberOfFaces == faces || captions[i].numberOfFaces >= faces {
                returnArray.append(captions[i])
            }
        }
        return returnArray
    }
    func returnLocation() -> Location {
        if locations.count >= 1 {
            return locations[locations.count - 1]
        } else {
            return Location(name: "Open Maps", country: "To", state: "View", city: "Your Location")
        }
    }
    
    func storeLocations (name : String?, country : String?, state : String?, city : String?) {
        locations.append(Location(name: name, country: country, state: state, city: city))
    }
}
