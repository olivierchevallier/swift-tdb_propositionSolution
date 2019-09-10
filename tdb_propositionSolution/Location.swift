//
//  Location.swift
//  tdb_propositionSolution
//
//  Created by olivier chevallier on 10.09.19.
//  Copyright © 2019 Olivier Chevallier. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    //MARK: Properties
    var name: String
    var coordinate: CLLocationCoordinate2D
    var postcode: String
    var place: String
    var region: String
    var country: String
    
    init(name: String, coordinate: CLLocationCoordinate2D, postcode: String, place: String, region: String, country: String) {
        self.name = name
        self.coordinate = coordinate
        self.postcode = postcode
        self.place = place
        self.region = region
        self.country = country
    }
    
    
}
