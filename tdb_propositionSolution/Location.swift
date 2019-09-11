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
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }
    
    convenience init (name: String, coordinate: [Double]){
        self.init(name: name, coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
    }
    
}
